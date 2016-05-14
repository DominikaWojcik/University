DROP TABLE uzytkownik CASCADE;
DROP TABLE uzytkownik_auth CASCADE;
DROP TABLE rower CASCADE;
DROP TABLE miejsce CASCADE;
DROP TABLE stacja CASCADE;
DROP TABLE serwis CASCADE;
DROP TABLE zatrudnienie CASCADE;
DROP TABLE wypozyczenie CASCADE;
DROP TABLE platnosc CASCADE;
DROP TABLE rower_miejsce;
DROP TABLE usterka CASCADE;

DROP DOMAIN rodzaj_miejsca;
DROP DOMAIN rodzaj_platnosci;
DROP DOMAIN rodzaj_uzytkownika;
DROP DOMAIN kod_waluty;

DROP EXTENSION pgcrypto;
