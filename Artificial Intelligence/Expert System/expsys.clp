;;;***************************
;;;* Ekspert zabijania czasu *
;;;***************************
;;;* Jarosław Dzikowski      *
;;;* Nr indeksu 273233       *
;;;***************************


;;;----------------

(defrule rozpoczecie
	?f <- (initial-fact)
	=>
	(printout t "-----------------------------------------" crlf)
	(printout t "System Ekspercki zabijania wolnego czasu." crlf)
	(printout t "-----------------------------------------" crlf crlf)
	(assert (startEksperta))
)

(defrule jakaPoraDnia
	(startEksperta)
	(not (poraDnia ?))
	=>
	(printout t "Jaka jest pora dnia? (rano/poludnie/popoludnie/wieczor/noc)" crlf)
	(assert (godzina (read)))
)

(defrule idzSpac
	(poraDnia noc)
	=>
	(assert (rozwiazanie "Jest noc, idź spać..."))
)

(defrule ileCzasu
	(startEksperta)
	(not (czasWolny ?))
	=>
	(printout t "Ile masz wolnego czasu? (malo/godzina/dwieGodziny/kilkaGodzin/nieograniczony) " crlf)
	(assert(czasWolny (read)))
)

(defrule jakCieplo
	(startEksperta)
	(not (temperatura ?))
	(not (or (poraDnia wieczor) (poraDnia noc) (czasWolny malo)))
	=>
	(printout t "Jak ciepło jest na dworze? (mroz/zimno/srednio/cieplo/upal)" crlf)
	(assert (temperatura (read)))	
)

(defrule poziomAktywnosci
	(not (aktywnosc ?))
	(or (dwor tak) (dwor obojetnie))
	=>
	(printout t "Wolałbyś spędzić czas aktywnie? (tak/nie/obojetnie)" crlf)
	(assert (aktywnosc (read)))
)

(defrule zostajemyWDomu
	(not (dwor ?))
	(or (poraDnia wieczor) (poraDnia noc) (temperatura upal) (czasWolny malo))
	=>
	(assert (dwor nie))
)

(defrule wyjscieNaDwor 
	(startEksperta)
	(not (dwor ?))
	(not (or (poraDnia wieczor) (poraDnia noc) (temperatura upal) (czasWolny malo)))
	=>
	(printout t "Co myślisz o wychodzeniu na dwór? (tak/nie/obojetnie)" crlf)
	(assert (dwor (read)))
)

(defrule uzywanieElektroniki
	(not (elektronika ?))
	(or (dwor nie) (dwor obojetnie))
	=>
	(printout t "Co myślisz o używaniu urządzeń elektronicznych (komp,tel etc.)? (tak/nie/obojetnie)")
	(assert (elektronika (read)))
)


(defrule urzadzeniaElektroniczne
;Bez sensu pytanie skoro użytkownik używa tego programu
	(or (elektronika tak) (elektronika obojetnie))
	(not (urzadzenie ?))
	=>
	(printout t "Do jakich urządzeń elektronicznych masz dostęp? Wpisz w jednej linii (tv/smartphone/komputer/tablet)" crlf)
	(bind $?answer (explode$ (readline)))
	(loop-for-count (?cnt 1 (length$ ?answer)) do
		(assert (urzadzenie (nth$ ?cnt ?answer)))
	)
)

(defrule czytanieKsiazek
	(not (ksiazki ?))
	(or (dwor nie) (dwor obojetnie))
	=>
	(printout t "Czy lubisz czytać książki? (tak/nie/obojetnie)")
	(assert (ksiazki (read)))
)

(defrule nieprzeczytaneKsiazki
	(or (ksiazki tak) (ksiazki obojetnie))
	=>
	(printout t "Czy masz w domu jakieś nieprzeczytane ksiązki? (tak/nie)" crlf)
	(bind ?ans (read))
	(if (eq ?ans tak)
		then (assert (rozwiazanie "Poczytaj jakąś książkę.")))
)

(defrule film
	(or (dwor nie) (dwor obojetnie))
	(or (urzadzenie komputer) (urzadzenie tablet))
	(and (czasWolny ?) (not (czasWolny malo)) (not (czasWolny godzina)))
	=>
	(assert (rozwiazanie "Obejrzyj jakiś film."))
)

(defrule szybkaGra
	(not (szybka gra))
	(or (urzadzenie smartphone) (urzadzenie tablet) (urzadzenie komputer))
	(czasWolny malo)
	=>
	(assert (szybka gra))
	(assert (rozwiazanie "Zagraj na komputerze/telefonie/tablecie w jakąś gierkę."))
)

(defrule graKomputerowa
	(urzadzenie komputer)
	(and (czasWolny ?) (not (czasWolny malo)))
	=>
	(assert (rozwiazanie "Zagraj w jakąś grę komputerową."))
)

(defrule obejrzyjTelewizje
	(or (dwor nie) (dwor obojetnie))
	(urzadzenie tv)
	=>
	(assert (rozwiazanie "Pooglądaj telewizję jeśli jest tam coś ciekawego."))
)

(defrule zadaniaDoWykonania
	(not (deadline ?))
	(and (czasWolny ?) (not (czasWolny malo)))
	=>
	(printout t "Czy zbliża się termin oddania jakichś zadań (projekty, wypracowania etc.)? (tak/nie)" crlf)
	(assert (deadline (read)))
)

(defrule wezSieDoRoboty
	(deadline tak)
	=>
	(assert (rozwiazanie "Skoro masz jakieś zadania do zrobienia, to weź się w końcu do roboty!"))
)

(defrule nadchodzaceSprawdziany
	(not (sprawdzian ?))
	(and (czasWolny ?) (not (czasWolny malo)))
	=>
	(printout t "Czy nadchodzą jakieś sprawdziany, do których się jeszcze nie uczyłeś? (tak/nie)"crlf)
	(assert (sprawdzian (read)))
)

(defrule pouczSie
	(sprawdzian tak)
	=>
	(assert (rozwiazanie "Ucz się do sprawdzianu zamiast siedzieć przed komputerem!!!!"))
)

(defrule koledzy
	(not (koledzy ?))
	(or (dwor tak) (dwor obojetnie))
	(or (czasWolny kilkaGodzin) (czasWolny nieograniczony))
	=>
	(printout t "Czy masz jakichkolwiek kolegów, z którymi mógłbyś coś robić? (tak/nie)" crlf)
	(assert (koledzy (read)))
)

(defrule spacer
	(or (dwor tak) (dwor obojetnie))
	(or (aktywnosc nie) (aktywnosc obojetnie))
	(not (czasWolny malo))
	=>
	(assert (rozwiazanie "Pójdź na spacer"))
)

(defrule rower
	(or (dwor tak) (dwor obojetnie))
	(or (czasWolny dwieGodziny) (czasWolny kilkaGodzin) (czasWolny nieograniczony))
	(or (temperatura cieplo) (temperatura srednio))
	=>
	(assert (rozwiazanie "Jeśli masz rower, to pójdź pojeździć na nim!"))
)

(defrule mozeSport
	(or (dwor tak) (dwor obojetnie))
	(or (aktywnosc tak) (aktywnosc obojetnie))
	(not (czasWolny malo))
	(not (poraDnia noc))
	=>
	(assert (mozliwosc sport))
)

(defrule sportZespolowy
	(mozliwosc sport)
	(koledzy tak)
	=>
	(assert (rozwiazanie "Zagraj z kolegami w jakiś sport (np. piłkę nożną, koszykówkę)."))
)

(defrule bieganie 
	(mozliwosc sport)
	(or (temperatura cieplo) (temperatura srednio))
	=>
	(assert (rozwiazanie "Idź sobie pobiegać."))
)

(defrule czyWydawacPieniadze
	(or (dwor tak) (dwor obojetnie))
	(not (pieniadze ?))
	=>
	(printout t "Czy możesz sobie pozwolić na wydawanie pieniędzy? (tak/nie)")
	(assert (pieniadze (read)))
)

(defrule silownia
	(mozliwosc sport)
	(pieniadze tak)
	=>
	(assert (rozwiazanie "Wybierz się na siłownię."))
)

(defrule kino
	(or (dwor tak) (dwor obojetnie))
	(pieniadze tak)
	(or (czasWolny kilkaGodzin) (czasWolny nieograniczony))
	=>
	(assert (rozwiazanie "Pójdź do kina na jakiś film."))
)

(defrule spotkanieZKolegami
	(koledzy tak)
	(pieniadze tak)
	(or (poraDnia poludnie) (poraDnia popoludnie))
	=>
	(assert (rozwiazanie "Spotkaj się/ wyjdź na miasto z kolegami."))
)

(defrule cosPozytecznego
	(startEksperta)
	(not (obowiazkiDomowe ?))
	=>
	(printout t "Jakie są twoje chęci jeśli chodzi o wykonywanie obowiazków domowych? (tak/nie/obojetnie)" crlf)
	(assert (obowiazkiDomowe (read)))
)

(defrule zakupy
	(or (dwor tak) (dwor obojetnie))
	(or (obowiazkiDomowe tak) (obowiazkiDomowe obojetnie))
	(czasWolny ?czasW)
	(not (czasWolny malo))
	=>
	(assert (rozwiazanie "Wybierz się na zakupy."))
)

(defrule sprzatanie
	(or (obowiazkiDomowe tak) (obowiazkiDomowe obojetnie))
	=>
	(assert (rozwiazanie "Posprzątaj w domu / pokoju."))
)

(defrule wypiszRozwiazanie
	(startEksperta)
	?f <- (rozwiazanie ?rozw)
	=>
	(printout t "-----------------------------------------" crlf)
	(printout t "Propozycja:" crlf ?rozw crlf) 
	(printout t "-----------------------------------------" crlf)
	(retract ?f)
)
