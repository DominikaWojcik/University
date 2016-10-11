let plus a b = a + b;;
let plus' = fun a b -> a + b;;
let plus'' = function a -> function b -> a + b;;

plus 3 4;;
plus' 3 4;;
plus'' 3 4;;

let plus_3 a = plus 3 a;;

plus_3 39;;