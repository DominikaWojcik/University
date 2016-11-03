type 'a place =
    Place of 'a list * 'a list;;

(*Głowa drugiej listy to aktualny element*)

let findNth xs pos = 
  let rec aux revFront ys curPos =
    if curPos = pos
    then Place (revFront, ys)
    else let head = List.hd ys
      and tail = List.tl ys in
      aux (head::revFront) tail (curPos+1) in
  aux [] xs 0;; 

let collapse place = 
  let rec prependRev list1 list2 = match list1 with
      [] -> list2
    | hd::tl -> prependRev tl (hd::list2) in match place with 
    Place (revFront, endList) -> prependRev revFront endList;;

let add x place = match place with
    Place (revFront, endList) -> Place (revFront, x::endList)

let del place = match place with
    Place (revFront, endList) -> match endList with
      [] -> failwith "Nothing to delete"
    | hd::tl -> Place (revFront, tl);;

collapse (add 3 (findNth [1;2;4] 2)) = [1;2;3;4];;
collapse (del (findNth [1;2;4] 2)) = [1;2];;
collapse (del (add 3 (findNth [1;2;4] 2))) = [1;2;4];; 

let next = 
  function Place (revFront, endList) -> match endList with
      [] -> failwith "End of list"
    | hd::tl -> Place (hd::revFront, tl);;

let prev = 
  function Place (revFront, endList) -> match revFront with
      [] -> failwith "End of list"
    | hd::tl -> Place (tl, hd::endList);;

next (add 3 (findNth [1;2;4] 2));;
prev (add 3 (findNth [1;2;4] 2));;

type 'a btree = 
    Leaf 
  | Node of 'a btree * 'a * 'a btree;;
  
(*Musimy pamietać ojca, by móc się swobodnie poruszać po drzewie*)
type 'a btplace = 
  | AboveRoot
  | BTPlace of 'a btplace * 'a btree;;

