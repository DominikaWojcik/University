let primes to_n =
  let rec sieve n =
    if n <= to_n then n::sieve(n+1) else []
  and find_primes = function
      h::t -> h:: find_primes (List.filter (fun x -> x mod h <> 0) t) 
    |[] -> []
  in find_primes(sieve 2);;

let rec concatMap f xs =
  match xs with
    [] -> []
  |hd::tl -> (f hd) @ (concatMap f tl);;

let rec range a b = 
  if a = b 
  then [a] 
  else  a::(range (a+1) b);;

let allPairs xs ys = concatMap 
    (fun x -> List.map (fun y -> (x,y)) ys) xs;;

let validPairs = List.filter (fun (a,b) -> a < b && a + b < 100) 
    (allPairs (range 2 99) (range 2 99));;

let allProducts = List.sort_uniq (fun a b -> a - b) 
    (List.map (fun (a,b) -> a*b) validPairs);;

let allSums = List.sort_uniq (fun a b -> a - b) 
    (List.map (fun (a,b) -> a+b) validPairs);;

let allPairsSummingTo n = 
  let rec aux a b = if b <= a then [] else (a,b):: (aux (a+1) (b-1)) in
  aux 2 (n-2);;

let allPairsWithProduct n = 
  let rec aux a = 
    if a*a >= n 
    then [] 
    else
    if n mod a = 0 then (a,n/a) :: aux (a+1) else aux (a+1)
  in aux 2;;

let ambiguousProducts = 
  let ourPrimes = primes 99 in
  let cubes = List.map (fun x -> x*x*x) ourPrimes in
  let pQproducts = List.map (fun (a,b) -> a*b) (allPairs ourPrimes ourPrimes) in 
  List.filter (fun x -> 
      not (List.mem x ourPrimes) && 
      not (List.mem x cubes) && 
      not (List.mem x pQproducts)) 
    allProducts;;

let availableSums = List.filter
    (fun n -> List.for_all (fun (x,y) -> List.mem (x*y) ambiguousProducts) (allPairsSummingTo n)) 
    allSums;;

let solutions = List.filter (fun (x,y) -> 
    (* Pierwsze zdanie *)
    List.mem (x*y) ambiguousProducts &&
    (* Drugie zdanie *)
    List.mem (x+y) availableSums && 
    (* Trzecie zdanie - spośród wszystkich par dających iloczyn x*y 
       tylko jedna ma sumę taką, że należy do available sums (Stąd mamy pewnosc) *)
    List.length (List.find_all 
                   (fun (a,b) -> List.mem (a+b) availableSums) 
                   (allPairsWithProduct (x*y))) = 1 &&
    (* Czwarte zdanie - P już zna parę, żeby S znał, to tylko jedna para dająca sumę x+y może mieć 
       wszystkie inne pary dające ten sam iloczyn takie, że ich suma nie należy do availableSums *)
    List.length 
      (List.filter 
         (fun (a,b) -> 
            List.length (List.filter 
                           (fun (c,d) -> 
                              List.mem (c+d) availableSums) 
                           (allPairsWithProduct (a*b))) = 1) 
         (allPairsSummingTo (x+y))) = 1) 
    validPairs;;


