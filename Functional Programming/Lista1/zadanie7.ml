function x -> x;;
(*Typ 'a -> 'a *)

(function x -> 1 * x);;
(*Typ int -> int *)

let join f g x = f(g x);;
(*Typ ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b *)

let rec funkcja x = funkcja x;;
(* Typ 'a -> 'b *)