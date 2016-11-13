type htree = 
  |Leaf of char * int
  |Node of htree * int * htree;;

let size tree = match tree with 
    Leaf (_,n) -> n
  | Node (_,n,_) -> n;;

let (<=) t1 t2 = size t1 <= size t2;; 

let comp t1 t2 = let diff = size t1 - size t2 in
  if diff < 0 then -1 else if diff > 0 then 1 else diff;;

let mkHTree xs = 
  let rec insert ys tree = match ys with
      [] -> [tree]
    | hd::tl -> if tree <= hd then tree::ys else hd::(insert tl tree) in
  let rec aux trees = match trees with
      [] -> failwith "This shouldn't happen"
    | [tree] -> tree
    | t1::t2::rest -> aux @@ insert rest (Node(t1, size t1 + size t2, t2)) in
  aux @@ List.sort comp @@ List.map (fun (c, n) -> Leaf (c,n)) xs;;

mkHTree [('c', 5);('a',6);('b',1);(' ', 7);('\n', 3);('d',2);];;

let stream_tee stream =
  let next self other i =
    try
      if Queue.is_empty self
      then
        let value = Stream.next stream in
        Queue.add value other;
        Some value
      else
        Some (Queue.take self)
    with Stream.Failure -> None in
  let q1 = Queue.create () in
  let q2 = Queue.create () in
  (Stream.from (next q1 q2), Stream.from (next q2 q1));;

let encode tree inStream =
  let findPath c = 
    let rec aux v stack = match v with
        Leaf (ch, _) -> if ch = c then (stack, true) else ([], false)
      | Node (l,_,r) -> let (pathL, resLeft) = aux l (0::stack) in 
        if resLeft then (pathL, true) else 
          let (pathR, resRight) = aux r (1::stack) in
          if resRight then (pathR, true) else ([], false) in
    fst @@ aux tree [] in

  let rec getBits acc = match Stream.peek inStream with
      None -> List.rev acc
    | Some _ -> let c = Stream.next inStream in 
      getBits (findPath c @ acc)

  and string_of_bits bits =
    let rec take n xs = match (n,xs) with
        0, _ -> [], xs
      |n, [] -> let tail, rest = take (n-1) [] in
        (0::tail, rest)
      |n, x::xs' -> let tail, rest = take (n-1) xs' in
        (x::tail, rest) in

    let rec split n xs acc =
      if xs = [] then List.rev acc
      else let nextByte, rest = take n xs in 
        split n rest (nextByte::acc) in 

    let bytesToString byteList = 
      let toString byte = String.make 1 @@ Char.chr @@ List.fold_left 
          (fun acc bit -> (acc lsl 1) lor bit) 0 byte in
      String.concat "" @@ List.map toString byteList in

    bytesToString (split 8 bits []) in

  Stream.of_string @@ string_of_bits (getBits []);;

let decode tree inStream = 
  let byteToBits c = let byte = Char.code c in
    let rec aux n b = if n = 0 then [] else (b land 1)::(aux (n-1) (b lsr 1)) in
    aux 8 byte in

  let rec getBits acc = match Stream.peek inStream with
      None -> List.rev acc
    | Some _ -> let c = Stream.next inStream in 
      getBits (byteToBits c @ acc) in

  let rec processBits count chars bits = 
    let rec walkTheTree node xs = match node with
        Leaf (c, _) -> (String.make 1 c,xs)
      | Node (l,_,r) -> if List.hd xs = 0 
        then walkTheTree l (List.tl xs)
        else walkTheTree r (List.tl xs) in

    if count = size tree 
    then String.concat "" @@ List.rev chars
    else let decoded, restOfBits = walkTheTree tree bits in
      processBits (count+1) (decoded::chars) restOfBits in
  Stream.of_string @@ processBits 0 [] (getBits []);;

let encodeFile pathIn pathOut = 
  let countChars someStream =
    let symbolMap = Hashtbl.create 256 in
    let rec aux iter = match Stream.peek someStream with
        None -> Hashtbl.fold (fun k v acc -> (k,v)::acc) symbolMap []
      | Some _ -> let c = Stream.next someStream in 
        let currentCount = if not @@ Hashtbl.mem symbolMap c 
          then let () = Hashtbl.add symbolMap c 0 in 0 
          else Hashtbl.find symbolMap c in
        let () = Hashtbl.replace symbolMap c (currentCount+1) in
        aux (iter+1) in
    aux 0 in 

  let stream = Stream.of_channel (open_in pathIn) in
  let streamToEnc, streamCountChars = stream_tee stream in
  let tree = mkHTree (countChars streamCountChars) in
  let streamOut = encode tree streamToEnc 
  and outChannel = open_out pathOut in
  let () = Stream.iter 
      (fun c -> Printf.fprintf outChannel "%c" c) 
      streamOut
  and () = close_out outChannel in
  tree;;

let decodeFile tree pathIn pathOut = 
  let stream = Stream.of_channel (open_in pathIn) in
  let streamOut = decode tree stream 
  and outChannel = open_out pathOut in
  let () = Stream.iter 
      (fun c -> Printf.fprintf outChannel "%c" c) 
      streamOut in
  close_out outChannel;;

let huffmanTree = encodeFile "original" "encoded";;
decodeFile huffmanTree "encoded" "decoded";; 
