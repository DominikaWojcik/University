let isPalindrome xs =
  let rec aux ys = match ys with
    |[] -> (xs, true)
    |[x] -> (List.tl xs, x = List.hd xs) 
    |hd1::hd2::tl -> let o1::o2::orig, flag = aux tl in
      (orig, flag && hd2 = o1 && hd1 = o2)
  in snd (aux xs);;

let isPalindromeMiddle xs = 
  let rec aux ys zs = match (ys, zs) with
      _, [] -> (true, ys)
    | y::ys', [x] -> (true, ys')
    | y::ys', z1::z2::zs' -> let flag, o::ol = aux ys' zs' in
      (flag && o = y, ol) in
  fst (aux xs xs);;

isPalindrome [];;
isPalindrome [1];;
isPalindrome [1;2];;
isPalindrome [1;1];;
isPalindrome [1;2;2];;
isPalindrome [1;2;1];;
isPalindrome [1;1;1;1];;
isPalindrome [1;1;3;1];;

isPalindromeMiddle [];;
isPalindromeMiddle [1];;
isPalindromeMiddle [1;2];;
isPalindromeMiddle [1;1];;
isPalindromeMiddle [1;2;2];;
isPalindromeMiddle [1;2;1];;
isPalindromeMiddle [1;1;1;1];;
isPalindromeMiddle [1;1;3;1];;