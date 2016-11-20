let (++) f g = fun k -> f (g k);;

let inr k s n = k (s ^ (string_of_int n));;
let eol k s = k (s ^ "\n");;
let str k s s2 = k (s ^ s2);;
let lit str k s = k (s ^ str);;
let flt k s f = k (s ^ (string_of_float f));;

let sprintf format = format (fun res -> res) "";;

sprintf (lit "Ala ma " ++ inr ++ lit " kot" ++ str ++ lit ".") 5 "ow";;

