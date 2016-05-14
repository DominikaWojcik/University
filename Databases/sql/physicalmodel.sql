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
    aktywowany BOOLEAN DEFAULT false,
    rodzaj rodzaj_uzytkownika,
    email TEXT NOT NULL UNIQUE,
    telefon VARCHAR(16) NOT NULL UNIQUE,

    PRIMARY KEY (id)
);

--WYMAGA PRAW SUPERUSERA
-- Umożliwienie kożystania z SHA-256
-- md5(random()::TEXT) - do salt
-- hash to SHA-256(salt ++ pin)
CREATE EXTENSION pgcrypto;

CREATE TABLE uzytkownik_auth(
    id INTEGER NOT NULL UNIQUE,
    salt TEXT NOT NULL,
    hash BYTEA NOT NULL,

    FOREIGN KEY (id) REFERENCES uzytkownik(id)
);

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

    FOREIGN KEY (id) REFERENCES miejsce(id),

    CHECK (liczba_stanowisk >= 0)
);

CREATE TABLE serwis(
    id INTEGER NOT NULL UNIQUE,
    telefon VARCHAR(16) NOT NULL,

    FOREIGN KEY (id) REFERENCES miejsce(id)
);

CREATE TABLE zatrudnienie(
    serwisant_id INTEGER NOT NULL,
    serwis_id INTEGER NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    data_zwolnienia DATE,

    FOREIGN KEY (serwisant_id) REFERENCES uzytkownik(id),
    FOREIGN KEY (serwis_id) REFERENCES miejsce(id),

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

    FOREIGN KEY (rower_id) REFERENCES rower(id),
    FOREIGN KEY (miejsce_id) REFERENCES miejsce(id),

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
    FOREIGN KEY (rower_id) REFERENCES rower(id),
    FOREIGN KEY (uzytownik_id) REFERENCES uzytkownik(id),
    FOREIGN KEY (skad) REFERENCES miejsce(id),
    FOREIGN KEY (dokad) REFERENCES miejsce(id),

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

CREATE TABLE platnosc(
    rodzaj rodzaj_platnosci,
    wypozyczenie_id INTEGER,
    kwota NUMERIC(10,2) NOT NULL,
    waluta kod_waluty NOT NULL DEFAULT 'PLN',
    data_wystawienia DATE NOT NULL,
    data_zaplacenia DATE,

    FOREIGN KEY (wypozyczenie_id) REFERENCES wypozyczenie(id),

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

    FOREIGN KEY (rower_id) REFERENCES rower(id),
    FOREIGN KEY (zglaszajacy_id) REFERENCES uzytkownik(id),
    FOREIGN KEY (serwisant_id) REFERENCES uzytkownik(id),

    CHECK (data_naprawy IS NULL OR data_naprawy >= data_zgloszenia)
);
