-- SELECTY
-- 1. Pobranie wszystkich konstelacji z półkuli północnej
SELECT 
    tk.nazwa, 
    tk.skrot, 
    tk.liczba_gwiazd
FROM 
    tbl_konstelacje AS tk
WHERE 
    tk.polkula = 'Północna';

-- 2. Gwiazdy o dużej jasności (magnitude poniżej 1.0)
SELECT 
    tg.nazwa, 
    tg.typ_widmowy, 
    tg.magnitude
FROM 
    tbl_gwiazdy AS tg
WHERE 
    tg.magnitude < 1.0;

-- 3. Zamieszkiwalne planety z atmosferą
SELECT 
    tp.nazwa, 
    tp.typ, 
    tp.atmosfera
FROM 
    tbl_planety AS tp
WHERE 
    tp.czy_zamieszkiwalna = 1;

-- 4. Aktywne obserwatoria z dużym budżetem (> 50 mln PLN)
SELECT 
    tob.nazwa, 
    tob.lokalizacja, 
    tob.budzet_roczny_PLN
FROM 
    tbl_obserwatoria AS tob
WHERE 
    tob.aktywne = 1 AND 
    tob.budzet_roczny_PLN > 50000000;

-- 5. Szybkie statki zwiadowcze (prędkość >= 0.3c)
SELECT 
    tsk.nazwa, 
    tsk.producent, 
    tsk.max_predkosc_c
FROM 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tsk.typ = 'Zwiadowczy' AND 
    tsk.max_predkosc_c >= 0.3;

-- 6. Doświadczeni nawigatorzy specjalizujący się w Warp
SELECT 
    tn.imie, 
    tn.nazwisko, 
    tn.lata_doswiadczenia
FROM 
    tbl_nawigatorzy AS tn
WHERE 
    tn.specjalizacja = 'Warp' AND 
    tn.lata_doswiadczenia > 20;

-- 7. Uszkodzone instrumenty nawigacyjne
SELECT 
    tin.nazwa, 
    tin.typ, 
    tin.model
FROM 
    tbl_instrumenty_nawigacyjne AS tin
WHERE 
    tin.stan = 'Uszkodzony';

-- 8. Misje o wysokim priorytecie (1 lub 2)
SELECT 
    tm.nazwa, 
    tm.typ, 
    tm.status
FROM 
    tbl_misje AS tm
WHERE 
    tm.priorytet <= 2;

-- 9. Długie i niebezpieczne trasy nawigacyjne
SELECT 
    ttn.nazwa, 
    ttn.dlugosc_ly, 
    ttn.trudnosc
FROM 
    tbl_trasy_nawigacyjne AS ttn
WHERE 
    ttn.czy_bezpieczna = 0 AND 
    ttn.dlugosc_ly > 100;

-- 10. Wpisy logów z awariami
SELECT 
    tln.znacznik_czasu, 
    tln.opis
FROM 
    tbl_logi_nawigacyjne AS tln
WHERE 
    tln.typ_zdarzenia = 'Awaria';

-- 11. Gwiazdy i konstelacje, w których leżą
SELECT 
    tg.nazwa AS gwiazda, 
    tk.nazwa AS konstelacja
FROM 
    tbl_gwiazdy AS tg, 
    tbl_konstelacje AS tk
WHERE 
    tg.id_konstelacji = tk.id_konstelacji;

-- 12. Planety skaliste i ich gwiazdy macierzyste
SELECT 
    tp.nazwa AS planeta, 
    tg.nazwa AS gwiazda
FROM 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tp.typ = 'Skalista';

-- 13. Obserwatoria i planety, na których zbudowano bazy
SELECT 
    tob.nazwa AS obserwatorium, 
    tp.nazwa AS planeta
FROM 
    tbl_obserwatoria AS tob, 
    tbl_planety AS tp
WHERE 
    tob.id_planety = tp.id_planety;

-- 14. Nawigatorzy i nazwy statków, na których służą
SELECT 
    tn.nazwisko, 
    tn.stopien, 
    tsk.nazwa AS statek
FROM 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tn.id_statku = tsk.id_statku;

-- 15. Instrumenty skanujące przypisane do statków
SELECT 
    tin.nazwa AS instrument, 
    tsk.nazwa AS statek
FROM 
    tbl_instrumenty_nawigacyjne AS tin, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tin.id_statku = tsk.id_statku AND 
    tin.typ = 'Skaner';

-- 16. Misje i nawigatorzy nimi dowodzący
SELECT 
    tm.nazwa AS misja, 
    tn.nazwisko AS dowodca
FROM 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn
WHERE 
    tm.id_nawigatora = tn.id_nawigatora;

-- 17. Misje transportowe i używane do nich statki
SELECT 
    tm.nazwa AS misja, 
    tsk.nazwa AS statek
FROM 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tm.id_statku = tsk.id_statku AND 
    tm.typ = 'Transport';

-- 18. Trasy ekstremalne przypisane do konkretnych misji
SELECT 
    ttn.nazwa AS trasa, 
    tm.nazwa AS misja
FROM 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm
WHERE 
    ttn.id_misji = tm.id_misji AND 
    ttn.trudnosc = 'Ekstremalna';

-- 19. Logi ze zdarzeniem "Alarm" i powiązane misje
SELECT 
    tln.znacznik_czasu, 
    tln.opis, 
    tm.nazwa AS misja
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm
WHERE 
    tln.id_misji = tm.id_misji AND 
    tln.typ_zdarzenia = 'Alarm';

-- 20. Misje eksploracyjne i ich docelowe planety
SELECT 
    tm.nazwa AS misja, 
    tp.nazwa AS cel
FROM 
    tbl_misje AS tm, 
    tbl_planety AS tp
WHERE 
    tm.id_docelowej_planety = tp.id_planety AND 
    tm.typ = 'Eksploracja';

-- 21. Planety, ich gwiazdy oraz konstelacje gwiazd
SELECT 
    tp.nazwa AS planeta, 
    tg.nazwa AS gwiazda, 
    tk.nazwa AS konstelacja
FROM 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg, 
    tbl_konstelacje AS tk
WHERE 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tg.id_konstelacji = tk.id_konstelacji;

-- 22. Obserwatoria, planety i gwiazdy nad nimi
SELECT 
    tob.nazwa AS obserwatorium, 
    tp.nazwa AS planeta, 
    tg.nazwa AS gwiazda
FROM 
    tbl_obserwatoria AS tob, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    tob.id_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy;

-- 23. Nawigatorzy, ich statki oraz wyprodukowane instrumenty NavTech
SELECT 
    tn.nazwisko, 
    tsk.nazwa AS statek, 
    tin.nazwa AS instrument
FROM 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin
WHERE 
    tn.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tin.producent = 'NavTech';

-- 24. Zakończone misje, nawigatorzy i przypisane statki
SELECT 
    tm.nazwa AS misja, 
    tn.nazwisko AS dowodca, 
    tsk.nazwa AS statek
FROM 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tm.id_nawigatora = tn.id_nawigatora AND 
    tm.id_statku = tsk.id_statku AND 
    tm.status = 'Zakończona';

-- 25. Misje ratunkowe z docelowymi planetami i ich gwiazdami
SELECT 
    tm.nazwa AS misja, 
    tp.nazwa AS planeta_ratunkowa, 
    tg.nazwa AS uklad_gwiezdny
FROM 
    tbl_misje AS tm, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    tm.id_docelowej_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tm.typ = 'Ratunkowa';

-- 26. Trasy pokonywane z napędem Warp na konkretnych statkach
SELECT 
    ttn.nazwa AS trasa, 
    tm.nazwa AS misja, 
    tsk.nazwa AS statek
FROM 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    ttn.id_misji = tm.id_misji AND 
    tm.id_statku = tsk.id_statku AND 
    ttn.typ_napędu = 'Warp';

-- 27. Logi "Wejścia w Warp", nawigatorzy i statki
SELECT 
    tln.znacznik_czasu, 
    tn.nazwisko, 
    tsk.nazwa AS statek
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tln.id_nawigatora = tn.id_nawigatora AND 
    tn.id_statku = tsk.id_statku AND 
    tln.typ_zdarzenia = 'Wejście Warp';

-- 28. Trasy powyżej 1000 ly i przypisani do nich nawigatorzy
SELECT 
    ttn.nazwa AS trasa, 
    ttn.dlugosc_ly, 
    tn.nazwisko AS oficer
FROM 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn
WHERE 
    ttn.id_misji = tm.id_misji AND 
    tm.id_nawigatora = tn.id_nawigatora AND 
    ttn.dlugosc_ly > 1000;

-- 29. Średnia temperatura planet, na które planowane są misje (użycie funkcji agregującej)
SELECT 
    tm.typ AS typ_misji, 
    tp.nazwa AS planeta, 
    AVG(tp.srednia_temp_c) AS srednia_temp
FROM 
    tbl_misje AS tm, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    tm.id_docelowej_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy
GROUP BY 
    tm.typ, tp.nazwa;

-- 30. Wszelkie odkrycia zarejestrowane w logach na planetach docelowych
SELECT 
    tln.znacznik_czasu, 
    tln.opis, 
    tp.nazwa AS planeta_docelowa
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm, 
    tbl_planety AS tp
WHERE 
    tln.id_misji = tm.id_misji AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tln.typ_zdarzenia = 'Odkrycie';

-- 31. Systemy celowania na statkach uczestniczących w misjach obronnych
SELECT 
    tin.nazwa AS system_celowania, 
    tsk.nazwa AS statek, 
    tm.nazwa AS misja_obronna
FROM 
    tbl_instrumenty_nawigacyjne AS tin, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_misje AS tm
WHERE 
    tin.id_statku = tsk.id_statku AND 
    tm.id_statku = tsk.id_statku AND 
    tm.typ = 'Obrona';

-- 32. Admirałowie, nazwy ich statków i trasy jakie mają do przebycia
SELECT 
    tn.nazwisko AS admiral, 
    tsk.nazwa AS statek, 
    ttn.nazwa AS trasa
FROM 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_trasy_nawigacyjne AS ttn,
    tbl_misje AS tm
WHERE 
    tn.id_statku = tsk.id_statku AND 
    tn.id_nawigatora = tm.id_nawigatora AND
    ttn.id_misji = tm.id_misji AND
    tn.stopien = 'Admirał';

-- 33. Planety (i ich układ), do których leci dany nawigator
SELECT 
    tn.nazwisko AS nawigator, 
    tm.nazwa AS misja, 
    tp.nazwa AS docelowa_planeta, 
    tg.nazwa AS uklad_gwiazdy
FROM 
    tbl_nawigatorzy AS tn, 
    tbl_misje AS tm, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    tn.id_nawigatora = tm.id_nawigatora AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy;

-- 34. Zdarzenia alarmowe (logi), kto je zgłosił i jakim statkiem
SELECT 
    tln.znacznik_czasu, 
    tln.opis, 
    tn.nazwisko AS oficer_zgloszeniowy, 
    tsk.nazwa AS statek
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk
WHERE 
    tln.id_misji = tm.id_misji AND 
    tln.id_nawigatora = tn.id_nawigatora AND 
    tn.id_statku = tsk.id_statku AND 
    tln.typ_zdarzenia = 'Alarm';

-- 35. Trasy dla misji posiadających uszkodzone instrumenty
SELECT 
    ttn.nazwa AS trasa, 
    tm.nazwa AS misja, 
    tsk.nazwa AS statek, 
    tin.nazwa AS zepsuty_sprzet
FROM 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin
WHERE 
    ttn.id_misji = tm.id_misji AND 
    tm.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tin.stan = 'Uszkodzony';

-- 36. Obserwatoria monitorujące planetę z aktywną misją
SELECT 
    tob.nazwa AS obserwatorium, 
    tp.nazwa AS planeta_obserwowana, 
    tm.nazwa AS operacja, 
    tn.nazwisko AS prowadzacy
FROM 
    tbl_obserwatoria AS tob, 
    tbl_planety AS tp, 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn
WHERE 
    tob.id_planety = tp.id_planety AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tm.id_nawigatora = tn.id_nawigatora;

-- 37. Planety skaliste i gazowe, ich gwiazdy i konstelacje
SELECT 
    tp.nazwa AS planeta, 
    tp.typ AS rodzaj, 
    tg.nazwa AS gwiazda_macierzysta, 
    tk.nazwa AS sektor_konstelacji
FROM 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg, 
    tbl_konstelacje AS tk
WHERE 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tg.id_konstelacji = tk.id_konstelacji;

-- 38. Ścieżka statków: statek -> instrument -> misja -> trasa
SELECT 
    tsk.nazwa AS statek, 
    tin.typ AS glowny_instrument, 
    tm.nazwa AS operacja, 
    ttn.dlugosc_ly AS odleglosc_do_przebycia
FROM 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin, 
    tbl_misje AS tm, 
    tbl_trasy_nawigacyjne AS ttn
WHERE 
    tin.id_statku = tsk.id_statku AND 
    tm.id_statku = tsk.id_statku AND 
    ttn.id_misji = tm.id_misji AND 
    tin.stan = 'Sprawny';

-- 39. Detale logu na ekstremalnej trasie
SELECT 
    tln.znacznik_czasu, 
    tln.typ_zdarzenia, 
    tn.nazwisko, 
    ttn.trudnosc, 
    ttn.typ_napędu
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn, 
    tbl_trasy_nawigacyjne AS ttn
WHERE 
    tln.id_misji = tm.id_misji AND 
    tln.id_nawigatora = tn.id_nawigatora AND 
    ttn.id_misji = tm.id_misji AND 
    ttn.trudnosc = 'Ekstremalna';

-- 40. Adres docelowy misji badawczych (5 tabel)
SELECT 
    tm.nazwa AS misja, 
    tn.nazwisko AS dowodca, 
    tp.nazwa AS planeta, 
    tg.nazwa AS system_gwiezdny, 
    tk.skrot AS rejon_nieba
FROM 
    tbl_misje AS tm, 
    tbl_nawigatorzy AS tn, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg, 
    tbl_konstelacje AS tk
WHERE 
    tm.id_nawigatora = tn.id_nawigatora AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tg.id_konstelacji = tk.id_konstelacji AND 
    tm.typ = 'Naukowa';

-- 41. Które stacje obserwują gwiazdy z podwójnymi układami
SELECT 
    tob.nazwa AS placowka, 
    tp.nazwa AS planeta_bazy, 
    tg.nazwa AS cel_obserwacji, 
    tk.nazwa AS konstelacja
FROM 
    tbl_obserwatoria AS tob, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg, 
    tbl_konstelacje AS tk
WHERE 
    tob.id_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tg.id_konstelacji = tk.id_konstelacji AND 
    tg.czy_podwojna = 1;

-- 42. Wpisy nawigacyjne ze statku "Aurora" docierającego na planetę docelową
SELECT 
    tln.znacznik_czasu, 
    tln.odczyt_sextanta, 
    tsk.nazwa AS wehikul, 
    tp.nazwa AS kierunek_podrozy
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_planety AS tp
WHERE 
    tln.id_misji = tm.id_misji AND 
    tm.id_statku = tsk.id_statku AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tsk.nazwa = 'Aurora';

-- 43. Powiązania logów z budżetem instrumentów na statku
SELECT 
    tln.typ_zdarzenia, 
    tin.nazwa AS uzyty_instrument, 
    tsk.nazwa AS statek, 
    tm.priorytet
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin
WHERE 
    tln.id_misji = tm.id_misji AND 
    tm.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tln.typ_zdarzenia = 'Wyjście Warp';

-- 44. Jakie trasy prowadzą na terytorium gwiazd z temperaturą > 5000K
SELECT 
    ttn.nazwa AS szlak, 
    tm.nazwa AS operacja, 
    tp.nazwa AS ziemia_obiecana, 
    tg.temperatura_k
FROM 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm, 
    tbl_planety AS tp, 
    tbl_gwiazdy AS tg
WHERE 
    ttn.id_misji = tm.id_misji AND 
    tm.id_docelowej_planety = tp.id_planety AND 
    tp.id_gwiazdy = tg.id_gwiazdy AND 
    tg.temperatura_k > 5000;

-- 45. Najlepsi nawigatorzy, ich sprzęt, statek i obecna trasa
SELECT 
    tn.nazwisko, 
    tn.specjalizacja, 
    tsk.nazwa AS statek, 
    tin.nazwa AS kluczowy_skaner, 
    ttn.typ_napędu
FROM 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin, 
    tbl_trasy_nawigacyjne AS ttn,
    tbl_misje AS tm
WHERE 
    tn.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tm.id_statku = tsk.id_statku AND
    ttn.id_misji = tm.id_misji AND
    tn.stopien IN ('Starszy Nawigator', 'Kapitan Nawigator');

-- 46. Szybkie zestawienie kosztów: budżet misji vs koszt instrumentów
SELECT 
    tm.nazwa AS projekt, 
    tm.budzet_PLN, 
    tin.nazwa AS technologia, 
    tin.cena_PLN
FROM 
    tbl_misje AS tm, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin
WHERE 
    tm.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tm.budzet_PLN > 10000000;

-- 47. Misje przerwane - powiązane planety, systemy celownicze i ostatni log
SELECT 
    tm.nazwa AS upadla_misja, 
    tp.nazwa AS nieosiagniety_cel, 
    tin.nazwa AS wadliwy_sprzet, 
    tln.opis AS ostatnia_wiadomosc
FROM 
    tbl_misje AS tm, 
    tbl_planety AS tp, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_instrumenty_nawigacyjne AS tin, 
    tbl_logi_nawigacyjne AS tln
WHERE 
    tm.id_docelowej_planety = tp.id_planety AND 
    tm.id_statku = tsk.id_statku AND 
    tin.id_statku = tsk.id_statku AND 
    tln.id_misji = tm.id_misji AND 
    tm.status = 'Przerwana';

-- 48. Sieć zależności planety macierzystej obserwatorium i jego misji
SELECT 
    tob.nazwa AS baza_kontroli, 
    tp.nazwa AS planeta_bazy, 
    tm.nazwa AS operacja_powiazana
FROM 
    tbl_obserwatoria AS tob, 
    tbl_planety AS tp, 
    tbl_misje AS tm
WHERE 
    tob.id_planety = tp.id_planety AND 
    tm.id_docelowej_planety = tp.id_planety;

-- 49. Złożony raport z układu Słonecznego (6 tabel)
SELECT 
    tk.nazwa AS rejon,
    tg.nazwa AS gwiazda,
    tp.nazwa AS cialo_niebieskie,
    tm.nazwa AS misja,
    tn.nazwisko AS oficer,
    tln.opis AS log_operacyjny
FROM 
    tbl_konstelacje AS tk,
    tbl_gwiazdy AS tg,
    tbl_planety AS tp,
    tbl_misje AS tm,
    tbl_nawigatorzy AS tn,
    tbl_logi_nawigacyjne AS tln
WHERE 
    tg.id_konstelacji = tk.id_konstelacji AND
    tp.id_gwiazdy = tg.id_gwiazdy AND
    tm.id_docelowej_planety = tp.id_planety AND
    tm.id_nawigatora = tn.id_nawigatora AND
    tln.id_misji = tm.id_misji AND
    tg.nazwa = 'Słońce';

-- 50.
SELECT 
    tln.znacznik_czasu, 
    tln.typ_zdarzenia, 
    tn.nazwisko AS oficer_odpowiedzialny, 
    tsk.nazwa AS statek_kosmiczny, 
    ttn.nazwa AS obrana_trasa, 
    tp.nazwa AS koordynaty_celu
FROM 
    tbl_logi_nawigacyjne AS tln, 
    tbl_nawigatorzy AS tn, 
    tbl_statki_kosmiczne AS tsk, 
    tbl_trasy_nawigacyjne AS ttn, 
    tbl_misje AS tm, 
    tbl_planety AS tp
WHERE 
    tln.id_misji = tm.id_misji AND 
    tln.id_nawigatora = tn.id_nawigatora AND 
    tn.id_statku = tsk.id_statku AND 
    ttn.id_misji = tm.id_misji AND 
    tm.id_docelowej_planety = tp.id_planety;