let rec a n = if n = 0 then 0 else 2 * (a (n-1)) + 1;;

let b n = let rec aux acc current target =
            if current = target
            then acc
            else aux (2*acc+1) (current+1) target
  in aux 0 0 n;;

let time f x =
  let start = Sys.time ()
  in let res = f x
  in let stop = Sys.time ()
  in let () = Printf.printf "Execution time: %fs\n%!" (stop -. start)
  in
  res;;

Printf.printf "Bez rekursji ogonowej:\n";;
time a 2000000;;

Printf.printf "Z rekursja ogonowa:\n";;
time b 2000000;; (*Inty są na 64 miejscach po przecinku - wszystko dalej jest -1 z jakiegos powodu*)