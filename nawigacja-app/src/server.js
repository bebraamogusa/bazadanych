require("dotenv").config();

const express = require("express");
const path = require("path");
const { pool } = require("./db");
const { getQueries, resolveQueryFile } = require("./queries");
const { loadSchema } = require("./schema");
const { loadMapData } = require("./map");

const app = express();
app.disable("x-powered-by");

app.get("/api/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ ok: true, db: "up" });
  } catch (error) {
    res.status(500).json({ ok: false, db: "down" });
  }
});

app.get("/api/queries", (req, res) => {
  const queries = getQueries().map((query) => ({
    id: query.id,
    title: query.title,
    preview: query.sql.split(/\r?\n/)[0].slice(0, 140)
  }));

  res.json({
    source: path.basename(resolveQueryFile()),
    total: queries.length,
    queries
  });
});

app.get("/api/queries/:id", async (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id)) {
    res.status(400).json({ error: "invalid_id" });
    return;
  }

  const query = getQueries().find((item) => item.id === id);
  if (!query) {
    res.status(404).json({ error: "not_found" });
    return;
  }

  try {
    const [rows, fields] = await pool.query(query.sql);
    res.json({
      id: query.id,
      title: query.title,
      sql: query.sql,
      rows,
      fields: fields.map((field) => ({ name: field.name }))
    });
  } catch (error) {
    res.status(500).json({ error: "query_failed" });
  }
});

app.get("/api/schema", async (req, res) => {
  try {
    const schema = await loadSchema(pool);
    res.json(schema);
  } catch (error) {
    res.status(500).json({ error: "schema_failed" });
  }
});

app.get("/api/map", async (req, res) => {
  try {
    const items = await loadMapData(pool);
    res.json({ total: items.length, items });
  } catch (error) {
    res.status(500).json({ error: "map_failed" });
  }
});

app.use(express.static(path.join(__dirname, "..", "public")));

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "..", "public", "index.html"));
});

const port = Number(process.env.PORT || 3000);
app.listen(port, () => {
  console.log(`[nawigacja] http://localhost:${port}`);
});
