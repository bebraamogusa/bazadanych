require("dotenv").config();

const fs = require("fs");
const path = require("path");
const { parse } = require("csv-parse");
const mysql = require("mysql2/promise");

const CSV_DIR = process.env.CSV_DIR
  ? path.resolve(process.env.CSV_DIR)
  : path.resolve(__dirname, "..", "..", "import danych");

const TABLES = [
  { table: "tbl_planety", file: "tbl_planety.csv" },
  { table: "tbl_obserwatoria", file: "tbl_obserwatoria.csv" },
  { table: "tbl_instrumenty_nawigacyjne", file: "tbl_instrumenty_nawigacyjne.csv" },
  { table: "tbl_misje", file: "tbl_misje.csv" },
  { table: "tbl_trasy_nawigacyjne", file: "tbl_trasy_nawigacyjne.csv" },
  { table: "tbl_logi_nawigacyjne", file: "tbl_logi_nawigacyjne.csv" }
];

async function readCsv(filePath) {
  return new Promise((resolve, reject) => {
    const records = [];
    fs.createReadStream(filePath)
      .pipe(
        parse({
          columns: true,
          skip_empty_lines: true,
          trim: true
        })
      )
      .on("data", (row) => records.push(row))
      .on("error", reject)
      .on("end", () => resolve(records));
  });
}

function normalizeValue(value) {
  if (value === undefined || value === null) {
    return null;
  }
  const text = String(value).trim();
  if (!text || text.toUpperCase() === "NULL") {
    return null;
  }
  return text;
}

async function insertRows(pool, table, rows) {
  if (!rows.length) {
    return;
  }

  const columns = Object.keys(rows[0]);
  const columnList = columns.map((col) => `\`${col}\``).join(",");
  const chunkSize = 500;

  for (let i = 0; i < rows.length; i += chunkSize) {
    const chunk = rows.slice(i, i + chunkSize);
    const placeholders = chunk
      .map(() => `(${columns.map(() => "?").join(",")})`)
      .join(",");

    const values = chunk.flatMap((row) =>
      columns.map((col) => normalizeValue(row[col]))
    );

    const sql = `INSERT INTO \`${table}\` (${columnList}) VALUES ${placeholders}`;
    await pool.query(sql, values);
  }
}

async function main() {
  const pool = mysql.createPool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 5
  });

  try {
    for (const entry of TABLES) {
      const filePath = path.join(CSV_DIR, entry.file);
      if (!fs.existsSync(filePath)) {
        throw new Error(`missing CSV: ${filePath}`);
      }
      const rows = await readCsv(filePath);
      await insertRows(pool, entry.table, rows);
      console.log(`imported ${rows.length} rows into ${entry.table}`);
    }
  } finally {
    await pool.end();
  }
}

main().catch((error) => {
  console.error("import failed", error.message);
  process.exitCode = 1;
});
