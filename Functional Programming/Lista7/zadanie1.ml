let rec fix f n = f (fix f) n;;

let fact = fix (fun f-> fun n -> if n = 0 then 1 else n * (f (n-1)));;
fact 9;;

let factImp n = 
  (* Inicjalizacja losowa funkcja int w int *)
  let acc = ref (function _ -> 1) in
  let aux m = if m = 0 then 1 else m * (!acc (m-1)) in
  acc := aux;
  !acc n;;

factImp 9;;

let fix2 f =
  (*Nigdy nie zostanie uruchomione - dno funkcji*) 
  let acc  = ref (fun x -> failwith "This will never happen!") in
  let g n = f !acc n in
  acc := g;
  !acc ;;


let fact2 = fix2 (fun f-> fun n -> if n = 0 then 1 else n * (f (n-1)));;
fact2 9;;