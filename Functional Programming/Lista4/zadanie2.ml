type 'a btree = 
    Leaf 
  | Node of 'a btree * 'a * 'a btree;;

let isBalanced tree =
  let rec aux tree = match tree with
    |Leaf -> (true, 0)
    |Node (l, _, r) -> 
      let lFlag, lSum = aux l
      and rFlag, rSum = aux r in 
      (lFlag && rFlag && abs (lSum - rSum) <= 1, lSum + 1 + rSum) in
  fst (aux tree);;

(* KOMPILATOR NARZEKA ALE PATTERN ZAWSZE SIE Z MATCHUJE *)
let preorderFromList xs = 
  let rec buildPre xs len = match (xs, len) with
    |_, 0 -> (Leaf, xs)
    |hd::tl, _ ->
      let left, sndHalf = buildPre tl (((len - 1) + 1) / 2) in
      let right, rest = buildPre sndHalf ((len - 1) / 2) in
      (Node (left, hd, right), rest)
  in fst (buildPre xs (List.length xs));;

let tree = preorderFromList [1;2;3;4;5;6;7;8;9];;
isBalanced tree;;  


