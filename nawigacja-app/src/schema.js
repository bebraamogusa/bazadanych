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
    tableMap.set(row.table_name, { name: row.table_name, columns: [] });
  }

  for (const col of columns) {
    const table = tableMap.get(col.table_name);
    if (!table) {
      continue;
    }
    table.columns.push({
      name: col.column_name,
      type: col.data_type,
      nullable: col.is_nullable === "YES"
    });
  }

  return {
    tables: Array.from(tableMap.values()),
    relations: relations.map((rel) => ({
      fromTable: rel.from_table,
      fromColumn: rel.from_column,
      toTable: rel.to_table,
      toColumn: rel.to_column
    }))
  };
}

module.exports = { loadSchema };
