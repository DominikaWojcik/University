let horner_tail p x = 
  let rec aux ps acc = match ps with
    |[] -> acc
    |hd::tl -> aux tl (acc *. x +. hd)
  in aux p 0.;;

horner_tail [1.;0.;-1.;2.] 3.;;

let horner p x = List.fold_left (fun acc y -> acc *. x +. y) 0. p;;

horner [1.;0.;-1.;2.] 3.;;