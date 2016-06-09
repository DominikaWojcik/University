/*
    MODEL FIZYCZNY - ROWERY MIEJSKIE

    Autor:      Jarosław Dzikowski
    Indeks:     273233
    Grupa:      JMI
*/

/* CZYSCIMY */

DROP DATABASE IF EXISTS rowery_miejskie;
DROP ROLE IF EXISTS rowery_user;
DROP ROLE IF EXISTS rowery_administrator;

/* TWORZYMY BAZĘ I ŁĄCZYMY SIE DO NIEJ*/

CREATE DATABASE rowery_miejskie
    OWNER DEFAULT
    ENCODING 'Unicode';

\connect rowery_miejskie

/* DODAJEMY KRYPTOGRAFIĘ*/

CREATE EXTENSION pgcrypto;

/* TYPY DANYCH */

CREATE DOMAIN rodzaj_uzytkownika AS VARCHAR(16)
CHECK (VALUE IN ('klient', 'serwisant', 'ksiegowy'));

CREATE DOMAIN rodzaj_miejsca AS VARCHAR(16)
CHECK (VALUE IN ('stacja', 'serwis'));

CREATE DOMAIN rodzaj_platnosci AS VARCHAR(16)
CHECK (VALUE IN ('wypozyczenie', 'rejestracja', 'kara'));

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
    aktywny BOOLEAN NOT NULL DEFAULT TRUE,
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
    aktywny BOOLEAN DEFAULT TRUE,

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
    active BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id)
);

CREATE TABLE rower_miejsce(
    rower_id INTEGER NOT NULL,
    miejsce_id INTEGER,
    stanowisko INTEGER,
    od_kiedy TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (rower_id),
    FOREIGN KEY (rower_id) REFERENCES rower(id) DEFERRABLE,
    FOREIGN KEY (miejsce_id) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (stanowisko IS NULL OR stanowisko >= 0)
);

CREATE TABLE wypozyczenie(
    id SERIAL NOT NULL,
    rower_id INTEGER NOT NULL,
    uzytkownik_id INTEGER NOT NULL,
    skad INTEGER NOT NULL,
    skad_stanowisko INTEGER,
    dokad INTEGER,
    dokad_stanowisko INTEGER,
    data_wypozyczenia TIMESTAMP WITH TIME ZONE NOT NULL,
    data_zwrotu TIMESTAMP WITH TIME ZONE,

    PRIMARY KEY (id),
    FOREIGN KEY (rower_id) REFERENCES rower(id) DEFERRABLE,
    FOREIGN KEY (uzytkownik_id) REFERENCES uzytkownik(id) DEFERRABLE,
    FOREIGN KEY (skad) REFERENCES miejsce(id) DEFERRABLE,
    FOREIGN KEY (dokad) REFERENCES miejsce(id) DEFERRABLE,

    CHECK (skad_stanowisko IS NULL OR skad_stanowisko >= 0),
    CHECK (dokad_stanowisko IS NULL OR dokad_stanowisko >= 0),
    CHECK (data_zwrotu IS NULL OR data_zwrotu >= data_wypozyczenia)
);


-- Ponoć najlepszym sposobem reprezenacji pieniędzy nie jest
-- typ MONEY, lecz typ numeryczny (N cyfr znaczących, M cyfr po przecinku)
-- jako, że użytkownicy nie będą płacić milionów, to starczy NUMERIC(10,2)
CREATE TABLE platnosc(
    id SERIAL NOT NULL,
    rodzaj rodzaj_platnosci,
    uzytkownik_id INTEGER,
    wypozyczenie_id INTEGER,
    kwota NUMERIC(10,2) NOT NULL,
    data_wystawienia DATE NOT NULL,
    data_zaplacenia DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (wypozyczenie_id) REFERENCES wypozyczenie(id) DEFERRABLE,
    FOREIGN KEY (uzytkownik_id) REFERENCES uzytkownik(id) DEFERRABLE,

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

/* FUNKCJE */

CREATE OR REPLACE FUNCTION zaokraglij_godziny(INTERVAL)
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
    aktywny_uzyt BOOLEAN;
BEGIN
    SELECT id, aktywny INTO znalezione_id, aktywny_uzyt
        FROM uzytkownik
        WHERE podany_telefon = telefon;
    IF znalezione_id IS NULL OR aktywny_uzyt = FALSE THEN RETURN FALSE; END IF;

    SELECT u.salt, u.hash
        INTO salt, correct_hash
        FROM uzytkownik_auth u
        WHERE u.id = znalezione_id;
    IF correct_hash IS NULL THEN RETURN FALSE; END IF;

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
        miejscowosc, kraj, data_rejestracji,
        rodzaj, email, telefon)
        VALUES (im, nazw, adr, kod_p, miejs, kr,
            CURRENT_TIMESTAMP, 'klient', eml, tel)
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
        od_kiedy = NEW.data_zwrotu
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
    czas_wypozyczenia INTERVAL;
    naleznosc NUMERIC(10,2);
BEGIN
    SELECT uzytkownik.rodzaj INTO kto FROM uzytkownik WHERE uzytkownik.id = NEW.uzytkownik_id;
    IF kto != 'klient' THEN RETURN NEW; END IF;

    --SELECT NEW.data_zwrotu - NEW.data_wypozyczenia INTO czas_wypozyczenia;
    SELECT CURRENT_TIMESTAMP- NEW.data_wypozyczenia INTO czas_wypozyczenia;
    CASE
        WHEN czas_wypozyczenia > interval '1 hour' THEN
            SELECT zaokraglij_godziny(czas_wypozyczenia) * 4 INTO naleznosc;
        WHEN czas_wypozyczenia > interval '20 minute' THEN
            SELECT 2 INTO naleznosc;
        ELSE
            RETURN NEW;
    END CASE;

    INSERT INTO platnosc(rodzaj, uzytkownik_id, wypozyczenie_id, kwota,
        data_wystawienia, data_zaplacenia)
    VALUES ('wypozyczenie', NEW.uzytkownik_id, NEW.id, naleznosc, CURRENT_DATE, NULL);
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
CREATE ROLE rowery_administrator
    SUPERUSER
    LOGIN
    PASSWORD 'admin';

GRANT ALL PRIVILEGES ON DATABASE rowery_miejskie TO rowery_administrator;

CREATE ROLE rowery_user
    LOGIN
    PASSWORD 'user';

GRANT CONNECT ON DATABASE rowery_miejskie TO rowery_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rowery_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rowery_user;
/*
GRANT ALL PRIVILEGES ON uzytkownik TO rowery_user;
GRANT ALL PRIVILEGES ON rower TO rowery_user;
GRANT ALL PRIVILEGES ON rower_miejsce TO rowery_user;
GRANT ALL PRIVILEGES ON miejsce TO rowery_user;
GRANT ALL PRIVILEGES ON stacja TO rowery_user;
GRANT ALL PRIVILEGES ON serwis TO rowery_user;
GRANT ALL PRIVILEGES ON zatrudnienie TO rowery_user;
GRANT ALL PRIVILEGES ON usterka TO rowery_user;
GRANT ALL PRIVILEGES ON wypozyczenie TO rowery_user;
GRANT ALL PRIVILEGES ON platnosc TO rowery_user; */
GRANT EXECUTE ON FUNCTION sprawdz_pin(VARCHAR(16), TEXT) TO rowery_user;
GRANT EXECUTE ON FUNCTION zarejestruj_uzytkownika(VARCHAR(16),
    VARCHAR(32), TEXT, VARCHAR(8), VARCHAR(32), VARCHAR(32),
    TEXT, VARCHAR(16), TEXT) TO rowery_user;
GRANT ALL PRIVILEGES ON stan_stacji TO rowery_user;
/*
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
GRANT SELECT, INSERT, UPDATE ON rower TO serwisant;
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
*/
