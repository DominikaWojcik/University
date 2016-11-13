type 'a lazy_list = LNil | LCons of 'a * ('a lazy_list Lazy.t);;

let rec lfilter f = function 
  |LNil -> LNil
  |LCons(hd, lazy tl) -> 
    if f hd 
    then LCons(hd, lazy(lfilter f tl))
    else lfilter f tl;; 

let rec lfrom n = LCons(n, lazy(lfrom (n+1)));;

let primes = 
  let rec sieve = function
      LNil -> failwith "Impossible! Internal error."
    | LCons(p, lazy nf) 
      -> LCons( p, lazy( sieve @@ lfilter (function n -> n mod p <> 0) nf))
  in sieve (lfrom 2)
;;

let rec ltake = function 
    0, _ -> []
  |_, LNil -> []
  |n, LCons(x, lazy xs) -> x::ltake(n-1, xs);;

let time f x =
  let start = Sys.time ()
  in let res = f x
  in let stop = Sys.time ()
  in let () = Printf.printf "Execution time: %fs\n%!" (stop -. start)
  in
  res;;

time ltake (1000, primes);;
time ltake (1000, primes);;