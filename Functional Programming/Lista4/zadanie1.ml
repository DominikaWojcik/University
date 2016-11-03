let isPalindrome xs =
  let rec aux ys = match ys with
    |[] -> (xs, true)
    |[x] -> (List.tl xs, x = List.hd xs) 
    |hd1::hd2::tl -> let o1::o2::orig, flag = aux tl in
      (orig, flag && hd2 = o1 && hd1 = o2)
  in snd (aux xs);;

isPalindrome [];;
isPalindrome [1];;
isPalindrome [1;2];;
isPalindrome [1;1];;
isPalindrome [1;2;2];;
isPalindrome [1;2;1];;
isPalindrome [1;1;1;1];;
isPalindrome [1;1;3;1];;