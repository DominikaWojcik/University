(* 1. *)
let isSquare mat = snd @@ List.fold_left 
    (fun (column,flag) row -> (column, flag && column = (List.length row))) 
    (List.length mat, true)
    mat;;

let matrix = [[1.;2.;3.];
              [4.;5.;6.];
              [7.;8.;9.]];;

let matrix2 = [[4.;3.];
               [2.;5.];
               [1.;8.]];;

isSquare matrix;;
isSquare matrix2;;

(* 2. *)
let rec column mat n = match mat with
  |[] -> []
  |row::rest -> List.nth row (n-1) :: (column rest n);; 

column matrix 2;;
column matrix2 1;;

(* 3. *)
let trans mat = 
  let rec range a b = 
    if a = b 
    then [a] 
    else a::(range (a+1) b)
  in if mat = [] 
  then []
  else List.map (column mat)(range 1 (List.length (List.hd mat)));;

trans matrix;;
trans matrix2;;

(* 4. *)
let zip xs ys = List.combine xs ys;;
let zip_bez_oszustw xs ys = List.map2 (fun a b -> (a,b)) xs ys;;

zip [1;3;4;6] ["we";"ydf";"dasd";"xcv"];;
zip_bez_oszustw [1;3;4;6] ["we";"ydf";"dasd";"xcv"];;
zip [1.;2.;3.] ["a";"b";"c"];;
zip_bez_oszustw [1.;2.;3.] ["a";"b";"c"];;

(* 5. *)
let zipf f xs ys = List.map (fun (x,y) -> f x y) (zip xs ys);;

zipf ( +. ) [1.;2.;3.] [4.;5.;6.];;

(* 6. *)
let mult_vec vec mat = 
  let trans_mat = trans mat
  and multiply = zipf ( *. ) vec 
  in let sum xs = List.fold_left ( +. ) 0. xs 
  in List.map (fun x -> sum (multiply x)) trans_mat;;

mult_vec [1.;2.] [[2.;0.];[4.;5.]];;

(* 7. *)
let mult_mat matA matB = List.map (fun vec -> mult_vec vec matB) matA;;

matrix;;
matrix2;;
mult_mat matrix matrix2;;

let matrix3 = [[2.;4.];[3.;6.]];;
let matrix4 = [[1.;1.];[1.;1.]];;
mult_mat matrix3 matrix4;;