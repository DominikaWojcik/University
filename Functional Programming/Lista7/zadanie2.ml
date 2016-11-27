type 'a list_mutable = LMnil | LMcons of 'a * 'a list_mutable ref;;

let rec concat_copy xs ys = match xs with
    LMnil -> ys
  | LMcons(x, refTail) -> LMcons (x, 
                                  if !refTail = LMnil 
                                  then ref ys
                                  else ref (concat_copy !refTail ys));;

let concat_share xs ys =
  if xs = LMnil then ys 
  else
    let rec aux zs = match zs with 
        LMcons (z, refTail) -> if !refTail = LMnil 
        then refTail := ys
        else aux (!refTail)
      | LMnil -> failwith "This shouldn't happen" in 
    aux xs; xs;;

let set xs n newVal = match xs with
    LMnil -> LMnil
  | LMcons(x, tail) -> if n = 0 then LMcons(newVal, tail)
    else  
      let rec aux zs n = match zs with 
          LMcons (_, tail) -> (match !tail with 
              LMnil -> ()
            | LMcons (z, nextTail) -> if n = 0 
              then tail := LMcons(newVal, nextTail)
              else aux !tail (n-1))
        | LMnil -> failwith "This shouldn't happen"
      in aux xs n; xs;;

(*TESTY*)
let listaA = LMcons(1, ref (LMcons(2,ref LMnil)));;
let listaB = LMcons(3, ref (LMcons(4,ref LMnil)));;
let copyConcat = concat_copy listaA listaB;;
listaA;;

let listaA = LMcons(1, ref (LMcons(2,ref LMnil)));;
let listaB = LMcons(3, ref (LMcons(4,ref LMnil)));;
let copyShare = concat_share listaA listaB;;
listaA;;