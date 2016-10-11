let x = x in x ^ x;;
(* Pierwsza związana z drugą, druga wolna, trzecia i czwarta zwiazana z pierwsza*)
let x = 10. in let y = x ** 2. in y *. x;;
(* Pierwsza związana, druga też *)
let x = 1 and y = x in x + y;;
(* Pierwsza zwiazana, druga wolna (bo najpierw liczymy prawe strony, a x jeszcze nie jest zadeklarowane), *)
let x = 1 in fun y z -> x * y * z;;
(* x związany, y oraz z wolne*)
