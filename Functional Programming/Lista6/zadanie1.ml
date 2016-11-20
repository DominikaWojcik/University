type 'a btree = Leaf of 'a | Node of 'a btree * 'a btree;;

let samefringeBad a b = 
  let rec getPreorder tree acc = match tree with
      Leaf x -> x::acc
    | Node (l,r) -> let accL = getPreorder l acc in getPreorder r accL in
  getPreorder a [] = getPreorder b [];;

type 'a llist = Nil | LCons of 'a * (unit -> 'a llist);;

let samefringe treeA treeB = 
  let rec traverseTree tree k = match tree with
      Leaf x -> LCons (x, k)
    | Node (l,r) -> traverseTree l (fun () -> traverseTree r k) in

  let rec endTraverse = fun () -> Nil in

  let rec compareTrees threadA threadB = 
    match threadA (), threadB () with
      (Nil, Nil) -> true
    | (LCons _, Nil) | (Nil, LCons _) -> false
    | (LCons(x, contA), LCons(y, contB)) -> if x != y then false 
      else compareTrees contA contB in 

  compareTrees (fun () -> traverseTree treeA endTraverse) 
    (fun () -> traverseTree treeB endTraverse);;


let testTree1 = Node(
    Node(
      Node(Leaf 2, Leaf 1), 
      Node(
        Node(
          Leaf 5, 
          Leaf 3), 
        Leaf 4)),
    Node(
      Leaf 9, 
      Node(
        Leaf 8, 
        Leaf 6)));;

let testTree2 = Node(
    Node(
      Leaf 2, 
      Node(
        Node(
          Node(
            Leaf 1,
            Leaf 5), 
          Leaf 3), 
        Leaf 4)),
    Node(
      Node(
        Leaf 9, 
        Leaf 8),  
      Leaf 6));;

let testTree3 = Node(
    Node(
      Leaf 2, 
      Node(
        Node(
          Node(
            Leaf 1,
            Leaf 5), 
          Leaf 4), 
        Leaf 3)),
    Node(
      Node(
        Leaf 9, 
        Leaf 8),  
      Leaf 6));;

samefringeBad testTree1 testTree2;;
samefringe testTree1 testTree2;;

samefringeBad testTree1 testTree3;;
samefringe testTree1 testTree3;;

