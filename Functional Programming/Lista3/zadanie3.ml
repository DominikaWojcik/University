let pochodna_rec p = match p with
  |[] -> []
  |hd::tl ->
    let rec aux num ps = match ps with
      |[] -> []
      |hd::tl -> (hd *. (float_of_int num)) :: (aux (num+1) tl)
    in aux 1 tl;;

pochodna_rec [1.;0.;-1.;2.];;

let pochodna p = 
  let rec range a b = 
    if a = b 
    then [float_of_int a] 
    else (float_of_int a)::(range (a+1) b)
  in if p = [] 
  then [] 
  else List.map2 ( *.) (List.tl p) (range 1 (List.length p - 1));;

  pochodna [1.;0.;-1.;2.];;