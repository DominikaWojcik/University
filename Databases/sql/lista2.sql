/*Dla każdego z poniższych zapytań napisz JEDNO zapytanie SQL, które zwraca informację będącą odpowiedzią na pytanie.

1. Podaj kody, imiona i nazwiska wszystkich osób, które chodziły na dowolne zajęcia z Algorytmów i struktur danych, a w jakimś semestrze późniejszym (o większym numerze) chodziły na zajęcia z Matematyki dyskretnej. Za AiSD oraz MD uznaj wszystkie przedmioty, których nazwa zaczyna się od podanych nazw. Zapisz to zapytanie używając operatora IN z podzapytaniem.
2. Zapisz zapytanie pierwsze używając operatora EXISTS z podzapytaniem.
3. Podaj kody, imiona i nazwiska osób, które prowadziły jakiś wykład, ale nigdy nie prowadziły żadnego seminarium (nie patrzymy, czy zajęcia były w tym samym semestrze). Pisząc zapytanie użyj operatora NOT EXISTS.
4. Zapisz zapytanie trzecie, używając różnicy zbiorów.
5. Dla każdego przedmiotu typu kurs z bazy danych podaj jego nazwę oraz liczbę osób, które na niego uczęszczały. Uwzględnij w odpowiedzi kursy, na które nikt nie uczęszczał – w tym celu użyj złączenia zewnętrznego (LEFT JOIN lub RIGHT JOIN).
6. Podaj kody użytkowników, którzy uczęszczali w semestrze letnim 2010/2011 na wykład z 'Baz danych' i nie uczęszczali na wykład z 'Sieci komputerowych', i odwrotnie. Sformułuj to zapytanie używając instrukcji WITH, by wstępnie zdefiniować zbiory osób uczęszczających na każdy z wykładów.
7. Podaj kody, imiona i nazwiska wszystkich prowadzących, którzy w jakiejś prowadzonej przez siebie grupie mieli więcej zapisanych osób, niż wynosił limit max_osoby dla tej grupy. Do zapisania zapytania użyj GROUP BY i HAVING.
8. Podaj nazwę przedmiotu podstawowego, na wykład do którego chodziło najwięcej różnych osób. Użyj w tym celu zapytania z GROUP BY i HAVING (z warunkiem używającym ponownie GROUP BY).
9. Dla każdego semestru letniego podaj jego numer oraz nazwisko osoby, która jako pierwsza zapisała się na zajęcia w tym semestrze. Jeśli w semestrze było kilka osób, które zapisały się jednocześnie:
	podaj wszystkie;
	podaj tę o najwcześniejszym leksykograficznie nazwisku.
10. Jaka jest średnia liczba osób zapisujących się na wykład w semestrze letnim 2010/2011? Zapisz to zapytanie definiując najpierw pomocniczą relację (np. na liście from z aliasem), w której dla każdego interesującego cię wykładu znajdziesz liczbę zapisanych na niego osób).
11. Kto prowadzi w jednym semestrze wykład do przedmiotu i co najmniej dwie grupy innych zajęć do tego przedmiotu (nie muszą być tego samego typu)?
*/

--#1
SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM uzytkownik NATURAL JOIN wybor
	JOIN grupa USING(kod_grupy)
	JOIN przedmiot_semestr ps1 USING(kod_przed_sem)
	JOIN przedmiot USING(kod_przed)
WHERE przedmiot.nazwa LIKE 'Algorytmy i struktury danych%'
	AND uzytkownik.kod_uz IN (SELECT u2.kod_uz
		FROM uzytkownik u2 NATURAL JOIN wybor w2
			JOIN grupa g2 USING(kod_grupy)
			JOIN przedmiot_semestr ps2 USING(kod_przed_sem)
			JOIN przedmiot p2 USING(kod_przed)
		WHERE p2.nazwa LIKE 'Matematyka dyskretna%'
			AND ps1.semestr_id < ps2.semestr_id);

--#2
SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM uzytkownik NATURAL JOIN wybor
	JOIN grupa USING(kod_grupy)
	JOIN przedmiot_semestr ps1 USING(kod_przed_sem)
	JOIN przedmiot USING(kod_przed)
WHERE przedmiot.nazwa LIKE 'Algorytmy i struktury danych%'
	AND EXISTS (SELECT u2.kod_uz
		FROM uzytkownik u2 NATURAL JOIN wybor w2
			JOIN grupa g2 USING(kod_grupy)
			JOIN przedmiot_semestr ps2 USING(kod_przed_sem)
			JOIN przedmiot p2 USING(kod_przed)
		WHERE u2.kod_uz = uzytkownik.kod_uz AND
			p2.nazwa LIKE 'Matematyka dyskretna%'
			AND ps1.semestr_id < ps2.semestr_id);

--#3
SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM grupa NATURAL JOIN uzytkownik
WHERE grupa.rodzaj_zajec = 'w' AND
	NOT EXISTS(SELECT g2.kod_uz
		FROM grupa g2
		WHERE g2.rodzaj_zajec = 's'
			AND g2.kod_uz = uzytkownik.kod_uz);

--#4
(SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM grupa NATURAL JOIN uzytkownik
WHERE grupa.rodzaj_zajec = 'w')
EXCEPT
(SELECT DISTINCT uzytkownik.kod_uz, uzytkownik.imie, uzytkownik.nazwisko
FROM grupa NATURAL JOIN uzytkownik
WHERE grupa.rodzaj_zajec = 's');

--#5
SELECT przedmiot.nazwa, COUNT(DISTINCT wybor.kod_uz)
FROM przedmiot LEFT JOIN przedmiot_semestr USING(kod_przed)
	LEFT JOIN grupa USING(kod_przed_sem)
	LEFT JOIN wybor ON grupa.kod_grupy = wybor.kod_grupy
WHERE przedmiot.rodzaj = 'k'
GROUP BY przedmiot.nazwa;

--#6
WITH BD AS (SELECT DISTINCT uzytkownik.kod_uz
	FROM grupa JOIN wybor USING(kod_grupy)
		JOIN przedmiot_semestr USING(kod_przed_sem)
		JOIN przedmiot USING(kod_przed)
		JOIN uzytkownik ON wybor.kod_uz = uzytkownik.kod_uz
		JOIN semestr USING(semestr_id)
	WHERE grupa.rodzaj_zajec = 'w'
		AND przedmiot.nazwa = 'Bazy danych'
		AND semestr.nazwa = 'Semestr letni 2010/2011'),

SK AS (SELECT DISTINCT uzytkownik.kod_uz
	FROM grupa JOIN wybor USING(kod_grupy)
		JOIN przedmiot_semestr USING(kod_przed_sem)
		JOIN przedmiot USING(kod_przed)
		JOIN uzytkownik ON wybor.kod_uz = uzytkownik.kod_uz
		JOIN semestr USING(semestr_id)
	WHERE grupa.rodzaj_zajec = 'w'
		AND przedmiot.nazwa = 'Sieci komputerowe'
		AND semestr.nazwa = 'Semestr letni 2010/2011')

((SELECT * FROM BD)
EXCEPT
(SELECT * FROM SK))
UNION
((SELECT * FROM SK)
EXCEPT
(SELECT * FROM BD));

--#7
SELECT DISTINCT uzytkownik.kod_uz, imie, nazwisko
FROM grupa NATURAL JOIN uzytkownik
	JOIN wybor USING(kod_grupy)
GROUP BY uzytkownik.kod_uz, kod_grupy
HAVING COUNT(DISTINCT wybor.kod_uz) > grupa.max_osoby;

--#8
SELECT przedmiot.nazwa
FROM przedmiot NATURAL JOIN przedmiot_semestr
	NATURAL JOIN grupa
	JOIN wybor USING(kod_grupy)
WHERE przedmiot.rodzaj = 'p'
	AND grupa.rodzaj_zajec = 'w'
GROUP BY przedmiot.nazwa
HAVING COUNT(DISTINCT wybor.kod_uz) >= ALL(
	SELECT COUNT(DISTINCT w2.kod_uz)
	FROM przedmiot p2 NATURAL JOIN przedmiot_semestr ps2
		NATURAL JOIN grupa g2
		JOIN wybor w2 USING(kod_grupy)
	WHERE p2.rodzaj = 'p'
		AND g2.rodzaj_zajec = 'w'
	GROUP BY p2.nazwa);

--#9
--Wszystkie nazwiska
SELECT DISTINCT semestr_id, nazwisko, wybor.data
FROM wybor NATURAL JOIN uzytkownik
	JOIN grupa USING(kod_grupy)
	JOIN przedmiot_semestr USING(kod_przed_sem)
WHERE wybor.data <= ALL(SELECT w2.data
	FROM wybor w2 JOIN grupa g2 USING(kod_grupy)
		JOIN przedmiot_semestr ps2 USING(kod_przed_sem)
	WHERE ps2.semestr_id = przedmiot_semestr.semestr_id)
ORDER BY semestr_id ASC, nazwisko ASC, wybor.data ASC;

--Pierwsze leksykograficzne
SELECT DISTINCT semestr_id, nazwisko, wybor.data
FROM wybor NATURAL JOIN uzytkownik
	JOIN grupa USING(kod_grupy)
	JOIN przedmiot_semestr USING(kod_przed_sem)
WHERE (wybor.data, nazwisko) <= ALL(SELECT w2.data, u2.nazwisko
	FROM wybor w2 JOIN grupa g2 USING(kod_grupy)
		JOIN przedmiot_semestr ps2 USING(kod_przed_sem)
		JOIN uzytkownik u2 ON w2.kod_uz = u2.kod_uz
	WHERE ps2.semestr_id = przedmiot_semestr.semestr_id)
ORDER BY semestr_id ASC, nazwisko ASC, wybor.data ASC;

--#10
WITH WYKLADY AS (SELECT kod_przed_sem, COUNT(DISTINCT uzytkownik.kod_uz) AS zapisani
	FROM grupa JOIN wybor USING(kod_grupy)
		JOIN przedmiot_semestr USING(kod_przed_sem)
		JOIN semestr USING(semestr_id)
		JOIN uzytkownik ON wybor.kod_uz = uzytkownik.kod_uz
	WHERE semestr.nazwa = 'Semestr letni 2010/2011'
		AND grupa.rodzaj_zajec = 'w'
	GROUP BY kod_przed_sem)

SELECT AVG(zapisani)
FROM WYKLADY;

--#11
WITH wykladowcy AS (SELECT DISTINCT kod_uz, kod_przed_sem
	FROM grupa
	WHERE rodzaj_zajec = 'w'),

minDwieGrupy AS (SELECT DISTINCT kod_uz, kod_przed_sem
	FROM grupa g1 JOIN grupa g2 USING(kod_uz, kod_przed_sem)
	WHERE g1.kod_grupy != g2.kod_grupy
		AND g1.rodzaj_zajec != 'w'
		AND g2.rodzaj_zajec != 'w')

SELECT DISTINCT kod_uz, imie, nazwisko
FROM wykladowcy NATURAL JOIN minDwieGrupy
	NATURAL JOIN uzytkownik;
