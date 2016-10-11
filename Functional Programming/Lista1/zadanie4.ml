let m = 10;;
let f x = m + x;;
let m = 100;; 

f 5;; 
(*Wynik to 15, ponieważ przy deklaracji f liczy się wartość zmiennej m a nie referencja do niej*)