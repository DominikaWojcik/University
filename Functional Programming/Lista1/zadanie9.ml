let hd s = s 0;;

let tl s = fun x -> s (x + 1);;

let add s const = fun x -> s x + const;;

let map s f = fun x -> f (s x);;

let map2 s s' f = fun x -> f (s x) (s' x) ;;

let replace s n a = fun x -> 
  if x mod n = 0
  then 
    a
  else 
    s x;;

let take s n = fun x -> s (x*n);;

let rec fold s f a n = 
  if n < 0 
  then a
  else f (fold s f a (n-1)) (s n);;

let rec tabulate s ?(a=0) b = 
  if a > b 
  then []
  else (s a) :: tabulate s ~a:(a + 1) b;;

(* TESTY *)
let rec fib_str n = 
  if n < 2 
  then 1 
  else fib_str (n-2) + fib_str (n-1);;


hd fib_str;;
tabulate fib_str 10;;
tabulate (tl fib_str) 10;;
tabulate (tl (tl fib_str)) 10;;
tabulate (add fib_str 20) 10;;
tabulate (map fib_str (fun x -> -x)) 10;;
tabulate (map2 fib_str fib_str ( * )) 10;;
tabulate (replace fib_str 3 1000) 10;;
tabulate (take fib_str 3) 10;;
tabulate (fold fib_str (+) 0) 10;;


