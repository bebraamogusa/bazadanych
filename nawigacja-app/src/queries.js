const fs = require("fs");
const path = require("path");

const appRoot = path.resolve(__dirname, "..");

function resolveQueryFile() {
  if (process.env.QUERY_FILE) {
    return path.isAbsolute(process.env.QUERY_FILE)
      ? process.env.QUERY_FILE
      : path.resolve(appRoot, process.env.QUERY_FILE);
  }
  return path.resolve(appRoot, "..", "import danych", "nawigacja_gwiezdna_select.sql");
}

function parseQueries(sqlText) {
  const lines = sqlText.split(/\r?\n/);
  const queries = [];
  let currentId = null;
  let currentTitle = null;
  let buffer = [];

  const flush = () => {
    if (currentId === null) {
      buffer = [];
      return;
    }
    const sql = buffer.join("\n").trim();
    if (sql) {
      queries.push({ id: currentId, title: currentTitle, sql });
    }
    buffer = [];
    currentId = null;
    currentTitle = null;
  };

  for (const line of lines) {
    const headerMatch = line.match(/^--\s*(\d+)\.\s*(.*)$/);
    if (headerMatch) {
      if (buffer.length) {
        flush();
      }
      currentId = Number(headerMatch[1]);
      currentTitle = (headerMatch[2] || "").trim() || `Query ${currentId}`;
      continue;
    }

    if (currentId === null) {
      continue;
    }

    buffer.push(line);
    if (line.includes(";")) {
      flush();
    }
  }

  if (buffer.length) {
    flush();
  }

  return queries;
}

function isSafeSelect(sql) {
  const cleaned = sql.replace(/^--.*$/gm, "").trim();
  return /^select\b/i.test(cleaned);
}

let cached = null;

function getQueries() {
  if (cached) {
    return cached;
  }
  const filePath = resolveQueryFile();
  const raw = fs.readFileSync(filePath, "utf8");
  const parsed = parseQueries(raw).filter((q) => isSafeSelect(q.sql));
  cached = parsed;
  return parsed;
}

module.exports = {
  getQueries,
  resolveQueryFile
};
