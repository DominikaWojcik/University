type 'a btree = Leaf of 'a | Node of 'a btree * 'a * 'a btree;;

let countDFS root = 
  let rec aux tree num = match tree with
      Leaf _ -> (Leaf num, num+1)
    | Node (l,_,r) -> let left, numL = aux l (num+1) in 
      let right, numR = aux r numL in
      (Node (left, num, right), numR) in
  fst @@ aux root 1;;

let countBFS root = 
  let take2 xs = match xs with
      a::b::xs' -> (a,b,xs')
    | _ -> failwith "To nie powinno sie stac!" in

  let rec assembleTogether forest counted num = match forest with
      [] -> []
    | x::xs -> match x with
        Leaf _ -> Leaf num :: assembleTogether xs counted (num+1)
      | Node (l,_,r) -> 
        let left, right, rest = take2 counted in
        Node(left, num, right) :: assembleTogether xs rest (num+1) in

  let getNextLevel forest = List.concat @@ List.map 
      (function Leaf _ -> []
              | Node (l,_,r) -> [l;r]) forest in

  let rec countForest forest num = 
    if forest = [] then [] else
      let nextLevel = getNextLevel forest in
      let counted = countForest nextLevel (num + List.length forest) in
      assembleTogether forest counted num in

  List.hd @@ countForest [root] 1;;

let testTree = Node (Node (Leaf 'a', 'b', Leaf 'c'), 'd', Leaf 'e');;

countDFS testTree;;
countBFS testTree;;