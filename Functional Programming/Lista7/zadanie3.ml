type ('k, 'v) funArr = 
    Leaf 
  | Node of ('k, 'v) funArr * 'k * 'v * ('k, 'v) funArr;;

let empty = Leaf;;

let rec insert arr k v = match arr with
    Leaf -> Node(Leaf, k, v, Leaf)
  | Node (l,key,value,r)  -> if k = key then Node(l,k,v,r)
    else if k < key 
    then Node(insert l k v, key, value, r)
    else Node(l, key, value, insert r k v);;

let rec find arr k = match arr with
    Node (l,key,value,r) -> if k = key then Some value
    else if k < key 
    then find l k
    else find r k
  | Leaf -> None;;

(* O(2^n) *)
let rec fib n = if n = 0 then 0 else if n = 1 then 1 
  else fib (n-1) + fib(n-2);;

(* O(n^2) *)
let fib_memo = 
  let table = ref (insert (insert empty 0 0) 1 1) in

  let memo k v = table := insert !table k v in 

  let rec aux n = match find !table n with
      Some x -> x
    | None -> let x = match find !table (n-1) with
          Some m -> m
        | None -> aux (n-1)
      in match find !table (n-2) with
        Some y -> memo n (x+y); x + y
      | None -> failwith "Skoro znamy fib n-1 to znamy tez fib n-2" in
  aux;;

(* O(n) *)
let fib_memo2 = 
  let table = ref(Array.make 2 None) in
  let () = Array.set !table 0 (Some 0);
    Array.set !table 1 (Some 1) in

  let double () = 
    table := Array.append !table (Array.make (Array.length !table) None) in

  let memo k v = let tableSize = Array.length !table in 
    let () = if k >= tableSize then double () in
    Array.set !table k (Some v) in

  let find n = if Array.length !table <= n 
    then None 
    else Array.get !table n in

  let rec aux n = match find n with
      Some x -> x
    | None -> let x = match find (n-1) with
          Some m -> m
        | None -> aux (n-1)
      in match find (n-2) with
        Some y -> memo n (x+y); x + y
      | None -> failwith "Skoro znamy fib n-1 to znamy tez fib n-2" in
  aux;;

let time f x =
  let start = Sys.time ()
  in let res = f x
  in let stop = Sys.time ()
  in let () = Printf.printf "Execution time: %fs\n%!" (stop -. start)
  in
  res;;

time fib 30;;
time fib_memo 30;;
time fib_memo2 30;;

time fib_memo 5000;;
time fib_memo2 5000;;