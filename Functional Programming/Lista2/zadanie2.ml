let rec a n = if n = 0 then 0 else 2 * (a (n-1)) + 1;;

let b n = let rec aux acc current target =
            if current = target
            then acc
            else aux (2*acc+1) (current+1) target
  in aux 0 0 n;;

a 1000000;; (*Dla dużych wartości mamy przepełnienie stosu*)
b 1000000;; (*Inty są na 64 miejscach po przecinku - wszystko dalej jest -1 z jakiegos powodu*)