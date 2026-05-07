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

INSERT INTO tbl_konstelacje VALUES
(1,'Orion','Ori','Obie',594.12,81,'Łatwa',1,'Widoczna z obu półkul.'),
(2,'Wielka Niedźwiedzica','UMa','Północna',1279.66,125,'Łatwa',4,'Zawiera Wielki Wóz.'),
(3,'Mała Niedźwiedzica','UMi','Północna',255.86,20,'Łatwa',6,'Zawiera Gwiazdę Polarną.'),
(4,'Kasjopeja','Cas','Północna',598.41,90,'Łatwa',11,'Kształt litery W.'),
(5,'Centaur','Cen','Południowa',1060.42,281,'Średnia',5,'Zawiera Alfa Centauri.'),
(6,'Krzyż Południa','Cru','Południowa',68.45,30,'Łatwa',5,'Kluczowa dla południa.'),
(7,'Skorpion','Sco','Południowa',496.78,100,'Łatwa',7,'Zawiera Antaresa.'),
(8,'Lira','Lyr','Północna',286.48,73,'Średnia',8,'Zawiera Wegę.'),
(9,'Łabędź','Cyg','Północna',803.98,150,'Łatwa',9,'Zawiera Deneba.'),
(10,'Andromeda','And','Obie',722.28,100,'Trudna',11,'Zawiera Galaktykę M31.');

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
    czy_podwójna TINYINT(1) DEFAULT 0,
    data_odkrycia INT,
    FOREIGN KEY (id_konstelacji) REFERENCES tbl_konstelacje(id_konstelacji) ON DELETE CASCADE
);

INSERT INTO tbl_gwiazdy (
    id_gwiazdy,
    id_konstelacji,
    nazwa,
    oznaczenie_bayer,
    typ_widmowy,
    magnitude,
    odleglosc_ly,
    ra_deg,
    dec_deg,
    temperatura_k,
    masa_sloneczna,
    kolor,
    czy_podwójna,
    data_odkrycia
) VALUES
(1,1,'Betelgeza','Alpha','M2',0.42,700,88.79294,7.40706,3500,20.00,'Czerwony',0,1918),
(2,1,'Rigel','Beta','B8',0.13,860,78.63447,-8.20164,11000,21.00,'Niebieski',1,1891),
(3,2,'Dubhe','Alpha','K0',1.79,123,165.46058,61.75103,4660,4.25,'Pomarańczowy',1,1781),
(4,2,'Mizar','Zeta','A2',2.27,83,200.98143,54.92542,9000,2.20,'Biały',1,1650),
(5,3,'Gwiazda Polarna','Alpha','F7',1.97,432,37.95456,89.26411,6015,5.40,'Żółty',1,1499),
(6,4,'Schedar','Alpha','K0',2.24,229,10.12604,56.53733,4530,5.00,'Pomarańczowy',0,1603),
(7,5,'Alfa Centauri','Alpha','G2',-0.27,4.37,219.90206,-60.83399,5790,1.10,'Żółty',1,1689),
(8,6,'Acrux','Alpha','B0',0.76,321,186.64956,-63.09909,28000,17.80,'Niebieski',1,1592),
(9,7,'Antares','Alpha','M1',1.05,550,247.35192,-26.43200,3400,12.40,'Czerwony',1,1846),
(10,8,'Wega','Alpha','A0',0.03,25,279.23473,38.78369,9600,2.10,'Biały',0,1740),
(11,9,'Deneb','Alpha','A2',1.25,2615,310.35798,45.28034,8525,19.00,'Biały',0,1801),
(12,10,'Mirach','Beta','M0',2.06,197,17.43300,35.62056,3842,3.50,'Czerwony',0,1858),
(13,1,'Alnilam','Epsilon','B0',1.69,1340,84.05339,-1.20192,27000,40.00,'Niebieski',0,1801),
(14,9,'Sadr','Gamma','F8',2.23,1523,305.55708,40.25668,6500,12.00,'Żółty',0,1800),
(15,7,'Dschubba','Delta','B0',2.32,400,243.58700,-22.62100,27400,13.00,'Niebieski',1,1841),
(16,NULL,'Słońce','Sol','G2V',-26.74,0,NULL,NULL,5778,1.00,'Żółty',0,NULL);

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

INSERT INTO tbl_statki_kosmiczne VALUES
(1,'Polarnik I','Zwiadowczy','Kosmopol SA',2310,0.3,150,15,12000,'Aktywny','2310-03-15'),
(2,'Gwiezdny Orzeł','Bojowy','MarsDefense',2315,0.5,300,80,45000,'Aktywny','2315-07-22'),
(3,'Nomad VII','Transportowy','CargoSpace',2308,0.2,500,200,98000,'Aktywny','2308-11-01'),
(4,'Aurora','Naukowy','Akademia Orbity',2320,0.4,200,40,30000,'Aktywny','2320-01-30'),
(5,'Kolos','Pasażerski','StarLine',2318,0.25,400,600,150000,'Aktywny','2318-05-12'),
(6,'Bystre Oko','Zwiadowczy','Kosmopol SA',2305,0.35,180,12,11500,'W remoncie','2305-09-08'),
(7,'Hermes XII','Zwiadowczy','SpeedTech',2322,0.6,350,20,14000,'Aktywny','2322-12-01'),
(8,'Starfall','Naukowy','Akademia Orbity',2300,0.22,100,30,22000,'Wycofany','2300-06-14'),
(9,'Krzyżowiec','Bojowy','MarsDefense',2317,0.45,280,120,60000,'Aktywny','2317-02-28'),
(10,'Solaris','Pasażerski','StarLine',2325,0.3,450,800,180000,'Aktywny','2325-08-18');

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

INSERT INTO tbl_nawigatorzy VALUES
(1,'Aleksandra','Kowalczyk','2280-04-12','Kapitan Nawigator','Nawigacja Gwiezdna',35,'NAV-PL-0001',1,1),
(2,'Marek','Nowak','2295-09-23','Starszy Nawigator','Hiperskok',20,'NAV-PL-0002',1,2),
(3,'Yuki','Tanaka','2300-01-05','Nawigator','Nawigacja Kwantowa',15,'NAV-JP-0044',1,3),
(4,'Carlos','Vega','2290-07-18','Kapitan Nawigator','Warp',25,'NAV-ES-0012',1,4),
(5,'Lena','Müller','2305-11-30','Starszy Nawigator','Nawigacja Gwiezdna',10,'NAV-DE-0088',1,5),
(6,'Jan','Wiśniewski','2288-02-14','Admirał','Wielofazowa',42,'NAV-PL-0003',1,9),
(7,'Sofia','Rossi','2310-06-22','Nawigator','Hiperskok',8,'NAV-IT-0031',1,7),
(8,'Piotr','Zając','2298-12-01','Starszy Nawigator','Nawigacja Kwantowa',18,'NAV-PL-0015',1,6),
(9,'Amara','Diallo','2315-03-09','Kadet','Nawigacja Gwiezdna',2,'NAV-SN-0007',1,1),
(10,'Hiroshi','Sato','2275-08-27','Admirał','Warp',50,'NAV-JP-0002',0,NULL);


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