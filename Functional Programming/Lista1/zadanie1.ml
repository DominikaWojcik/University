let a = 4;;
let b = 4.332;;
(* Kiedyś stringi były mutable, teraz nie są. Jak sie pokaże bytes zamiast string, to odpalic utop z parametrem -safe-string. I tak to to samo
   http://caml.inria.fr/pub/docs/manual-ocaml/libref/String.html *)
let c = 'c';;
let d = "dsdsd";;
let e = true;;
let f = ();;

(*
Reszta zadania w makefile - 
    make ocamlc
    make ocamlopt
    make clean
*)