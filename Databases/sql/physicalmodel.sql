DROP DATABASE IF EXISTS rowery_miejskie;

CREATE DATABASE rowery_miejskie
    OWNER DEFAULT
    ENCODING 'Unicode';

\connect rowery_miejskie



CREATE DOMAIN rodzaj_uzytkownika AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('klient', 'serwisant'));

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

INSERT INTO uzytkownik(imie, nazwisko, adres, kod_pocztowy,
    miejscowosc, kraj, data_rejestracji, aktywowany,
    rodzaj, email, telefon)
    VALUES ('Jaroslaw', 'Dzikowski',
    'Szczytnicka 39/5', '50-382', 'Wrocław', 'Polska',
    CURRENT_TIMESTAMP, false, 'klient',
    'jarekdzikowski1337@gmail.com', '+48792247908');

--WYMAGA PRAW SUPERUSERA
-- Umożliwienie kożystania z SHA-256
-- md5(random()::TEXT) - do salt
-- hash to SHA-256(salt ++ pin)
CREATE EXTENSION pgcrypto;

CREATE TABLE uzytkownik_auth(
    id INTEGER NOT NULL UNIQUE,
    salt TEXT NOT NULL,
    hash BYTEA NOT NULL,

    FOREIGN KEY (id) REFERENCES uzytkownik(id) DEFERRABLE
);

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

CREATE DOMAIN rodzaj_miejsca AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('stacja', 'serwis'));

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
    od_kiedy TIMESTAMP WITH TIME ZONE,

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

CREATE DOMAIN rodzaj_platnosci AS VARCHAR(16)
NOT NULL
CHECK (VALUE IN ('wypozyczenie', 'rejestracja', 'kara'));

CREATE DOMAIN kod_waluty AS VARCHAR(3)
NOT NULL
CHECK (VALUE IN ('USD', 'PLN', 'EUR'));

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
