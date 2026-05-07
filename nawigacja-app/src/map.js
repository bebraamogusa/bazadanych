function toRadians(value) {
  return (value * Math.PI) / 180;
}

function toXyz(raDeg, decDeg, distLy) {
  if (distLy === null || distLy === undefined) {
    return null;
  }

  const raRad = toRadians(raDeg);
  const decRad = toRadians(decDeg);
  const cosDec = Math.cos(decRad);

  return {
    x: Number((distLy * cosDec * Math.cos(raRad)).toFixed(4)),
    y: Number((distLy * cosDec * Math.sin(raRad)).toFixed(4)),
    z: Number((distLy * Math.sin(decRad)).toFixed(4))
  };
}

async function loadMapData(pool) {
  const [stars] = await pool.query(
    "SELECT tg.id_gwiazdy AS id, tg.nazwa, tg.ra_deg, tg.dec_deg, tg.odleglosc_ly, tg.typ_widmowy, tg.magnitude, tk.nazwa AS konstelacja, tk.skrot AS skrot FROM tbl_gwiazdy tg LEFT JOIN tbl_konstelacje tk ON tg.id_konstelacji = tk.id_konstelacji WHERE tg.ra_deg IS NOT NULL AND tg.dec_deg IS NOT NULL"
  );

  const [planets] = await pool.query(
    "SELECT tp.id_planety AS id, tp.nazwa, COALESCE(tp.ra_deg, tg.ra_deg) AS ra_deg, COALESCE(tp.dec_deg, tg.dec_deg) AS dec_deg, tg.odleglosc_ly AS odleglosc_ly, tp.typ, tp.masa_ziemska, tp.czy_zamieszkiwalna, tg.nazwa AS gwiazda FROM tbl_planety tp LEFT JOIN tbl_gwiazdy tg ON tp.id_gwiazdy = tg.id_gwiazdy WHERE COALESCE(tp.ra_deg, tg.ra_deg) IS NOT NULL AND COALESCE(tp.dec_deg, tg.dec_deg) IS NOT NULL"
  );

  const starItems = stars.map((row) => {
    const ra = Number(row.ra_deg);
    const dec = Number(row.dec_deg);
    const dist = row.odleglosc_ly === null ? null : Number(row.odleglosc_ly);

    return {
      id: row.id,
      kind: "star",
      name: row.nazwa,
      ra_deg: ra,
      dec_deg: dec,
      dist_ly: dist,
      xyz: toXyz(ra, dec, dist),
      details: {
        typ_widmowy: row.typ_widmowy,
        magnitude: row.magnitude,
        konstelacja: row.konstelacja,
        skrot: row.skrot
      }
    };
  });

  const planetItems = planets.map((row) => {
    const ra = Number(row.ra_deg);
    const dec = Number(row.dec_deg);
    const dist = row.odleglosc_ly === null ? null : Number(row.odleglosc_ly);

    return {
      id: row.id,
      kind: "planet",
      name: row.nazwa,
      ra_deg: ra,
      dec_deg: dec,
      dist_ly: dist,
      xyz: toXyz(ra, dec, dist),
      details: {
        typ: row.typ,
        masa_ziemska: row.masa_ziemska,
        czy_zamieszkiwalna: row.czy_zamieszkiwalna,
        gwiazda: row.gwiazda
      }
    };
  });

  return [...starItems, ...planetItems];
}

module.exports = { loadMapData };
