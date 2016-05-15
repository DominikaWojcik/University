/*
    MODEL FIZYCZNY - ROWERY MIEJSKIE

    Autor:      Jarosław Dzikowski
    Indeks:     273233
    Grupa:      JMI
*/

/* CZYSCIMY */

DROP DATABASE IF EXISTS rowery_miejskie;
DROP ROLE IF EXISTS serwisant;
DROP ROLE IF EXISTS klient;
DROP ROLE IF EXISTS administrator;
DROP ROLE IF EXISTS ksiegowy;

/* TWORZYMY BAZĘ I ŁĄCZYMY SIE DO NIEJ*/

CREATE DATABASE rowery_miejskie
    OWNER DEFAULT
    ENCODING 'Unicode';

\connect rowery_miejskie

/* DODAJEMY KRYPTOGRAFIĘ*/

CREATE EXTENSION pgcrypto;

/* TYPY DANYCH */

CREATE DOMAIN rodzaj_uzytkownika AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('klient', 'serwisant'));

CREATE DOMAIN rodzaj_miejsca AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('stacja', 'serwis'));

CREATE DOMAIN rodzaj_platnosci AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('wypozyczenie', 'rejestracja', 'kara'));

CREATE DOMAIN kod_waluty AS VARCHAR(3)
NOT NULL;

/* TABELE */

CREATE TABLE uzytkownik(
    id SERIAL NOT NULL,
    imie VARCHAR(16) NOT NULL,
    nazwisko VARCHAR(32) NOT NULL,
    adres TEXT NOT NULL,
    kod_pocztowy VARCHAR(8),
    miejscowosc VARCHAR(32) NOT NULL,
    kraj VARCHAR(32) NOT NULL,
    data_rejestracji TIMESTAMP WITH TIME ZONE NOT NULL,
    aktywowany BOOLEAN NOT NULL DEFAULT false,
    rodzaj rodzaj_uzytkownika DEFAULT 'klient',
    email TEXT NOT NULL UNIQUE,
    telefon VARCHAR(16) NOT NULL UNIQUE,

    PRIMARY KEY (id)
);

CREATE TABLE uzytkownik_auth(
    id INTEGER NOT NULL UNIQUE,
    salt TEXT NOT NULL,
    hash BYTEA NOT NULL,

    FOREIGN KEY (id) REFERENCES uzytkownik(id) DEFERRABLE
);

CREATE TABLE miejsce(
    id SERIAL NOT NULL,
    adres TEXT NOT NULL,
    kod_pocztowy VARCHAR(8),
    miejscowosc VARCHAR(32) NOT NULL,
    kraj VARCHAR(32) NOT NULL,
    rodzaj rodzaj_miejsca,

    PRIMARY KEY (id)
);

-- Zawiera informacje o unikatowych dla stacji cechach
CREATE TABLE stacja(
    id INTEGER NOT NULL UNIQUE,
    liczba_stanowisk INTEGER NOT NULL,

    FOREIGN KEY (id) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (liczba_stanowisk >= 0)
);

CREATE TABLE serwis(
    id INTEGER NOT NULL UNIQUE,
    telefon VARCHAR(16) NOT NULL,

    FOREIGN KEY (id) REFERENCES miejsce(id) DEFERRABLE
);

CREATE TABLE zatrudnienie(
    serwisant_id INTEGER NOT NULL,
    serwis_id INTEGER NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    data_zwolnienia DATE,

    FOREIGN KEY (serwisant_id) REFERENCES uzytkownik(id) DEFERRABLE,
    FOREIGN KEY (serwis_id) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (data_zwolnienia IS NULL OR data_zwolnienia >= data_zatrudnienia)
);

CREATE TABLE rower(
    id SERIAL NOT NULL,
    marka VARCHAR(16) NOT NULL,
    model VARCHAR(16),
    data_zakupu DATE NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE rower_miejsce(
    rower_id INTEGER NOT NULL,
    miejsce_id INTEGER,
    stanowisko INTEGER,
    od_kiedy TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (rower_id) REFERENCES rower(id) DEFERRABLE,
    FOREIGN KEY (miejsce_id) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (stanowisko IS NULL OR stanowisko >= 0)
);

CREATE TABLE wypozyczenie(
    id SERIAL NOT NULL,
    rower_id INTEGER NOT NULL,
    uzytownik_id INTEGER NOT NULL,
    skad INTEGER NOT NULL,
    skad_stanowisko INTEGER,
    dokad INTEGER,
    dokad_stanowisko INTEGER,
    data_wypozyczenia TIMESTAMP WITH TIME ZONE NOT NULL,
    data_zwrotu TIMESTAMP WITH TIME ZONE,

    PRIMARY KEY (id),
    FOREIGN KEY (rower_id) REFERENCES rower(id) DEFERRABLE,
    FOREIGN KEY (uzytownik_id) REFERENCES uzytkownik(id) DEFERRABLE,
    FOREIGN KEY (skad) REFERENCES miejsce(id) DEFERRABLE,
    FOREIGN KEY (dokad) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (skad_stanowisko IS NULL OR skad_stanowisko >= 0),
    CHECK (dokad_stanowisko IS NULL OR dokad_stanowisko >= 0),
    CHECK (data_zwrotu IS NULL OR data_zwrotu >= data_wypozyczenia)
);

-- Kody iso walut w przełożeniu na kraj (1 kraj - 1 waluta)
CREATE TABLE waluta_kraj(
    kod kod_waluty UNIQUE,
    kraj VARCHAR(32) UNIQUE
);

-- Ponoć najlepszym sposobem reprezenacji pieniędzy nie jest
-- typ MONEY, lecz typ numeryczny (N cyfr znaczących, M cyfr po przecinku)
-- jako, że użytkownicy nie będą płacić milionów, to starczy NUMERIC(10,2)
CREATE TABLE platnosc(
    rodzaj rodzaj_platnosci,
    wypozyczenie_id INTEGER,
    kwota NUMERIC(10,2) NOT NULL,
    waluta kod_waluty NOT NULL DEFAULT 'PLN',
    data_wystawienia DATE NOT NULL,
    data_zaplacenia DATE,

    FOREIGN KEY (wypozyczenie_id) REFERENCES wypozyczenie(id) DEFERRABLE,

    CHECK (kwota >= 0.0),
    CHECK (data_zaplacenia IS NULL OR data_zaplacenia >= data_wystawienia)
);

CREATE TABLE usterka(
    rower_id INTEGER NOT NULL,
    zglaszajacy_id INTEGER NOT NULL,
    serwisant_id INTEGER,
    data_zgloszenia DATE NOT NULL,
    data_naprawy DATE,
    opis TEXT NOT NULL,
    komentarz TEXT NOT NULL,

    FOREIGN KEY (rower_id) REFERENCES rower(id) DEFERRABLE,
    FOREIGN KEY (zglaszajacy_id) REFERENCES uzytkownik(id) DEFERRABLE,
    FOREIGN KEY (serwisant_id) REFERENCES uzytkownik(id) DEFERRABLE,

    CHECK (data_naprawy IS NULL OR data_naprawy >= data_zgloszenia)
);

/* WIDOKI */

CREATE VIEW stan_stacji(
    stacja_id,
    zapelnienie,
    adres,
    miejscowosc
)
AS
(SELECT s.id, COUNT(rm.rower_id) || '/' || s.liczba_stanowisk, m.adres, m.miejscowosc
FROM stacja s JOIN miejsce m USING(id)
    LEFT JOIN rower_miejsce rm ON s.id = rm.miejsce_id
GROUP BY s.id, s.liczba_stanowisk, m.adres, m.miejscowosc);

/* WSTAWIANIE DANYCH */

INSERT INTO uzytkownik(imie, nazwisko, adres, kod_pocztowy,
    miejscowosc, kraj, data_rejestracji, aktywowany,
    rodzaj, email, telefon)
    VALUES ('Jaroslaw', 'Dzikowski',
    'Szczytnicka 39/5', '50-382', 'Wrocław', 'Polska',
    CURRENT_TIMESTAMP, false, 'klient',
    'jarekdzikowski1337@gmail.com', '+48792247908');

INSERT INTO waluta_kraj VALUES
    ('PLN', 'Polska'),
    ('USD', 'USA'),
    ('EUR', 'Niemcy'),
    ('GBP', 'Anglia');

/* FUNKCJE */

CREATE OR REPLACE FUNCTION zaokraglij_godziny(TIMESTAMP WITH TIME ZONE)
RETURNS INTEGER AS
$X$
BEGIN
    RETURN EXTRACT (HOUR FROM
        date_trunc('hour', $1 + interval '30 minutes'));
END
$X$
LANGUAGE PLpgSQL;

CREATE OR REPLACE FUNCTION sprawdz_pin(podany_telefon VARCHAR(16), pin TEXT)
RETURNS BOOLEAN AS
$X$
DECLARE
    correct_hash BYTEA;
    salt TEXT;
    znalezione_id INTEGER;
BEGIN
    SELECT id INTO znalezione_id
        FROM uzytkownik
        WHERE podany_telefon = telefon;
    IF znalezione_id IS NULL THEN RETURN FALSE; END IF;

    SELECT u.salt, u.hash
        INTO salt, correct_hash
        FROM uzytkownik_auth u
        WHERE u.id = znalezione_id;
    RETURN (digest(salt || pin,'sha256') = correct_hash);
END
$X$
LANGUAGE PLpgSQL;

CREATE OR REPLACE FUNCTION zarejestruj_uzytkownika(im VARCHAR(16),
    nazw VARCHAR(32), adr TEXT, kod_p VARCHAR(8),
    miejs VARCHAR(32), kr VARCHAR(32),
    eml TEXT, tel VARCHAR(16), pin TEXT)
RETURNS VOID AS
$X$
DECLARE
    new_id INTEGER;
    new_salt TEXT;
BEGIN
    INSERT INTO uzytkownik(imie, nazwisko, adres, kod_pocztowy,
        miejscowosc, kraj, data_rejestracji, aktywowany,
        rodzaj, email, telefon)
        VALUES (im, nazw, adr, kod_p, miejs, kr,
            CURRENT_TIMESTAMP, false, 'klient', eml, tel)
        RETURNING id INTO new_id;

    SELECT md5(random()::TEXT) INTO new_salt;

    INSERT INTO uzytkownik_auth VALUES
        (new_id, new_salt, digest(new_salt || pin, 'sha256'));
END
$X$
LANGUAGE PLpgSQL;

/* TRIGGERY */

CREATE OR REPLACE FUNCTION aktualizacja_lokalizacji_po_zwrocie_procedura()
RETURNS TRIGGER AS
$X$
BEGIN
    UPDATE rower_miejsce
    SET miejsce_id = NEW.dokad,
        stanowisko = NEW.dokad_stanowisko,
        od_kiedy = NEW.czas_zwrotu
    WHERE rower_id = NEW.rower_id;
    RETURN NEW;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER aktualizacja_lokalizacji_po_zwrocie
AFTER UPDATE ON wypozyczenie FOR EACH ROW
WHEN (OLD.dokad IS NULL AND NEW.dokad IS NOT NULL)
EXECUTE PROCEDURE aktualizacja_lokalizacji_po_zwrocie_procedura();


CREATE OR REPLACE FUNCTION aktualizacja_lokalizacji_po_wypozyczeniu_procedura()
RETURNS TRIGGER AS
$X$
BEGIN
    UPDATE rower_miejsce
    SET miejsce_id = NULL,
        stanowisko = NULL,
        od_kiedy = NULL
    WHERE rower_id = NEW.rower_id;
    RETURN NEW;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER aktualizacja_lokalizacji_po_wypozyczeniu
AFTER INSERT ON wypozyczenie FOR EACH ROW
EXECUTE PROCEDURE aktualizacja_lokalizacji_po_wypozyczeniu_procedura();


CREATE OR REPLACE FUNCTION platnosc_za_wypozyczenie_procedura()
RETURNS TRIGGER AS
$X$
DECLARE
    kto rodzaj_uzytkownika;
    czas_wypozyczenia TIMESTAMP WITH TIME ZONE;
    naleznosc NUMERIC(10,2);
    waluta kod_waluty;
BEGIN
    SELECT uzytkownik.rodzaj INTO kto FROM uzytkownik WHERE id = NEW.uzytownik_id;
    IF kto != 'klient' THEN RETURN NEW; END IF;

    SELECT NEW.data_zwrotu - NEW.data_wypozyczenia INTO czas_wypozyczenia;
    CASE
        WHEN czas_wypozyczenia > interval '1 hour' THEN
            SELECT zaokraglij_godziny(czas_wypozyczenia) * 4 INTO naleznosc;
        WHEN czas_wypozyczenia > interval '20 minute' THEN
            SELECT 2 INTO naleznosc;
    END CASE;

    SELECT kod INTO waluta FROM waluta_kraj
        WHERE kraj IN (SELECT kraj FROM miejsce WHERE id = NEW.skad);

    INSERT INTO platnosc VALUES
        ('wypozyczenie', naleznosc, waluta, CURRENT_DATE, NULL);
    RETURN NEW;
END
$X$
LANGUAGE PLpgSQL;

CREATE TRIGGER platnosc_za_wypozyczenie_procedura
AFTER UPDATE ON wypozyczenie FOR EACH ROW
WHEN (OLD.dokad IS NULL AND NEW.dokad IS NOT NULL)
EXECUTE PROCEDURE platnosc_za_wypozyczenie_procedura();

/*UZYTKOWNICY*/

-- Administrator może robić wszystko
CREATE ROLE administrator
    LOGIN
    PASSWORD 'admin';

GRANT ALL PRIVILEGES ON DATABASE rowery_miejskie TO administrator;

-- Ustawiamy role klienta
CREATE ROLE klient
    LOGIN
    PASSWORD 'klient'
    ADMIN administrator;

GRANT CONNECT ON DATABASE rowery_miejskie TO klient;
GRANT SELECT (id, imie, nazwisko, adres, kod_pocztowy,
        miejscowosc, kraj, email, telefon),
    UPDATE (adres, kod_pocztowy, miejscowosc, kraj, email)
    ON uzytkownik TO klient;
GRANT EXECUTE ON FUNCTION sprawdz_pin(VARCHAR(16), TEXT) TO klient;
GRANT EXECUTE ON FUNCTION zarejestruj_uzytkownika(VARCHAR(16),
    VARCHAR(32), TEXT, VARCHAR(8), VARCHAR(32), VARCHAR(32),
    TEXT, VARCHAR(16), TEXT) TO klient;
GRANT SELECT, INSERT, UPDATE ON wypozyczenie TO klient;
GRANT SELECT ON miejsce TO klient;
GRANT SELECT ON platnosc TO klient;
GRANT INSERT ON usterka TO klient;

-- Ustawiamy role serwisanta
CREATE ROLE serwisant
    LOGIN
    PASSWORD 'serwisant'
    ADMIN administrator;

GRANT CONNECT ON DATABASE rowery_miejskie TO serwisant;
GRANT EXECUTE ON FUNCTION sprawdz_pin(VARCHAR(16), TEXT) TO serwisant;
GRANT SELECT, INSERT ON rower TO serwisant;
GRANT SELECT, INSERT, UPDATE ON wypozyczenie TO serwisant;
GRANT SELECT, INSERT, UPDATE ON rower_miejsce TO serwisant;
GRANT SELECT, INSERT, UPDATE ON usterka TO serwisant;
GRANT SELECT ON miejsce TO serwisant;
GRANT SELECT, UPDATE ON stacja TO serwisant;
GRANT SELECT ON stan_stacji TO serwisant;

-- Ustawiamy role księgowego
CREATE ROLE ksiegowy
    LOGIN
    PASSWORD 'ksiegowy'
    ADMIN administrator;

GRANT CONNECT ON DATABASE rowery_miejskie TO ksiegowy;
GRANT SELECT, INSERT, UPDATE ON platnosc TO ksiegowy;
GRANT SELECT ON wypozyczenie TO ksiegowy;
GRANT SELECT, UPDATE (aktywowany) ON uzytkownik TO ksiegowy;
