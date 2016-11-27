type 'a lnode = {item: 'a; mutable next: 'a lnode};;

let mk_circular_list e =
  let rec x = {item=e; next=x} 
  in x;;

let insert_head e l =
  let x = {item=e; next=l.next}
  in l.next <- x; l;;

let insert_tail e l =
  let x = {item=e; next=l.next}
  in l.next <- x; x;;

let first ln = (ln.next).item;;

let last ln = ln.item;;

let elim_head l = l.next <- (l.next).next; l;;

let shift l m = 
  let x = ref l in 
  for i = 1 to m do
    x := !x.next
  done;
  !x;;


let rec range a b = 
  if a = b 
  then [a] 
  else  a::(range (a+1) b);;

let jozef n m = 
  let lista = let l = mk_circular_list 1 in
    ref (List.fold_right insert_tail (List.rev @@ range 2 n) l) in
  let perm = ref([]) in
  for i=1 to n do
    lista := shift !lista (m-1);
    perm := (first !lista)::(!perm);
    lista := elim_head !lista
  done;
  List.rev !perm;;


jozef 7 3;;

