let rec horner_notail p x = match p with
  |[] -> 0.
  |hd::tl -> hd +. x *. horner_notail tl x;;

horner_notail [1.;0.;-1.;2.] 3.;;

let horner2 p x = List.fold_right (fun y acc -> y +. x *. acc)  p 0.;;

horner2 [1.;0.;-1.;2.] 3.;;