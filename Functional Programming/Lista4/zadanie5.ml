type 'a btree = 
    Leaf 
  | Node of 'a btree * 'a * 'a btree;;

let test = Node                                                                      
    (Node (Node (Node (Leaf, 4, Leaf), 3, Leaf), 2, Node (Leaf, 5, Leaf)),   
     1, Node (Node (Node (Leaf, 8, Leaf), 7, Leaf), 6, Node (Leaf, 9, Leaf)));; 
let testWithZero = Node                                                                      
    (Node (Node (Node (Leaf, 4, Leaf), 3, Leaf), 2, Node (Leaf, 5, Leaf)),   
     1, Node (Node (Node (Leaf, 8, Leaf), 0, Leaf), 6, Node (Leaf, 9, Leaf)));; 

(* Kontynuacja służy mi za stos *)
let prod tree = 
  let rec aux tre k = match tre with
      Leaf -> k 1
    | Node (left, value, right) -> aux left (fun prodLeft -> 
        aux right (fun prodRight ->
            k (prodLeft * value * prodRight))) in 
  aux tree (fun v -> v);;

let prod2 tree = 
  let rec aux tre k = match tre with
      Leaf -> k 1
    | Node (left, value, right) -> if value = 0 then failwith "zero" 
      else let result = aux left (fun prodLeft -> 
          aux right (fun prodRight ->
              k (prodLeft * value * prodRight))) in
        let kappa = print_endline "Wychodze z funkcji"
        and kappa2 = print_int value |> print_newline in
        result in
  try aux tree (fun v -> v) with
  | Failure _ -> 0;;

print_endline "Test with regular CPS function";;
prod test;;
print_endline "Test without zero";;
prod2 test;;
print_endline "Test with zero in tree";;
prod2 testWithZero;;