let fresh =
  let cnt = ref 1 in
  let aux ?(start = None) str =
    let () = match start with
        Some n -> 
        cnt := n-1; ()
      | _ -> () in 
    let toReturn = !cnt in
    cnt := !cnt + 1; str ^ (string_of_int toReturn) in
    aux;;

let reset n = let _ = fresh ~start:(Some n) "" in ();;

fresh "x";;
fresh "x";;
fresh "x";;
reset 10;;
fresh "x";;
fresh "x";;
