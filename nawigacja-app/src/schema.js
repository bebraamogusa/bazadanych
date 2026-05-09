async function loadSchema(pool) {
  const [tables] = await pool.query(
    "SELECT table_name FROM information_schema.tables WHERE table_schema = DATABASE() ORDER BY table_name"
  );

  const [columns] = await pool.query(
    "SELECT table_name, column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema = DATABASE() ORDER BY table_name, ordinal_position"
  );

  const [relations] = await pool.query(
    "SELECT table_name AS from_table, column_name AS from_column, referenced_table_name AS to_table, referenced_column_name AS to_column FROM information_schema.key_column_usage WHERE table_schema = DATABASE() AND referenced_table_name IS NOT NULL ORDER BY table_name, column_name"
  );

  const tableMap = new Map();
  for (const row of tables) {
    const tableName = row.table_name || row.TABLE_NAME;
    tableMap.set(tableName, { name: tableName, columns: [] });
  }

  for (const col of columns) {
    const tableName = col.table_name || col.TABLE_NAME;
    const columnName = col.column_name || col.COLUMN_NAME;
    const dataType = col.data_type || col.DATA_TYPE;
    const isNullable = col.is_nullable || col.IS_NULLABLE;

    const table = tableMap.get(tableName);
    if (!table) {
      continue;
    }
    table.columns.push({
      name: columnName,
      type: dataType,
      nullable: isNullable === "YES"
    });
  }

  return {
    tables: Array.from(tableMap.values()),
    relations: relations.map((rel) => ({
      fromTable: rel.from_table || rel.FROM_TABLE,
      fromColumn: rel.from_column || rel.FROM_COLUMN,
      toTable: rel.to_table || rel.TO_TABLE,
      toColumn: rel.to_column || rel.TO_COLUMN
    }))
  };
}

module.exports = { loadSchema };
