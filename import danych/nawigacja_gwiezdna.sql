DROP DATABASE IF EXISTS nawigacja_gwiezdna;
CREATE DATABASE IF NOT EXISTS nawigacja_gwiezdna;
USE nawigacja_gwiezdna;

CREATE TABLE tbl_konstelacje (
    id_konstelacji INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    skrot CHAR(3) NOT NULL,
    polkula ENUM('Północna','Południowa','Obie') NOT NULL,
    powierzchnia_sq DECIMAL(10,2),
    liczba_gwiazd INT DEFAULT 0,
    widocznosc ENUM('Łatwa','Średnia','Trudna') NOT NULL DEFAULT 'Średnia',
    miesiac_najlepszy TINYINT,
    opis TEXT
);

CREATE TABLE tbl_gwiazdy (
    id_gwiazdy INT AUTO_INCREMENT PRIMARY KEY,
    id_konstelacji INT NULL,
    nazwa VARCHAR(100) NOT NULL,
    oznaczenie_bayer VARCHAR(10),
    typ_widmowy CHAR(5),
    magnitude DECIMAL(5,2),
    odleglosc_ly DECIMAL(12,2),
    ra_deg DECIMAL(9,5),
    dec_deg DECIMAL(9,5),
    temperatura_k INT,
    masa_sloneczna DECIMAL(8,2),
    kolor ENUM('Niebieski','Biały','Żółty','Pomarańczowy','Czerwony') NOT NULL,
    czy_podwojna TINYINT(1) DEFAULT 0,
    data_odkrycia INT,
    FOREIGN KEY (id_konstelacji) REFERENCES tbl_konstelacje(id_konstelacji) ON DELETE CASCADE
);

CREATE TABLE tbl_statki_kosmiczne (
    id_statku INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    typ ENUM('Zwiadowczy','Transportowy','Bojowy','Naukowy','Pasażerski') NOT NULL,
    producent VARCHAR(100),
    rok_produkcji INT,
    max_predkosc_c DECIMAL(5,4),
    zasieg_ly DECIMAL(12,2),
    zalog_max INT,
    masa_tony DECIMAL(12,2),
    status ENUM('Aktywny','W remoncie','Wycofany','Zniszczony') DEFAULT 'Aktywny',
    data_wodowania DATE
);

CREATE TABLE tbl_nawigatorzy (
    id_nawigatora INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(80) NOT NULL,
    data_urodzenia DATE,
    stopien ENUM('Kadet','Nawigator','Starszy Nawigator','Kapitan Nawigator','Admirał') NOT NULL,
    specjalizacja ENUM('Nawigacja Gwiezdna','Nawigacja Kwantowa','Hiperskok','Warp','Wielofazowa') NOT NULL,
    lata_doswiadczenia INT DEFAULT 0,
    certyfikat_nr VARCHAR(20) UNIQUE,
    aktywny TINYINT(1) DEFAULT 1,
    id_statku INT,
    FOREIGN KEY (id_statku) REFERENCES tbl_statki_kosmiczne(id_statku) ON DELETE SET NULL
);

CREATE TABLE tbl_planety (
    id_planety INT AUTO_INCREMENT PRIMARY KEY,
    id_gwiazdy INT NULL,
    ra_deg DECIMAL(9,5),
    dec_deg DECIMAL(9,5),
    nazwa VARCHAR(80) NOT NULL,
    typ ENUM('Skalista','Gazowy olbrzym','Lodowy olbrzym','Karłowata') NOT NULL,
    masa_ziemska DECIMAL(12,4),
    srednica_km INT,
    okres_orbitalny_dni DECIMAL(12,2),
    liczba_ksiezyców INT DEFAULT 0,
    srednia_temp_c DECIMAL(7,2),
    atmosfera VARCHAR(200),
    czy_zamieszkiwalna TINYINT(1) DEFAULT 0,
    data_odkrycia INT,
    FOREIGN KEY (id_gwiazdy) REFERENCES tbl_gwiazdy(id_gwiazdy) ON DELETE SET NULL
);

CREATE TABLE tbl_obserwatoria (
    id_obserwatorium INT AUTO_INCREMENT PRIMARY KEY,
    id_planety INT NULL,
    nazwa VARCHAR(150) NOT NULL,
    lokalizacja VARCHAR(200) NOT NULL,
    typ ENUM('Naziemne','Orbitalne','Księżycowe','Stacja Głęboka') NOT NULL,
    data_zalozenia INT,
    srednica_teleskopu_m DECIMAL(6,2),
    dlugosc_geo DECIMAL(10,6),
    szerokosc_geo DECIMAL(10,6),
    aktywne TINYINT(1) DEFAULT 1,
    personel_liczba INT,
    budzet_roczny_PLN BIGINT,
    FOREIGN KEY (id_planety) REFERENCES tbl_planety(id_planety) ON DELETE SET NULL
);

CREATE TABLE tbl_instrumenty_nawigacyjne (
    id_instrumentu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    typ ENUM('Sextant','Kompas','Skaner','Kalkulatr Warp','System Celowania','Detektor') NOT NULL,
    producent VARCHAR(100),
    model VARCHAR(80),
    rok_produkcji INT,
    dokladnosc_ly DECIMAL(10,8),
    zasieg_ly DECIMAL(12,2),
    id_statku INT,
    stan ENUM('Sprawny','Do kalibracji','Uszkodzony') DEFAULT 'Sprawny',
    cena_PLN BIGINT,
    FOREIGN KEY (id_statku) REFERENCES tbl_statki_kosmiczne(id_statku) ON DELETE SET NULL
);

CREATE TABLE tbl_misje (
    id_misji INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(150) NOT NULL,
    typ ENUM('Eksploracja','Transport','Obrona','Naukowa','Ratunkowa') NOT NULL,
    id_statku INT NOT NULL,
    id_nawigatora INT NOT NULL,
    id_docelowej_planety INT NULL,
    data_startu DATE,
    data_konca DATE,
    cel_x_ly DECIMAL(12,4),
    cel_y_ly DECIMAL(12,4),
    cel_z_ly DECIMAL(12,4),
    status ENUM('Planowana','W trakcie','Zakończona','Przerwana') DEFAULT 'Planowana',
    priorytet TINYINT DEFAULT 3,
    wynik TEXT,
    budzet_PLN BIGINT,
    FOREIGN KEY (id_statku) REFERENCES tbl_statki_kosmiczne(id_statku) ON DELETE CASCADE,
    FOREIGN KEY (id_nawigatora) REFERENCES tbl_nawigatorzy(id_nawigatora) ON DELETE CASCADE,
    FOREIGN KEY (id_docelowej_planety) REFERENCES tbl_planety(id_planety) ON DELETE SET NULL
);

CREATE TABLE tbl_trasy_nawigacyjne (
    id_trasy INT AUTO_INCREMENT PRIMARY KEY,
    nazwa VARCHAR(150) NOT NULL,
    id_misji INT NOT NULL,
    punkt_startowy VARCHAR(100) NOT NULL,
    punkt_koncowy VARCHAR(100) NOT NULL,
    dlugosc_ly DECIMAL(12,4) NOT NULL,
    czas_podrozy_dni INT,
    typ_napędu ENUM('Impuls','Warp','Hiperprzestrzeń','Kwantowy') NOT NULL,
    liczba_etapow INT DEFAULT 1,
    trudnosc ENUM('Łatwa','Średnia','Trudna','Ekstremalna') DEFAULT 'Średnia',
    czy_bezpieczna TINYINT(1) DEFAULT 1,
    uwagi TEXT,
    FOREIGN KEY (id_misji) REFERENCES tbl_misje(id_misji) ON DELETE CASCADE
);

CREATE TABLE tbl_logi_nawigacyjne (
    id_logu INT AUTO_INCREMENT PRIMARY KEY,
    id_misji INT NOT NULL,
    id_nawigatora INT NOT NULL,
    znacznik_czasu DATETIME NOT NULL,
    pos_x_ly DECIMAL(14,6),
    pos_y_ly DECIMAL(14,6),
    pos_z_ly DECIMAL(14,6),
    predkosc_c DECIMAL(5,4),
    kurs_stopnie DECIMAL(8,4),
    typ_zdarzenia ENUM('Wpis Rutynowy','Zmiana Kursu','Alarm','Odkrycie','Awaria','Wejście Warp','Wyjście Warp') NOT NULL,
    opis TEXT,
    odczyt_sextanta VARCHAR(100),
    FOREIGN KEY (id_misji) REFERENCES tbl_misje(id_misji) ON DELETE CASCADE,
    FOREIGN KEY (id_nawigatora) REFERENCES tbl_nawigatorzy(id_nawigatora) ON DELETE CASCADE
);