-- Zadanie 1

CREATE DOMAIN semestry AS varchar(6)
NOT NULL
CHECK (VALUE IN ('letni', 'zimowy'));

CREATE SEQUENCE numer_semestru
INCREMENT BY 1;
SELECT setval('numer_semestru', MAX(semestr_id))
FROM semestr;

ALTER TABLE semestr ADD COLUMN semestr semestry DEFAULT 'letni';
ALTER TABLE semestr ADD COLUMN rok char(9);

UPDATE semestr SET semestr = split_part(nazwa, ' ', 2),
    rok = split_part(nazwa, ' ', 3);

ALTER TABLE semestr DROP COLUMN nazwa;

ALTER TABLE semestr ALTER semestr SET DEFAULT
    CASE WHEN EXTRACT(MONTH FROM current_date) <= 6 THEN 'letni'
        ELSE 'zimowy'
    END;
ALTER TABLE semestr ALTER rok SET DEFAULT
    CASE WHEN EXTRACT(MONTH FROM current_date) <= 6
        THEN EXTRACT(YEAR FROM current_date)-1||'/'||EXTRACT(YEAR FROM current_date)
        ELSE EXTRACT(YEAR FROM current_date)||'/'||EXTRACT(YEAR FROM current_date)+1
    END;

-- Zadanie 2

INSERT INTO semestr VALUES(nextval('numer_semestru'), 'zimowy', '2013/2014');
INSERT INTO semestr VALUES(nextval('numer_semestru'), 'letni', '2013/2014');

CREATE SEQUENCE numer_przedmiot_semestr
INCREMENT BY 1;
SELECT setval('numer_przedmiot_semestr', MAX(kod_przed_sem))
FROM przedmiot_semestr;

CREATE SEQUENCE numer_grupy
INCREMENT BY 1;
SELECT setval('numer_grupy', MAX(kod_grupy))
FROM grupa;

/* kopiowanie przedmiotów do roku 2013/2014 */
INSERT INTO przedmiot_semestr
(WITH zimowe AS (SELECT przedmiot_semestr.*
    FROM przedmiot_semestr NATURAL JOIN przedmiot
        NATURAL JOIN semestr
    WHERE (przedmiot.rodzaj='o' OR przedmiot.rodzaj='p')
        AND semestr.semestr='zimowy'
        AND semestr.rok='2010/2011'),

semestrZimowy AS (SELECT semestr_id
    FROM semestr
    WHERE semestr.rok='2013/2014'
        AND semestr.semestr='zimowy')

SELECT nextval('numer_przedmiot_semestr'), semestrZimowy.semestr_id, zimowe.kod_przed,
    zimowe.strona_domowa, zimowe.angielski
FROM zimowe CROSS JOIN semestrZimowy);

INSERT INTO przedmiot_semestr
(WITH letnie AS (SELECT przedmiot_semestr.*
    FROM przedmiot_semestr NATURAL JOIN przedmiot
        NATURAL JOIN semestr
    WHERE (przedmiot.rodzaj='o' OR przedmiot.rodzaj='p')
        AND semestr.semestr='letni'
        AND semestr.rok='2010/2011'),

semestrLetni AS (SELECT semestr_id
    FROM semestr
    WHERE semestr.rok='2013/2014'
        AND semestr.semestr='letni')

SELECT nextval('numer_przedmiot_semestr'), semestrLetni.semestr_id, letnie.kod_przed,
    letnie.strona_domowa, letnie.angielski
FROM letnie CROSS JOIN semestrLetni);

/* Dodajemy grupy */
ALTER TABLE grupa ALTER COLUMN kod_uz DROP NOT NULL;

INSERT INTO grupa(kod_grupy, kod_przed_sem, max_osoby, rodzaj_zajec)
(SELECT nextval('numer_grupy'), kod_przed_sem, 100, 'w'
FROM przedmiot_semestr NATURAL JOIN semestr
WHERE semestr.rok='2013/2014');

/* Wyszukujemy je*/
SELECT grupa
FROM grupa NATURAL JOIN przedmiot_semestr
    NATURAL JOIN semestr
WHERE semestr.rok='2013/2014';

-- Zadanie 3

CREATE TABLE pracownik(
    kod_uz INTEGER PRIMARY KEY NOT NULL,
    imie VARCHAR(15) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL
);

CREATE TABLE student(
    kod_uz INTEGER PRIMARY KEY NOT NULL,
    imie VARCHAR(15) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL,
    semestr SMALLINT
);

INSERT INTO pracownik
(SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM grupa NATURAL JOIN uzytkownik);

INSERT INTO student
(SELECT DISTINCT uzytkownik.*
FROM wybor NATURAL JOIN uzytkownik);

ALTER TABLE wybor DROP CONSTRAINT "fk_wybor_uz";
ALTER TABLE wybor ADD CONSTRAINT "fk_wybor_uz"
    FOREIGN KEY (kod_uz) REFERENCES student(kod_uz) DEFERRABLE;

ALTER TABLE grupa DROP CONSTRAINT "fk_grupa_uz";
ALTER TABLE grupa ADD CONSTRAINT "fk_grupa_uz"
    FOREIGN KEY (kod_uz) REFERENCES pracownik(kod_uz) DEFERRABLE;

DROP TABLE uzytkownik;

-- Zadanie 4

CREATE DOMAIN rodzaje_zajec AS VARCHAR(1)
NOT NULL
CHECK (VALUE IN ('w', 'e', 's', 'c', 'C', 'p', 'P', 'r', 'R', 'g', 'l'));

ALTER TABLE grupa ALTER COLUMN rodzaj_zajec TYPE rodzaje_zajec;

CREATE VIEW obsada_zajec_view(
    prac_kod,
    prac_nazwisko,
    przed_kod,
    przed_nazwa,
    rodzaj_zajec,
    liczba_grup,
    liczba_studentow
)
AS
SELECT pracownik.kod_uz, pracownik.nazwisko,
    przedmiot.kod_przed, przedmiot.nazwa,
    grupa.rodzaj_zajec, COUNT(DISTINCT grupa.kod_grupy), COUNT(wybor.kod_uz)
FROM pracownik NATURAL JOIN grupa
    NATURAL JOIN przedmiot_semestr
    NATURAL JOIN przedmiot
    JOIN wybor ON grupa.kod_grupy = wybor.kod_grupy
GROUP BY pracownik.kod_uz, przedmiot.kod_przed, grupa.rodzaj_zajec;

CREATE TABLE obsada_zajec_tab(
    prac_kod INTEGER,
    prac_nazwisko VARCHAR(30),
    przed_kod INTEGER,
    przed_nazwa TEXT,
    rodzaj_zajec rodzaje_zajec,
    liczba_grup INTEGER,
    liczba_studentow INTEGER
);

INSERT INTO obsada_zajec_tab
SELECT pracownik.kod_uz, pracownik.nazwisko,
    przedmiot.kod_przed, przedmiot.nazwa,
    grupa.rodzaj_zajec, COUNT(DISTINCT grupa.kod_grupy), COUNT(wybor.kod_uz)
FROM pracownik NATURAL JOIN grupa
    NATURAL JOIN przedmiot_semestr
    NATURAL JOIN przedmiot
    JOIN wybor ON grupa.kod_grupy = wybor.kod_grupy
GROUP BY pracownik.kod_uz, przedmiot.kod_przed, grupa.rodzaj_zajec;

/* Zapytanie na perspektywie */
EXPLAIN ANALYZE(
WITH ProPrzedLicz AS
    (SELECT prac_kod, prac_nazwisko, przed_kod, przed_nazwa, SUM(liczba_studentow) AS ile
    FROM obsada_zajec_view
    GROUP BY prac_kod, prac_nazwisko, przed_kod, przed_nazwa)

SELECT ProPrzedLicz
FROM ProPrzedLicz JOIN przedmiot ON ProPrzedLicz.przed_kod = przedmiot.kod_przed
WHERE (przedmiot.rodzaj = 'o' OR przedmiot.rodzaj = 'p')
ORDER BY ProPrzedLicz.ile DESC
LIMIT 1);

/* Zapytanie na tabeli */
EXPLAIN ANALYZE(
WITH ProPrzedLicz AS
    (SELECT prac_kod, prac_nazwisko, przed_kod, przed_nazwa, SUM(liczba_studentow) AS ile
    FROM obsada_zajec_tab
    GROUP BY prac_kod, prac_nazwisko, przed_kod, przed_nazwa)

SELECT ProPrzedLicz
FROM ProPrzedLicz JOIN przedmiot ON ProPrzedLicz.przed_kod = przedmiot.kod_przed
WHERE (przedmiot.rodzaj = 'o' OR przedmiot.rodzaj = 'p')
ORDER BY ProPrzedLicz.ile DESC
LIMIT 1);

/* Na tabeli wyszlo turbo*/

-- Zadanie 5

CREATE TABLE firma(
    kod_firmy SERIAL PRIMARY KEY NOT NULL,
    nazwa TEXT NOT NULL,
    adres TEXT NOT NULL,
    kontakt TEXT NOT NULL
);

INSERT INTO firma(nazwa, adres, kontakt)
VALUES ('SNS', 'Wrocław', 'H.Kloss'),
    ('BIT', 'Kraków', 'R.Bruner'),
    ('MIT', 'Berlin', 'J.Kos');

CREATE TABLE oferta_praktyki(
    kod_oferty SERIAL PRIMARY KEY NOT NULL,
    kod_firmy INTEGER,
    semestr_id INTEGER,
    liczba_miejsc INTEGER CHECK (liczba_miejsc > 0),
    FOREIGN KEY (kod_firmy) REFERENCES firma(kod_firmy),
    FOREIGN KEY (semestr_id) REFERENCES semestr(semestr_id)
);

INSERT INTO oferta_praktyki(kod_firmy, semestr_id, liczba_miejsc)
SELECT kod_firmy, semestr_id, 3
FROM firma, semestr
WHERE firma.nazwa = 'SNS'
    AND semestr.semestr = 'letni'
    AND semestr.rok = '2013/2014';

INSERT INTO oferta_praktyki(kod_firmy, semestr_id, liczba_miejsc)
SELECT kod_firmy, semestr_id, 2
FROM firma, semestr
WHERE firma.nazwa = 'MIT'
    AND semestr.semestr = 'letni'
    AND semestr.rok = '2013/2014';

CREATE TABLE praktyki(
    student INTEGER,
    opiekun INTEGER,
    oferta INTEGER,
    FOREIGN KEY (student) REFERENCES student(kod_uz),
    FOREIGN KEY (opiekun) REFERENCES pracownik(kod_uz),
    FOREIGN KEY (oferta) REFERENCES oferta_praktyki(kod_oferty)
);

BEGIN TRANSACTION;

INSERT INTO praktyki(student,oferta)
SELECT kod_uz,kod_oferty
FROM student s,oferta_praktyki o
WHERE kod_uz =
 (SELECT MAX(kod_uz) FROM student WHERE
  semestr BETWEEN 6 AND 10 AND kod_uz NOT IN
  (SELECT student FROM praktyki))
 AND
 kod_oferty =
 (SELECT MAX(kod_oferty) FROM oferta_praktyki
  WHERE liczba_miejsc > 0 AND semestr_id =
        (SELECT MAX(semestr_id) FROM semestr));

UPDATE oferta_praktyki SET liczba_miejsc = liczba_miejsc - 1
WHERE kod_oferty =
   (SELECT MAX(kod_oferty) FROM oferta_praktyki
   WHERE liczba_miejsc > 0 AND semestr_id =
      (SELECT MAX(semestr_id) FROM semestr));

COMMIT;

/* Którzy studenci z semestrów 6 do 10 nie zaliczyli jeszcze praktyk*/
SELECT student
FROM student
WHERE student.semestr BETWEEN 6 AND 10
    AND student.kod_uz NOT IN (SELECT student FROM praktyki);

/* Liczba ofert na najwiekszy semestr w bazie*/
SELECT SUM(liczba_miejsc)
FROM oferta_praktyki
WHERE semestr_id >= ALL (SELECT p.semestr_id FROM oferta_praktyki p);

DELETE FROM oferta_praktyki
WHERE oferta_praktyki.kod_oferty NOT IN (SELECT oferta FROM praktyki);

DELETE FROM firma
WHERE firma.kod_firmy IN (SELECT f1.kod_firmy FROM oferta_praktyki f1 EXCEPT
        SELECT f2.kod_firmy FROM praktyki NATURAL JOIN oferta_praktyki f2);

-- Zadanie 6

CREATE VIEW plan_zajec(
    student,
    semestr_id,
    przed_kod,
    termin,
    sala
)
AS
SELECT student.kod_uz, przedmiot_semestr.semestr_id,
    przedmiot_semestr.kod_przed, grupa.termin, grupa.sala
FROM wybor NATURAL JOIN student
    JOIN grupa USING(kod_grupy)
    JOIN przedmiot_semestr USING(kod_przed_sem);

SELECT plan_zajec.*
FROM plan_zajec JOIN semestr USING(semestr_id)
WHERE plan_zajec.student = 3298
    AND semestr.semestr='letni'
    AND semestr.rok='2009/2010';

SELECT DISTINCT 162 AS pracownik, pz.przed_kod, pz.termin, pz.sala
FROM plan_zajec pz JOIN przedmiot_semestr ps ON (pz.przed_kod=ps.kod_przed
                                    AND pz.semestr_id=ps.semestr_id)
    JOIN grupa USING(sala, termin, kod_przed_sem)
    JOIN semestr ON(pz.semestr_id = semestr.semestr_id)
WHERE grupa.kod_uz = 162
    AND semestr.semestr='letni'
    AND semestr.rok='2009/2010';

SELECT DISTINCT pz.sala, pz.termin, przedmiot.nazwa
FROM plan_zajec pz NATURAL JOIN semestr
    JOIN przedmiot ON pz.przed_kod = przedmiot.kod_przed
WHERE pz.sala = '25'
    AND semestr.semestr='letni'
    AND semestr.rok='2009/2010'
ORDER BY termin ASC;
