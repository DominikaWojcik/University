type expr =
    Var of string
  | Not of expr
  | Or of expr * expr
  | And of expr * expr;;

let getVars expr = 
  let rec aux expr res = match expr with
      Var x -> x::res
    | Not expr' -> aux expr' res
    | Or (left, right) -> let afterLeft = aux left res in
      aux right afterLeft
    | And (left, right) -> let afterLeft = aux left res in
      aux right afterLeft in
  List.sort_uniq compare @@ aux expr [];;

let rec eval expr context = match expr with
    Var x -> List.assoc x context
  | Not expr' -> not (eval expr' context)
  | Or (left, right) -> eval left context || eval right context
  | And (left, right) -> eval left context && eval right context;;

let e = 
  And(
    Or(
      Not(Var "x"),
      Var "y"
    ),
    Not(And(
        Or(
          Var "z",
          Not(Var "x")
        ),
        Var "y"
      ))
  );;

getVars e;;

let tautologia expr = 
  let vars = getVars expr in
  let liczWartosc = int_of_float @@ 2. ** (float_of_int @@ List.length vars) in
  let rec aux mask =
    if mask == liczWartosc then (true, []) else
      let context = List.mapi (fun i x -> (x, 1 == mask land (1 lsl i))) vars in
      let result = eval expr context in
      if not result then (false, context) else aux (mask+1) in
  aux 0;;

tautologia e;;
let e2 = Or(Var "p", Not(Var "p"));;
tautologia e2;;

let rec nNF expr = match expr with
    Var x -> expr
  | And (left, right) -> And (nNF left, nNF right)
  | Or (left, right) -> Or (nNF left, nNF right)
  | Not expr' -> match expr' with
      Var x -> expr
    | Not expr'' -> nNF expr''
    | And (left, right) -> Or(nNF (Not left), nNF (Not right))
    | Or (left, right) -> And(nNF (Not left), nNF (Not right));;

nNF e;;
nNF e2;;

(*Bierzemy negacyjna, zamieniamy w cnfy a potem łączymy*)
let cNF expr = 
  let rec neg = nNF expr
  and allOrGroups expr' groups = match expr' with
      And (left, right) -> 
      let newGroups = allOrGroups left groups in
      allOrGroups right newGroups
    | _ -> expr'::groups in 
  let rec orCNFs a b = 
    let groupsA = allOrGroups a []
    and groupsB = allOrGroups b [] in
    let newGroups = List.flatten @@ List.map 
        (fun x -> List.map (fun y -> Or (x,y)) groupsB) groupsA in
    List.fold_left (fun acc group -> And(acc, group)) 
      (List.hd newGroups) (List.tl newGroups) in
  let rec aux expr' = match expr' with
      Var x -> expr'
    | Not e -> expr'
    | And (left, right) -> And (aux left, aux right)
    | Or (left, right) -> 
      let cnfl = aux left 
      and cnfr = aux right in
      orCNFs cnfl cnfr in
  aux neg;;

cNF e;;
cNF e2;;

(*Każda z serii alternatyw musi byc zawsze prawdziwa - 
  musi występować x i nie x*)
let tautologiaCNF expr = 
  let cnf = cNF expr in
  let rec hasXAndNotX expr' vars negs = match expr' with
      Var x -> (List.mem x negs, x::vars, negs) 
    | Not (Var x) -> (List.mem x vars, vars, x::negs)
    | Or (left, right) -> 
      let resL, newVars, newNegs = hasXAndNotX left vars negs in
      let resR, allVars, allNegs = hasXAndNotX right newVars newNegs in
      (resL || resR, allVars, allNegs)
    (* TO SIE NIGDY NIE STANIE BO MAMY CNF*)
    | _ -> (false, vars, negs) in
  let rec aux expr' = match expr' with
      Not _ -> false
    | Var _ -> false
    | Or _ -> let result, _, _ = hasXAndNotX expr' [] [] in result
    | And (left, right) -> aux left && aux right in
  aux cnf;;

tautologiaCNF e;;
tautologiaCNF e2;;

let dNF expr = 
  let rec neg = nNF expr
  and allAndGroups expr' groups = match expr' with
      Or (left, right) -> 
      let newGroups = allAndGroups left groups in
      allAndGroups right newGroups
    | _ -> expr'::groups in 
  let rec andDNFs a b = 
    let groupsA = allAndGroups a []
    and groupsB = allAndGroups b [] in
    let newGroups = List.flatten @@ List.map 
        (fun x -> List.map (fun y -> And (x,y)) groupsB) groupsA in
    List.fold_left (fun acc group -> Or(acc, group)) 
      (List.hd newGroups) (List.tl newGroups) in
  let rec aux expr' = match expr' with
      Var x -> expr'
    | Not e -> expr'
    | Or (left, right) -> Or (aux left, aux right)
    | And (left, right) -> 
      let dnfl = aux left 
      and dnfr = aux right in
      andDNFs dnfl dnfr in
  aux neg;;

dNF e;;
dNF e2;;

(*Każda z serii koniunkcji musi byc zawsze fałszywa - 
  musi występować x i nie x*)
let sprzecznoscDNF expr = 
  let dnf = dNF expr in
  let rec hasXAndNotX expr' vars negs = match expr' with
      Var x -> (List.mem x negs, x::vars, negs) 
    | Not (Var x) -> (List.mem x vars, vars, x::negs)
    | And (left, right) -> 
      let resL, newVars, newNegs = hasXAndNotX left vars negs in
      let resR, allVars, allNegs = hasXAndNotX right newVars newNegs in
      (resL || resR, allVars, allNegs)
    | _ -> (false, vars, negs) in
  let rec aux expr' = match expr' with
      Not _ -> false
    | Var _ -> false
    | And _ -> let result, _, _ = hasXAndNotX expr' [] [] in result
    | Or (left, right) -> aux left && aux right in
  aux dnf;;

sprzecznoscDNF e;;
sprzecznoscDNF e2;;
let e3 = And(Var "p", Not (Var "p"));;
sprzecznoscDNF e3;;