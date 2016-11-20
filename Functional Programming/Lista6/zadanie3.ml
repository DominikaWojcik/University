type 'a btree = Leaf | Node of 'a btree * 'a * 'a btree;;

type 'a array = Arr of 'a btree * int;;

let aempty = Arr (Leaf, 0);;

let asub arr n = match arr with Arr (root, size) ->
  if n > size then failwith "Index out of bounds" 
  else let rec aux tree targetPos = match tree with
        Node(l,v,r) -> if targetPos = 1 then v
        else if targetPos mod 2 = 0 
        then aux l (targetPos / 2) 
        else aux r (targetPos / 2)
      | Leaf -> failwith "Reached leaf while traversing tree" in
    aux root n;;

let aupdate arr n newVal = match arr with Arr (root, size) ->
  if n > size then failwith "Index out of bounds" 
  else let rec aux tree targetPos = match tree with
        Node(l,v,r) -> if targetPos = 1 then Node(l,newVal,r)
        else if targetPos mod 2 = 0 
        then Node(aux l (targetPos / 2), v, r)
        else Node(l, v, aux r (targetPos / 2))
      | Leaf -> failwith "Reached leaf while traversing tree" in
    Arr (aux root n, size);;

let ahiext arr newVal = match arr with Arr (root, size) ->
  let rec aux tree targetPos = match tree with
      Node(l,v,r) -> if targetPos mod 2 = 0 
      then Node(aux l (targetPos / 2) , v, r)
      else Node(l, v, aux r (targetPos / 2) )
    | Leaf -> Node(Leaf, newVal, Leaf) in
  Arr(aux root (size+1), size+1);;

let ahirem arr = match arr with Arr (root, size) ->
  let rec aux tree targetPos = match tree with
      Node(l,v,r) -> if targetPos = 1 then Leaf
      else if targetPos mod 2 = 0 
      then Node(aux l (targetPos / 2) , v, r)
      else Node(l, v, aux r (targetPos / 2))
    | Leaf -> failwith "Reached leaf while traversing tree" in
  Arr(aux root size, size-1);;

(*TESTY*)

let myArray = aempty;;
let myArray2 = ahiext myArray 'a';;
let myArray3 = ahiext myArray2 'b';;
let myArray4 = ahiext myArray3 'c';;
let myArray5 = ahiext myArray4 'd';;
asub myArray5 1;;
asub myArray5 2;;
asub myArray5 3;;
asub myArray5 4;;

let myArray6 = aupdate myArray5 3 'e';;

asub myArray6 1;;
asub myArray6 2;;
asub myArray6 3;;
asub myArray6 4;;

let myArray7 = ahirem myArray6;;
let myArray8 = ahirem myArray7;;

