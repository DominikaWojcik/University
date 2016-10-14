let rec map f xs =
  match xs with
    [] -> []
  |hd::tl -> (f hd) :: (map f tl);;

let rec sufiksy xs = 
  match xs with
    [] -> []
  |_::tl -> xs::(sufiksy tl);;

sufiksy [1;2;3;4;5];;

let rec prefiksy xs =
  match xs with
    [] -> []
  |hd::tl -> [hd] :: (map (fun ys -> hd::ys) (prefiksy tl));;

prefiksy [1;2;3;4;5];;