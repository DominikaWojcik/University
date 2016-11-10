type 'a llist = LNil | LCons of 'a * (unit -> 'a llist);;

let rec ltake = function
  |0, _ -> []
  |_, LNil -> []
  |n, LCons (x, lxs) -> x::(ltake(n-1, lxs()));;

let rec lmap = function 
  |_, LNil -> LNil
  |f, LCons(x, xs) -> LCons(f x, function () -> lmap(f, xs()));;

(*Przybliżenie PI*)

let odd = 
  let rec aux n = LCons (n, (function () -> aux (n+2))) in
  aux 1;;

let reversed lxs = lmap((fun x -> 1. /. float x), lxs);;

let negEverySecond lxs =
  let rec aux = function
    |_, LNil -> LNil
    |_ as even, LCons(x, xs) -> 
      LCons((if even then -.x else x), function () -> aux(not even, xs())) in
  aux(false, lxs);;

let multBy(n, lxs) = lmap((fun x -> x *. n), lxs);;

let prefixSum lxs =
  let rec aux = function
    |_, LNil -> LNil
    |sum, LCons(x, xs) -> 
      LCons(x +. sum, function () -> aux(x +. sum, xs())) in
  aux(0., lxs);;

let pi = multBy(4., prefixSum @@ negEverySecond @@ reversed odd);;

ltake(20, pi);;

(*Map 3*)

let rec lmap3 = function
  |_, LNil -> failwith "Strumień nie może się skończyć!"
  |f, LCons(x, xs) -> let y::[z] = ltake(2, xs()) in
    LCons(f x y z, function () -> lmap3(f, xs()));;

ltake(5, lmap3((fun x y z -> x+y+z), odd));;

(*Transformacja Eulera*)
let euler x y z = z -. ((y -. z)**2.) /. (x -. 2.*.y +. z);;
let pi2 = lmap3(euler, pi);;

ltake(20, pi2);;

(****TERAZ Z MODULEM LAZY*********)

type 'a klist = LNil | LCons of 'a * ('a klist Lazy.t);;

let rec ltake = function
  |0, _ -> []
  |_, LNil -> []
  |n, LCons (x, lazy lxs) -> x::ltake(n-1, lxs);;

let rec lmap = function 
  |_, LNil -> LNil
  |f, LCons(x, lazy xs) -> LCons(f x, lazy(lmap(f, xs)));;

let oddLazy = 
  let rec aux n = LCons(n, lazy(aux (n+2))) in
  aux 1;;

let reversedLazy lxs = lmap((fun x -> 1. /. float x), lxs);;

let negEverySecondLazy lxs =
  let rec aux = function
    |_, LNil -> LNil
    |_ as even, LCons(x, lazy xs) -> 
      LCons((if even then -.x else x), lazy(aux(not even, xs))) in
  aux(false, lxs);;

let multByLazy(n, lxs) = lmap((fun x -> x *. n), lxs);;

let prefixSumLazy lxs =
  let rec aux = function
    |_, LNil -> LNil
    |sum, LCons(x, lazy xs) -> 
      LCons(x +. sum, lazy(aux(x +. sum, xs))) in
  aux(0., lxs);;

let piLazy = prefixSumLazy @@ multByLazy(4., negEverySecondLazy @@ reversedLazy oddLazy);;

let rec lmap3Lazy = function
  |_, LNil -> failwith "Strumień nie może się skończyć!"
  |f, LCons(x, lazy xs) -> let y::[z] = ltake(2, xs) in
    LCons(f x y z, lazy(lmap3Lazy(f, xs)));;

ltake(5, lmap3Lazy((fun x y z -> x+y+z), oddLazy));;

(*Transformacja Eulera*)
let euler x y z = z -. ((y -. z)**2.) /. (x -. 2.*.y +. z);;
let pi2Lazy = lmap3Lazy(euler, piLazy);;

ltake(20, piLazy);;
ltake(20, pi2Lazy);;