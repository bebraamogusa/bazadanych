USE nawigacja_gwiezdna;

LOAD DATA INFILE '/tmp/tbl_planety.csv'
INTO TABLE tbl_planety
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_planety, id_gwiazdy, nazwa, typ, masa_ziemska, srednica_km, okres_orbitalny_dni, liczba_ksiezyców, srednia_temp_c, atmosfera, czy_zamieszkiwalna, data_odkrycia);

LOAD DATA INFILE '/tmp/tbl_obserwatoria.csv'
INTO TABLE tbl_obserwatoria
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_obserwatorium, id_planety, nazwa, lokalizacja, typ, data_zalozenia, srednica_teleskopu_m, dlugosc_geo, szerokosc_geo, aktywne, personel_liczba, budzet_roczny_PLN);

LOAD DATA INFILE '/tmp/tbl_instrumenty_nawigacyjne.csv'
INTO TABLE tbl_instrumenty_nawigacyjne
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_instrumentu, nazwa, typ, producent, model, rok_produkcji, dokladnosc_ly, zasieg_ly, id_statku, stan, cena_PLN);

LOAD DATA INFILE '/tmp/tbl_misje.csv'
INTO TABLE tbl_misje
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_misji, nazwa, typ, id_statku, id_nawigatora, id_docelowej_planety, data_startu, data_konca, cel_x_ly, cel_y_ly, cel_z_ly, status, priorytet, wynik, budzet_PLN);


LOAD DATA INFILE '/tmp/tbl_trasy_nawigacyjne.csv'
INTO TABLE tbl_trasy_nawigacyjne
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trasy, nazwa, id_misji, punkt_startowy, punkt_koncowy, dlugosc_ly, czas_podrozy_dni, typ_napędu, liczba_etapow, trudnosc, czy_bezpieczna, uwagi);

LOAD DATA INFILE '/tmp/tbl_logi_nawigacyjne.csv'
INTO TABLE tbl_logi_nawigacyjne
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_logu, id_misji, id_nawigatora, znacznik_czasu, pos_x_ly, pos_y_ly, pos_z_ly, predkosc_c, kurs_stopnie, typ_zdarzenia, opis, odczyt_sextanta);
