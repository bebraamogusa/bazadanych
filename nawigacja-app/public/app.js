const statusEl = document.getElementById("status");
const queryCountEl = document.getElementById("queryCount");
const queryListEl = document.getElementById("queryList");
const querySearchEl = document.getElementById("querySearch");
const activeTitleEl = document.getElementById("activeTitle");
const activeSqlEl = document.getElementById("activeSql");
const resultMetaEl = document.getElementById("resultMeta");
const resultTableEl = document.getElementById("resultTable");
const schemaStatsEl = document.getElementById("schemaStats");
const tableListEl = document.getElementById("tableList");
const relationListEl = document.getElementById("relationList");
const columnDetailEl = document.getElementById("columnDetail");
const mapSearchEl = document.getElementById("mapSearch");
const mapListEl = document.getElementById("mapList");
const mapInfoEl = document.getElementById("mapInfo");
const mapCountEl = document.getElementById("mapCount");
const mapInitBtn = document.getElementById("mapInitBtn");
const mapStopBtn = document.getElementById("mapStopBtn");
const mapStatusEl = document.getElementById("mapStatus");

const state = {
  queries: [],
  filtered: [],
  activeId: null,
  schema: null,
  source: null,
  mapItems: [],
  mapFiltered: [],
  activeMapKey: null,
  mapInitPending: false
};

const mapView = {
  aladin: null,
  starCatalog: null,
  planetCatalog: null,
  missionCatalog: null,
  itemByKey: new Map(),
  itemByName: new Map()
};

function setStatus(text) {
  statusEl.textContent = text;
}

function setMapStatus(text) {
  mapStatusEl.textContent = text;
}

function renderList() {
  queryListEl.innerHTML = "";
  state.filtered.forEach((query) => {
    const li = document.createElement("li");
    li.className = "query-item" + (query.id === state.activeId ? " active" : "");

    const title = document.createElement("strong");
    title.textContent = `${query.id}. ${query.title}`;

    const preview = document.createElement("span");
    preview.textContent = query.preview || "";

    li.append(title, preview);
    li.addEventListener("click", () => runQuery(query.id));

    queryListEl.appendChild(li);
  });
}

function renderTable(rows) {
  if (!rows.length) {
    resultTableEl.innerHTML = "<div class=\"result-meta\">brak wynikow</div>";
    return;
  }

  const table = document.createElement("table");
  const thead = document.createElement("thead");
  const headerRow = document.createElement("tr");
  const columns = Object.keys(rows[0]);

  columns.forEach((column) => {
    const th = document.createElement("th");
    th.textContent = column;
    headerRow.appendChild(th);
  });

  thead.appendChild(headerRow);
  table.appendChild(thead);

  const tbody = document.createElement("tbody");
  rows.forEach((row) => {
    const tr = document.createElement("tr");
    columns.forEach((column) => {
      const td = document.createElement("td");
      const value = row[column];
      td.textContent = value === null || value === undefined ? "-" : String(value);
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });

  table.appendChild(tbody);
  resultTableEl.innerHTML = "";
  resultTableEl.appendChild(table);
}

function renderSchema() {
  if (!state.schema) {
    return;
  }

  schemaStatsEl.textContent = `tabele: ${state.schema.tables.length} | relacje: ${state.schema.relations.length}`;

  tableListEl.innerHTML = "";
  state.schema.tables.forEach((table) => {
    const li = document.createElement("li");
    li.className = "table-item";
    li.textContent = `${table.name} (${table.columns.length})`;
    li.addEventListener("click", () => renderColumns(table));
    tableListEl.appendChild(li);
  });

  relationListEl.innerHTML = "";
  state.schema.relations.forEach((rel) => {
    const li = document.createElement("li");
    li.textContent = `${rel.fromTable}.${rel.fromColumn} -> ${rel.toTable}.${rel.toColumn}`;
    relationListEl.appendChild(li);
  });
}

function renderColumns(table) {
  columnDetailEl.innerHTML = "";
  const title = document.createElement("strong");
  title.textContent = table.name;
  columnDetailEl.appendChild(title);

  table.columns.forEach((column) => {
    const line = document.createElement("div");
    const nullable = column.nullable ? "NULL" : "NOT NULL";
    line.textContent = `${column.name} (${column.type}, ${nullable})`;
    columnDetailEl.appendChild(line);
  });
}

function mapKey(item) {
  return `${item.kind}:${item.id}`;
}

function renderMapList() {
  mapListEl.innerHTML = "";
  const fragment = document.createDocumentFragment();
  state.mapFiltered.forEach((item) => {
    const li = document.createElement("li");
    li.className = "map-item" + (mapKey(item) === state.activeMapKey ? " active" : "");
    const title = document.createElement("strong");
    title.textContent = item.name;
    const meta = document.createElement("span");
    if (item.kind === "star") {
      meta.textContent = "gwiazda";
    } else if (item.kind === "planet") {
      meta.textContent = "planeta";
    } else {
      meta.textContent = "misja";
    }
    li.append(title, meta);
    li.addEventListener("click", () => focusMapItem(item));
    fragment.appendChild(li);
  });
  mapListEl.appendChild(fragment);
}

function setMapInfo(item) {
  mapInfoEl.innerHTML = "";
  if (!item) {
    mapInfoEl.textContent = "wybierz obiekt z mapy lub listy";
    return;
  }

  const heading = document.createElement("strong");
  if (item.kind === "star") {
    heading.textContent = `${item.name} (gwiazda)`;
  } else if (item.kind === "planet") {
    heading.textContent = `${item.name} (planeta)`;
  } else {
    heading.textContent = `${item.name} (misja)`;
  }
  mapInfoEl.appendChild(heading);

  const xyLine = document.createElement("div");
  xyLine.textContent = `xy (RA/Dec): ${item.ra_deg.toFixed(4)} / ${item.dec_deg.toFixed(4)}`;
  mapInfoEl.appendChild(xyLine);

  if (item.xyz) {
    const xyzLine = document.createElement("div");
    xyzLine.textContent = `xyz (ly): ${item.xyz.x}, ${item.xyz.y}, ${item.xyz.z}`;
    mapInfoEl.appendChild(xyzLine);
  }

  if (item.dist_ly !== null && item.dist_ly !== undefined) {
    const dist = document.createElement("div");
    dist.textContent = `odleglosc: ${item.dist_ly} ly`;
    mapInfoEl.appendChild(dist);
  }

  Object.entries(item.details || {}).forEach(([key, value]) => {
    const line = document.createElement("div");
    const displayValue = value === null || value === undefined ? "-" : String(value);
    line.textContent = `${key}: ${displayValue}`;
    mapInfoEl.appendChild(line);
  });
}

function focusMapItem(item) {
  state.activeMapKey = mapKey(item);
  renderMapList();
  setMapInfo(item);
  if (mapView.aladin) {
    mapView.aladin.gotoRaDec(item.ra_deg, item.dec_deg);
  }
}

function filterMapItems(term) {
  const lower = term.trim().toLowerCase();
  if (!lower) {
    state.mapFiltered = [...state.mapItems];
  } else {
    state.mapFiltered = state.mapItems.filter((item) => {
      return item.name.toLowerCase().includes(lower);
    });
  }
  renderMapList();
}

function startAladin() {
  if (mapView.aladin) {
    return;
  }
  if (!window.A || !state.mapItems.length) {
    mapInfoEl.textContent = "brak danych mapy";
    setMapStatus("brak silnika mapy");
    return;
  }

  A.init.then(() => {
    mapView.aladin = A.aladin("#aladin", {
      survey: "P/DSS2/color",
      fov: 45,
      target: "0 +0",
      showCooGrid: false,
      showSimbadPointerControl: false,
      showShareControl: false,
      showReticle: false
    });

    setMapStatus("mapa aktywna");
    mapInitBtn.disabled = true;
    mapStopBtn.disabled = false;

    mapView.starCatalog = A.catalog({
      name: "Gwiazdy",
      sourceSize: 8,
      color: "#f2b447"
    });

    mapView.planetCatalog = A.catalog({
      name: "Planety",
      sourceSize: 14,
      color: "#0f7c8f"
    });

    mapView.missionCatalog = A.catalog({
      name: "Misje",
      sourceSize: 11,
      color: "#c0392b"
    });

    state.mapItems.forEach((item) => {
      if (Number.isNaN(item.ra_deg) || Number.isNaN(item.dec_deg)) {
        return;
      }
      const source = A.source(item.ra_deg, item.dec_deg, { name: item.name });
      source.data = item;
      mapView.itemByKey.set(mapKey(item), item);
      mapView.itemByName.set(item.name, item);
      if (item.kind === "star") {
        mapView.starCatalog.addSources([source]);
      } else if (item.kind === "planet") {
        mapView.planetCatalog.addSources([source]);
      } else {
        mapView.missionCatalog.addSources([source]);
      }
    });

    mapView.aladin.addCatalog(mapView.starCatalog);
    mapView.aladin.addCatalog(mapView.planetCatalog);
    mapView.aladin.addCatalog(mapView.missionCatalog);

    mapView.aladin.on("objectClicked", (object) => {
      if (object && object.data) {
        focusMapItem(object.data);
        return;
      }
      if (object && object.name && mapView.itemByName.has(object.name)) {
        focusMapItem(mapView.itemByName.get(object.name));
      }
    });
  });
}

function initMap() {
  if (mapView.aladin || state.mapInitPending) {
    return;
  }
  state.mapInitPending = true;
  setMapStatus("uruchamianie...");

  const start = () => {
    state.mapInitPending = false;
    startAladin();
  };

  if (window.A && window.A.init) {
    start();
    return;
  }

  if ("requestIdleCallback" in window) {
    window.requestIdleCallback(start, { timeout: 2000 });
  } else {
    window.setTimeout(start, 50);
  }
}

function pauseMap() {
  if (!mapView.aladin) {
    return;
  }
  if (typeof mapView.aladin.destroy === "function") {
    mapView.aladin.destroy();
  } else {
    const mapEl = document.getElementById("aladin");
    mapEl.innerHTML = "";
  }
  mapView.aladin = null;
  mapView.starCatalog = null;
  mapView.planetCatalog = null;
  mapView.missionCatalog = null;
  mapView.itemByKey.clear();
  mapView.itemByName.clear();
  setMapStatus("mapa wylaczona");
  mapInitBtn.disabled = false;
  mapStopBtn.disabled = true;
}

function filterQueries(term) {
  const lower = term.trim().toLowerCase();
  if (!lower) {
    state.filtered = [...state.queries];
  } else {
    state.filtered = state.queries.filter((query) => {
      return (
        query.title.toLowerCase().includes(lower) ||
        String(query.id).includes(lower) ||
        query.preview.toLowerCase().includes(lower)
      );
    });
  }
  renderList();
}

async function runQuery(id) {
  state.activeId = id;
  renderList();
  activeTitleEl.textContent = "ladowanie...";
  activeSqlEl.textContent = "";
  resultMetaEl.textContent = "";
  resultTableEl.innerHTML = "";

  try {
    const response = await fetch(`/api/queries/${id}`);
    if (!response.ok) {
      throw new Error("query failed");
    }
    const payload = await response.json();
    activeTitleEl.textContent = payload.title;
    activeSqlEl.textContent = payload.sql;
    resultMetaEl.textContent = `rekordy: ${payload.rows.length}`;
    renderTable(payload.rows);
  } catch (error) {
    activeTitleEl.textContent = "blad pobierania";
    activeSqlEl.textContent = "";
    resultMetaEl.textContent = "";
    resultTableEl.innerHTML = "<div class=\"result-meta\">nie udalo sie pobrac danych</div>";
  }
}

async function loadQueries() {
  const response = await fetch("/api/queries");
  const payload = await response.json();
  state.queries = payload.queries;
  state.filtered = [...payload.queries];
  state.source = payload.source;
  queryCountEl.textContent = payload.total;
  renderList();
}

async function loadSchema() {
  try {
    const response = await fetch("/api/schema");
    if (!response.ok) {
      throw new Error("schema_failed");
    }
    const payload = await response.json();
    if (!payload || !Array.isArray(payload.tables)) {
      throw new Error("schema_invalid");
    }
    state.schema = payload;
    renderSchema();
  } catch (error) {
    state.schema = null;
    schemaStatsEl.textContent = "blad pobierania struktury";
    tableListEl.innerHTML = "";
    relationListEl.innerHTML = "";
    columnDetailEl.textContent = "brak danych";
  }
}

async function loadMap() {
  const response = await fetch("/api/map");
  const payload = await response.json();
  state.mapItems = payload.items || [];
  state.mapFiltered = [...state.mapItems];
  mapCountEl.textContent = `${state.mapItems.length} obiektow`;
  renderMapList();
  setMapStatus("mapa wylaczona");
  if (state.mapItems.length) {
    focusMapItem(state.mapItems[0]);
  }
}

async function loadHealth() {
  try {
    const response = await fetch("/api/health");
    const payload = await response.json();
    if (payload.ok) {
      setStatus(`db: ${payload.db} | selecty: ${state.queries.length} | mapa: ${state.mapItems.length}`);
    } else {
      setStatus("db: down");
    }
  } catch (error) {
    setStatus("db: down");
  }
}

querySearchEl.addEventListener("input", (event) => {
  filterQueries(event.target.value);
});

mapSearchEl.addEventListener("input", (event) => {
  filterMapItems(event.target.value);
});

mapInitBtn.addEventListener("click", () => {
  initMap();
});

mapStopBtn.addEventListener("click", () => {
  pauseMap();
});

async function init() {
  setStatus("ladowanie danych...");
  await loadQueries();
  await loadSchema();
  await loadMap();
  await loadHealth();
  if (state.queries.length) {
    runQuery(state.queries[0].id);
  }
}

init();
