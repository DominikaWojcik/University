-- Zadanie 1

CREATE OR REPLACE FUNCTION pierwszy_zapis(int, int) RETURNS TIMESTAMP WITH TIME ZONE AS
$X$
    SELECT wybor.data
    FROM wybor JOIN grupa USING(kod_grupy)
        JOIN przedmiot_semestr USING(kod_przed_sem)
    WHERE wybor.kod_uz = $1
        AND przedmiot_semestr.semestr_id = $2
    ORDER BY wybor.data ASC
    LIMIT 1;
$X$
LANGUAGE SQL IMMUTABLE;

WITH sem AS (SELECT semestr_id FROM semestr WHERE semestr = 'zimowy' AND rok = '2010/2011')
SELECT DISTINCT student.nazwisko, pierwszy_zapis(student.kod_uz, sem.semestr_id) AS czas
FROM student, sem
WHERE student.nazwisko LIKE 'A%'
    AND pierwszy_zapis(student.kod_uz, sem.semestr_id) IS NOT NULL
ORDER BY czas ASC;

-- Zadanie 2
CREATE OR REPLACE FUNCTION plan_zajec_prac(int, int) RETURNS TABLE(
    nazwa TEXT,
    kod_grupy INTEGER,
    rodzaj_zajec rodzaje_zajec,
    termin CHAR(13),
    sala VARCHAR(3),
    liczba_studentow INTEGER
)
AS
$X$
    SELECT przedmiot.nazwa, grupa.kod_grupy,
        grupa.rodzaj_zajec, grupa.termin,
        grupa.sala, COUNT(DISTINCT student.kod_uz)::INT
    FROM pracownik NATURAL JOIN grupa
        JOIN przedmiot_semestr USING(kod_przed_sem)
        JOIN przedmiot USING(kod_przed)
        JOIN wybor USING(kod_grupy)
        JOIN student ON wybor.kod_uz = student.kod_uz
    WHERE pracownik.kod_uz = $1
        AND przedmiot_semestr.semestr_id = $2
    GROUP BY grupa.kod_grupy, przedmiot.nazwa;
$X$
LANGUAGE SQL IMMUTABLE;

SELECT * FROM plan_zajec_prac(187, 39);

-- Zadanie 3

CREATE OR REPLACE FUNCTION przydziel_praktyki() RETURNS VOID AS
$X$
DECLARE
    s student;
    wolna_oferta INTEGER;
BEGIN
    FOR s IN (SELECT student.*
        FROM student LEFT JOIN praktyki ON student.kod_uz = praktyki.student
        WHERE student.semestr BETWEEN 6 AND 10
            AND praktyki.oferta IS NULL)
    LOOP
        SELECT max(kod_oferty) INTO wolna_oferta
            FROM oferta_praktyki NATURAL JOIN semestr
            WHERE liczba_miejsc > 0
                AND semestr.rok = '2013/2014'
                AND semestr.semestr = 'letni';
        IF wolna_oferta IS NULL THEN EXIT; END IF;
        INSERT INTO praktyki VALUES(s.kod_uz, NULL, wolna_oferta);
        UPDATE oferta_praktyki
            SET liczba_miejsc = liczba_miejsc - 1
            WHERE kod_oferty = wolna_oferta;
    END LOOP;
END
$X$
LANGUAGE PLpgSQL;

SELECT przydziel_praktyki();

-- Zadanie 4

CREATE OR REPLACE FUNCTION zapisz_tez_na_wyklad_procedura() RETURNS TRIGGER AS
$X$
DECLARE
    rodzaj rodzaje_zajec;
    przed_sem INTEGER;
    grupa_wykladowa INTEGER;
BEGIN
    SELECT DISTINCT rodzaj_zajec, kod_przed_sem INTO rodzaj, przed_sem
        FROM grupa
        WHERE grupa.kod_grupy = NEW.kod_grupy;

    SELECT kod_grupy INTO grupa_wykladowa
        FROM grupa
        WHERE grupa.kod_przed_sem = przed_sem
            AND grupa.rodzaj_zajec = 'w';

    IF rodzaj = 'w' THEN RETURN NEW; END IF;

    IF (SELECT COUNT(*)::INT
        FROM wybor JOIN grupa USING(kod_grupy)
        WHERE wybor.kod_uz = NEW.kod_uz
            AND grupa.kod_przed_sem = przed_sem
            AND grupa.rodzaj_zajec = 'w') = 0
    THEN
        INSERT INTO wybor(kod_uz, kod_grupy, data)
            VALUES(NEW.kod_uz, grupa_wykladowa, NEW.data);
    END IF;

    RETURN NEW;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER zapisz_tez_na_wyklad
AFTER INSERT ON wybor FOR EACH ROW
EXECUTE PROCEDURE zapisz_tez_na_wyklad_procedura();

CREATE OR REPLACE FUNCTION zapisz_inne_grupy_na_wyklad_procedura()
RETURNS TRIGGER AS
$X$
BEGIN
    IF NEW.rodzaj_zajec != 'w' THEN RETURN NEW; END IF;

    INSERT INTO wybor(kod_uz, kod_grupy, data)
        SELECT DISTINCT kod_uz, NEW.kod_grupy, CURRENT_TIMESTAMP
        FROM wybor JOIN grupa USING(kod_grupy)
        WHERE kod_przed_sem = NEW.kod_przed_sem
            AND rodzaj_zajec != 'w';

    RETURN NEW;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER zapisz_inne_grupy_na_wyklad
AFTER INSERT ON grupa FOR EACH ROW
EXECUTE PROCEDURE zapisz_inne_grupy_na_wyklad_procedura();

CREATE RULE zablokuj_update_on_wybor AS ON UPDATE TO wybor
DO INSTEAD NOTHING;

CREATE OR REPLACE FUNCTION wypisanie_z_wykladu_gdy_w_innych_grupach_procedura()
RETURNS TRIGGER AS
$X$
DECLARE
    g grupa;

BEGIN
    SELECT grupa.* INTO g FROM grupa WHERE kod_grupy = OLD.kod_grupy;

    IF g.rodzaj_zajec != 'w' THEN RETURN OLD; END IF;

    IF EXISTS (SELECT * FROM wybor JOIN grupa USING(kod_grupy)
        WHERE wybor.kod_uz = OLD.kod_uz
            AND grupa.kod_przed_sem = g.kod_przed_sem
            AND grupa.kod_grupy != g.kod_grupy
            AND grupa.rodzaj_zajec != 'w')
    THEN
        ROLLBACK;
    END IF;

    RETURN OLD;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER wypisanie_z_wykladu_gdy_w_innych_grupach
BEFORE DELETE ON wybor FOR EACH ROW
EXECUTE PROCEDURE wypisanie_z_wykladu_gdy_w_innych_grupach_procedura();

-- Zadanie 5

ALTER TABLE wybor ADD COLUMN data_wyp TIMESTAMP WITH TIME ZONE DEFAULT now();
ALTER TABLE wybor DROP CONSTRAINT wybor_key;

CREATE VIEW akt_wybor(
    kod_uz,
    kod_grupy
)
AS
SELECT kod_uz, kod_grupy
FROM wybor
WHERE wybor.data_wyp IS NULL;

CREATE OR REPLACE RULE usun_akt_wybor AS
ON DELETE TO akt_wybor
DO ALSO (UPDATE wybor SET data_wyp = CURRENT_TIMESTAMP
    WHERE kod_uz = OLD.kod_uz AND kod_grupy = OLD.kod_grupy);

CREATE OR REPLACE RULE dodaj_akt_wybor AS
ON INSERT TO akt_wybor
DO INSTEAD (
    UPDATE wybor SET data_wyp = CURRENT_TIMESTAMP
    WHERE kod_uz = NEW.kod_uz
        AND kod_grupy IN (SELECT grupa.kod_grupy
            FROM wybor JOIN grupa USING(kod_grupy)
            WHERE wybor.kod_uz = NEW.kod_uz
                AND wybor.data_wyp IS NULL
                AND (grupa.rodzaj_zajec, grupa.kod_przed_sem) IN (SELECT g.rodzaj_zajec, g.kod_przed_sem
                    FROM grupa g
                    WHERE g.kod_grupy = NEW.kod_grupy));

    INSERT INTO wybor(kod_uz, kod_grupy, data, data_wyp)
        VALUES(NEW.kod_uz, NEW.kod_grupy, CURRENT_TIMESTAMP, NULL)
);
