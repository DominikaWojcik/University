(*Najpierw implementacja działająca ale nie zapamiętująca różnych rzeczy*)
type 'a llist = LNil | LCons of 'a * ('a llist Lazy.t);;

let rec lfilter f = function 
  |LNil -> LNil
  |LCons(hd, lazy tl) -> 
    if f hd 
    then LCons(hd, lazy(lfilter f tl))
    else lfilter f tl;; 

let rec ltake = function 
    0, _ -> []
  |_, LNil -> []
  |n, LCons(x, lazy xs) -> x::ltake(n-1, xs);;

let rec lmap f = function 
  |LNil -> LNil
  |LCons(x, lazy xs) -> LCons(f x, lazy(lmap f xs));;

let lmapiList f ys =
  let rec aux i = function
    |[] -> LNil
    |x::xs -> LCons(f i x, lazy(aux (i+1) xs)) in
  aux 0 ys;;

let rec (@$) lxs lys = match lxs with
  |LNil -> lys
  |LCons(x, lazy xs) -> LCons(x, lazy(xs @$ lys));; 

let rec lconcat = function 
  |LNil -> LNil
  |LCons(xs, lazy lxs) -> xs @$ (lconcat lxs);;

let rec toList = function
  |LNil -> []
  |LCons(x, lazy xs) -> x::(toList xs);;

type move = 
  |Fill of int
  |Drain of int
  |Transfer of int * int;;

let nsols (glasses, v) = 

  let allMoves = let fills = List.mapi (fun i glass -> Fill i) glasses
    and drains = List.mapi (fun i glass -> Drain i) glasses
    and transfers = List.concat @@ List.mapi (fun i glass1 -> List.mapi 
                                                 (fun j glass2 -> Transfer(i,j)) glasses) glasses in
    fills @ drains @ transfers in

  let allMovesFromState state = List.fold_right
      (fun move acc -> LCons(move::state, lazy acc)) allMoves LNil in

  let maxVols = Array.of_list glasses in

  let checkIfWinning state = 
    let vols = Array.make (List.length glasses) 0 in
    let () = List.fold_right (fun move () -> match move with
          Fill i ->  Array.set vols i (Array.get maxVols i)
        | Drain i -> Array.set vols i 0
        | Transfer (i,j) -> 
          let a = Array.get vols i 
          and b = Array.get vols j 
          and maxCapB = Array.get maxVols j in
          let leftInA = max 0 (a - (maxCapB - b)) in 
          let () =  Array.set vols i leftInA in
          Array.set vols j (b + (a - leftInA))
      ) state () in
    List.mem v (Array.to_list vols) in

  let rec genStates = function 
    |LNil -> failwith "This shouldn't happen"
    |LCons(state, lazy tl) -> 
      LCons(state, lazy(genStates (tl @$ (allMovesFromState state))))

  and initialState = LCons([], lazy LNil) in

  let winningStates = lmap (fun moves -> List.rev moves) @@ lfilter checkIfWinning (genStates initialState) in

  function n -> ltake(n, winningStates);;

let time f x =
  let start = Sys.time ()
  in let res = f x
  in let stop = Sys.time ()
  in let () = Printf.printf "Execution time: %fs\n%!" (stop -. start)
  in
  res;;

nsols ([1;2;4;6], 5) 10;;

let f = nsols ([1;2;4;6], 5) and n = 10 in 
let start = Sys.time () in
let res = f n in
let stop = Sys.time () in
Printf.printf "Execution time: %fs\n%!" (stop -. start);;

let f = nsols ([1;2;4;6], 5) and n = 10 in 
let start = Sys.time () in
let res = (f n, f n) in
let stop = Sys.time () in
Printf.printf "Execution time: %fs\n%!" (stop -. start);;
