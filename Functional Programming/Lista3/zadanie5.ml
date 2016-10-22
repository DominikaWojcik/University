let splitIncreasing xs = 
  let rec aux prev ys = match ys with
    |[] -> ([],[])
    |hd::tl -> 
      if hd > prev 
      then 
        let (tail, rest) = aux hd tl 
        in (hd::tail, rest) 
      else ([],ys)
  and hd = List.hd xs
  in let (inc, rest) = aux hd (List.tl xs)
  in (hd::inc, rest);;

let next_perm xs = if xs = [] then []
  else
    let (inc, rest) = splitIncreasing xs in
    if rest = [] then xs 
    else let elem = List.hd rest in 
      let (lower, higher) = List.partition (fun x -> x < elem) inc in
      let swap = List.hd higher
      and higherRest = List.tl higher in
      List.rev (lower @ (elem :: higherRest)) @ (swap :: (List.tl rest));;

let perms xs = 
  let rec aux prev ys = 
    if prev = ys then [] else ys :: aux ys (next_perm ys) in
  aux [] xs;;

perms [4;3;2;1];;