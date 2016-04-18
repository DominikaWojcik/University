/*
Znajdź w bazie danych odpowiedzi na poniższe zapytania. Nie musisz zadawać jednego zapytania SQL zwracającego poszukiwaną odpowiedź - możesz zrobić to kilkoma zapytaniami, sprawdzić, ile krotek system zwrócił w odpowiedzi. Kierując się takimi zasadami powinno dać się znaleźć odpowiedzi na wszystkie pytania korzystając z podstawowego zasobu wiedzy o SQL: formułując pytania z grupowaniem, selekcją i rzutowaniem, ewentulanie sumowaniem i odejmowaniem zbiorów.

1. Podaj (uporządkowane alfabetycznie, zapisane z polskimi literami i oddzielone przecinkami - bez spacji) nazwiska prowadzących ćwiczenia z Matematyki dyskretnej (M) w semestrze zimowym 2010/2011.
2. Podaj imię i nazwisko osoby (oddzielone 1 spacją), która jako pierwsza zapisała się na wykład z Matematyki dyskretnej (M) w semestrze zimowym 2010/2011.
3. Przez ile dni (zaokrągl wynik w górę) studenci zapisywali się na wykład z Matematyki dyskretnej (M) w semestrze zimowym 2010/2011
4. Do ilu przedmiotów obowiązkowych jest repetytorium?
5. Ile osób prowadziło ćwiczenia do przedmiotów obowiązkowych w semestrach zimowych? Do odpowiedzi wliczamy sztucznych użytkowników (o “dziwnych” nazwiskach).
6. Podaj nazwy wszystkich przedmiotów (w kolejności alfabetycznej, oddzielone przecinkami, a wewnątrz nazw pojedyńczymi spacjami), do których zajęcia prowadził użytkownik o nazwisku Urban.
7. Ile jest w bazie osób o nazwisku Kabacki z dowolnym numerem na końcu?
8. Ile osób co najmniej dwukrotnie się zapisało na Algorytmy i struktury danych (M) w różnych semestrach (na dowolne zajęcia)?
9. W którym semestrze (podaj numer) było najmniej przedmiotów obowiązkowych (rozważ tylko semestry, gdy był co najmniej jeden)?
10. Ile grup ćwiczeniowych z Logiki dla informatyków  było w semestrze zimowym  2010/2011?
11. W którym semestrze (podaj numer) było najwięcej przedmiotów obowiązkowych?
12. Ile przedmiotów ma w nazwie dopisek '(ang.)'?
13. W jakim okresie (od dnia do dnia) studenci zapisywali się na przedmioty w semestrze zimowym 2009/2010? Podaj odpowiedź w formacie rrrr-mm-dd,rrrr-mm-dd
14. Ile przedmiotów typu kurs nie miało edycji w żadnym semestrze (nie występują w tabeli przedmiot_semestr)?
15. Ile grup ćwiczenio-pracowni prowadziła P.Kanarek?
16. Ile grup z Logiki dla informatyków prowadził W.Charatonik?
17. Ile osób uczęszczało dwa razy na Bazy danych?
18. Ile osób zapisało sie na jakiś przedmiot w każdym z semestrów zapisanych w bazie?
*/
--#1
WITH AA AS (SELECT *
    FROM grupa JOIN przedmiot_semestr USING(kod_przed_sem)
        JOIN przedmiot USING(kod_przed)
        JOIN uzytkownik USING(kod_uz)
    WHERE semestr_id=38 AND rodzaj_zajec='c')

SELECT DISTINCT nazwisko
FROM AA
WHERE nazwa='Matematyka dyskretna (M)'
ORDER BY nazwisko;


--#2
WITH wyklad AS (SELECT kod_przed_sem
    FROM przedmiot JOIN przedmiot_semestr USING(kod_przed)
        JOIN grupa USING(kod_przed_sem)
    WHERE semestr_id=38 AND rodzaj_zajec='w' AND nazwa='Matematyka dyskretna (M)')

SELECT imie||' '||nazwisko
FROM grupa JOIN wyklad ON grupa.kod_przed_sem=wyklad.kod_przed_sem
    JOIN wybor USING(kod_grupy)
    JOIN uzytkownik ON wybor.kod_uz=uzytkownik.kod_uz
ORDER BY data ASC
LIMIT 1;

--#3
WITH wyklad AS (SELECT kod_przed_sem
    FROM przedmiot JOIN przedmiot_semestr USING(kod_przed)
        JOIN grupa USING(kod_przed_sem)
    WHERE semestr_id=38 AND rodzaj_zajec='w' AND nazwa='Matematyka dyskretna (M)'),

zapisy AS (SELECT data
    FROM grupa JOIN wyklad ON grupa.kod_przed_sem=wyklad.kod_przed_sem
    JOIN wybor on grupa.kod_grupy=wybor.kod_grupy)

SELECT MAX(date_trunc('day', z1.data - z2.data + interval '1 day'))
FROM zapisy z1, zapisy z2;

--#4
SELECT COUNT(DISTINCT nazwa)
FROM grupa NATURAL JOIN przedmiot_semestr NATURAL JOIN przedmiot
WHERE rodzaj_zajec='e';

--#5
WITH przedZimOb AS (SELECT kod_przed_sem
    FROM przedmiot_semestr NATURAL JOIN przedmiot
        JOIN semestr USING(semestr_id)
    WHERE semestr.nazwa LIKE '% zimowy %' AND przedmiot.rodzaj='o')

SELECT COUNT(DISTINCT kod_uz)
FROM grupa JOIN przedZimOb USING (kod_przed_sem)
    NATURAL JOIN uzytkownik
WHERE grupa.rodzaj_zajec='c';

--#6
SELECT DISTINCT przedmiot.nazwa
FROM grupa NATURAL JOIN uzytkownik
    NATURAL JOIN przedmiot_semestr
    NATURAL JOIN przedmiot
WHERE uzytkownik.nazwisko='Urban'
ORDER BY nazwa;

--#7
SELECT COUNT(nazwisko)
FROM uzytkownik
WHERE nazwisko LIKE 'Kabacki%';

--#8
WITH grupyAISD AS (SELECT kod_grupy, semestr_id
    FROM grupa NATURAL JOIN przedmiot_semestr
        NATURAL JOIN przedmiot
    WHERE nazwa='Algorytmy i struktury danych (M)'),

zapisyNaAISD AS (SELECT kod_grupy, kod_uz, semestr_id
    FROM wybor JOIN grupyAISD USING(kod_grupy))

SELECT COUNT(DISTINCT kod_uz)
FROM zapisyNaAISD z1 JOIN zapisyNaAISD z2 USING(kod_uz)
WHERE z1.semestr_id != z2.semestr_id;

--#9
SELECT semestr_id
FROM przedmiot_semestr NATURAL JOIN przedmiot
WHERE rodzaj='o'
GROUP BY semestr_id
ORDER BY COUNT(kod_przed_sem) ASC
LIMIT 1;

--#10
SELECT COUNT(DISTINCT kod_grupy)
FROM grupa NATURAL JOIN przedmiot_semestr
    NATURAL JOIN przedmiot
    JOIN semestr USING(semestr_id)
WHERE semestr.nazwa LIKE '% zimowy 2010/2011'
    AND przedmiot.nazwa LIKE 'Logika dla informatyków%';

--#11
SELECT semestr_id
FROM przedmiot_semestr NATURAL JOIN przedmiot
WHERE przedmiot.rodzaj='o'
GROUP BY semestr_id
ORDER BY COUNT(kod_przed_sem) DESC
LIMIT 1;

--#12
SELECT COUNT(*)
FROM przedmiot
WHERE nazwa LIKE '%(ang.)';

--#13
WITH przed AS (SELECT kod_przed_sem
    FROM przedmiot_semestr JOIN semestr USING(semestr_id)
    WHERE semestr.nazwa LIKE '%zimowy 2009%'),

zapisy AS (SELECT data
    FROM przed JOIN grupa USING(kod_przed_sem)
        JOIN wybor USING(kod_grupy)),

zapisA AS (SELECT MIN(data)
    FROM zapisy),

zapisB AS (SELECT MAX(data)
    FROM zapisy)

SELECT * FROM zapisA, zapisB;

--#14
SELECT nazwa
FROM przedmiot
WHERE rodzaj='k' AND kod_przed NOT IN(SELECT kod_przed FROM przedmiot_semestr);

--#15
SELECT COUNT(*)
FROM grupa NATURAL JOIN uzytkownik
WHERE nazwisko='Kanarek' AND imie LIKE 'P%' AND rodzaj_zajec='r';

--#16
SELECT COUNT(DISTINCT kod_grupy)
FROM grupa NATURAL JOIN uzytkownik
    JOIN przedmiot_semestr USING(kod_przed_sem)
    JOIN przedmiot USING(kod_przed)
WHERE nazwisko='Charatonik' AND imie='Witold' AND przedmiot.nazwa='Logika dla informatyków';

--#17
WITH grupyBD AS (SELECT kod_grupy, semestr_id
    FROM grupa NATURAL JOIN przedmiot_semestr
        NATURAL JOIN przedmiot
    WHERE nazwa='Bazy danych'),

wyborBD AS (SELECT kod_uz, kod_grupy, semestr_id
    FROM wybor JOIN grupyBD USING(kod_grupy))

SELECT COUNT(DISTINCT w1.kod_uz)
FROM wyborBD w1 JOIN wyborBD w2 ON w1.kod_uz=w2.kod_uz
WHERE w1.semestr_id != w2.semestr_id;

--#18
WITH UZYTK AS (SELECT wybor.kod_uz
FROM grupa JOIN wybor USING(kod_grupy)
    JOIN przedmiot_semestr USING(kod_przed_sem)
GROUP BY wybor.kod_uz
HAVING COUNT(DISTINCT semestr_id)=6)

SELECT COUNT(*)
FROM UZYTK;
