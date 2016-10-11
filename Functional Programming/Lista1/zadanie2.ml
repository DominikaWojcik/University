if true then 4 else 5;;
(* Liczy się typ pierwszego argumentu *)
if false then 1 else 3.5;;    
(* Operator + oczekuje dwóch intów, operator +. słuzy do floatow*)
4.75 + 2.34;;
false || "ab ">" cd";;
if true then ();;
(*typ if okreslany przez wyrazenie zwracane dla true*)
if false then () else 4;;
(* konkatenacja stringów *)
let x = 2 in x ^ "aa";;
let y = "abc" in y ^ y;;
(* character na pozycji 1 = 'b' *)
(fun x -> x.[1]) "abcdef";;
(fun x -> x) true;;
let x = [1;2] in x @ x;;
let rec f f = f + f in f 42;;
