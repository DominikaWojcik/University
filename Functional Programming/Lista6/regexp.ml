type regexp = 
    Atom of char
  | And of regexp * regexp
  | Or of regexp * regexp
  | Star of regexp;;

(* match_regexp : regexp -> char list -> (char list -> (unit -> 'a) -> 'a) -> (unit -> 'a) -> 'a *)
let rec match_regexp r cs sc fc = match r with
    Atom x -> (match cs with 
        c::cs' -> if x = c
        then sc cs' fc
        else fc ()
      | _ -> fc ())
  | And (r1, r2) -> match_regexp r1 cs (fun cs' fc' -> match_regexp r2 cs' sc fc') fc
  | Or (r1, r2) -> match_regexp r1 cs sc (fun () -> match_regexp r2 cs sc fc)
  | Star r1 -> match_regexp r1 cs 
                 (fun cs' fc' -> 
                    sc cs' (fun () -> match_regexp r cs' sc fc')) fc;;

(* run : regexp -> char list -> bool *)
let run r cs = match_regexp r cs (fun _ _ -> true) (fun () -> false);;

(* testy *)

(* abcabcddabcddddef *)
let text = ['a';'b';'c';'a';'b';'c';'d';'d';'a';'b';'c';'d';'d';'d';'d';'e';'f'];;
(* abcabcddbcddddef - brakuje jednego 'a' *)
let text2 = ['a';'b';'c';'a';'b';'c';'d';'d';'b';'c';'d';'d';'d';'d';'e';'f'];;

(* ({abc, (d)*})*ef *)
let testR = And (
    Star (Or (
        And(Atom 'a',And(Atom 'b', Atom 'c')), 
        Star(Atom 'd'))), 
    And(Atom 'e', Atom 'f'));;

run testR text;;
run testR text2;;