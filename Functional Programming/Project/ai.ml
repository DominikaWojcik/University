open Model;;

(*
Leaf: nigdy nie przeanalizowany wezel
Node: wezel
    Ile razy zagrano w tym wezle
    Ile razy wygrano
    Stan w wezle
    Dzieci - None jeśli takiego dziecka być nie moze, 
 *)
type mctsNode = 
    Leaf 
  | Node of int ref * int ref * Model.gameState * mctsNode option array;;

let getInitialMctsChildren moveArray =
  (* Printf.printf "get Init mcts children\n";
     Array.iteri (fun i av -> Printf.printf "\t%d %B\n" i av) moveArray; *)
  Array.map (fun available -> if available then Some Leaf else None) moveArray;;

let newTree state = 
  Node(ref 0, ref 0, state, getInitialMctsChildren @@ Model.getMoves state);;

let computationalBudget = 0.095;;



let isFullyExpanded node = match node with
    Node (_,_,_,children) ->
    fst @@ Array.fold_left (fun acc child -> match child with
        | Some Leaf -> Some (snd acc), (snd acc) + 1
        | _ -> fst acc, (snd acc) + 1)
      (None, 0) 
      children
  | Leaf -> failwith "Fully expanded on leaf";;

let computeUCB played childPlayed childWon = 
  let mean = float_of_int childWon /. float_of_int childPlayed in
  let expCoef = 1. in
  let exploration = sqrt((2. *. (log (float_of_int played))) /. float_of_int childPlayed) in
  Printf.printf "mean = %f, expCoef * exploration = %f\n%!" mean (expCoef*.exploration);
  mean +. expCoef *. exploration;;

let computeBest played childPlayed childWon =
  let mean = float_of_int childWon /. float_of_int childPlayed in
  mean;;

let getBestChildByF node f = match node with
    Node(played,_,parentSt,children) -> 
    let _,best,_ =  Array.fold_left 
        (fun acc childNode ->
           match childNode with
             Some (Node (childPlayed, childWon, childSt, _)) ->
             let pos,maxPos,maxVal = acc in 
             let realWon = if parentSt.turn = childSt.turn then !childWon else !childPlayed - !childWon in
             let curVal = f !played !childPlayed realWon in
             (* Printf.printf "getBCBF %d %d %f %f \n" pos maxPos maxVal curVal; *)
             if curVal >= maxVal 
             then pos+1,pos,curVal
             else pos+1,maxPos,maxVal
           | None -> let pos,max,maxVal = acc in (* Printf.printf "%d ruch None\n" pos ; *) pos+1,max,maxVal
           | Some Leaf -> failwith "Child of root cannot be leaf" )
        (0,0,0.)
        children in best
  | Leaf -> failwith "Leaf as root";;

let randomPolicy state =
  let availableMoves, count, _ = Array.fold_left 
      (function xs, cnt, pos -> fun available -> if available 
         then pos::xs, cnt+1, pos+1 
         else xs, cnt, pos+1) 
      ([],0,0) 
      (Model.getMoves state) in 
  List.nth availableMoves (Random.int count);; 

let closestToGoalPolicy state =
  let availableMoves = fst @@ Array.fold_left
      (function xs, pos -> fun available -> 
          (if available then pos::xs else xs), pos+1) 
      ([],0) 
      (Model.getMoves state) in 
  let moveAndDist = List.map (fun id -> id, (Model.distanceToEnemyGoal state id)) availableMoves in
  fst @@ List.hd @@ List.sort (function _,y1 -> function _,y2 -> if y1 < y2 then -1 else if y1 == y2 then 0 else 1)
    moveAndDist;;

let longTermClosestToGoalPolicy state =
  let rec getMoveTo visited start target  = 
    let prev = Hashtbl.find visited target in
    if prev = start then Model.findIndex Model.possibleMoves (target -- start)
    else getMoveTo visited start prev in
  (*  
    let moveStates = List.map 
      (function path, st -> List.hd @@ List.rev path, st)
      (Model.getAllReachableStates state) in
    Printf.printf "Movestates length in state (%d,%d) = %d\n" (fst @@ List.hd state.path) (snd @@ List.hd state.path) (List.length moveStates);
    let enemyGoal = 
    if state.turn 
    then (0, state.config.pitchY/2 + 1)
    else (0, -state.config.pitchY/2 - 1) in
    let sorted = List.sort (function _, st1 -> function _, st2 -> 
      let dist1 = Model.dist (List.hd st1.path) enemyGoal and
      dist2 = Model.dist (List.hd st2.path) enemyGoal in
      if dist1 < dist2 then -1 else if dist1 = dist2 then 0 else 1)
      moveStates in
    fst @@ List.hd sorted;;*)
  let reachable, visited = Model.getAllReachableStates2 state in
  let enemyGoal = 
    if state.turn 
    then (0, state.config.pitchY/2 + 1)
    else (0, -state.config.pitchY/2 - 1) in
  let sorted = List.sort (function p1 -> function p2 -> 
      let dist1 = Model.dist p1 enemyGoal and
      dist2 = Model.dist p2 enemyGoal in
      compare dist1 dist2)
      reachable in
  let bestDist = dist (List.hd sorted) enemyGoal in
  let closest = List.fold_left (fun acc p -> if bestDist = dist p enemyGoal then acc+1 else acc) 0 sorted in
  let chosenMove = getMoveTo visited (List.hd state.path) (List.nth sorted (Random.int closest)) in
  (*Printf.printf "\tOpt move - %d\n" chosenMove;*)
  chosenMove;;

let rec simulate state policy = match state.terminal with
    None ->
    let nextMove = policy state in
    let nextState = Model.makeMoveById state nextMove in
    simulate nextState policy
  | Some who -> who;;


let rollout policy node = match node with
    Node (played, won, state, _) ->
    (*Printf.printf "Rollout w (%d,%d) - turn %B " (fst @@ List.hd state.path)(snd @@ List.hd state.path) state.turn;*) 
    let whoWon = match state.terminal with
        None ->
        let workingCopyState = Model.copyState state in
        simulate workingCopyState policy 
      | Some who -> who in
    if whoWon = state.turn then won := !won + 1 else ();
    played := !played + 1;
    (*Printf.printf "won: %d\n" (if whoWon then 2 else 1);*)
    whoWon

  | Leaf -> failwith "You can't rollout a Leaf";;


let rec treeExpansion treePolicy rolloutPolicy node = match node with
    Node(played, won, state, children) ->
    (*Printf.printf "Tree exp Point %d %d\n" (fst @@ List.hd state.path)(snd @@ List.hd state.path);*) 
    let whoWon = match state.terminal with
        None -> (match isFullyExpanded node with
            Some id -> 
            let newNode = 
              let newState = Model.makeMoveByIdCopy state id in
              let newChildren = 
                if newState.terminal = None 
                then getInitialMctsChildren @@ Model.getMoves newState
                else Array.make 8 None in
              Node(ref 0, ref 0, newState, newChildren) in
            Array.set children id (Some newNode);
            rollout rolloutPolicy newNode

          | None -> 
            (*Printf.printf "Point %d %d - best child is %d\n" (fst @@ List.hd state.path)(snd @@ List.hd state.path) (getBestChildByF node treePolicy);*) 
            match Array.get children (getBestChildByF node treePolicy) with
              Some childNode -> treeExpansion treePolicy rolloutPolicy childNode
            | None -> failwith "Best child in nonterminal fullyExpanded node cannot be None")
      | Some who -> who in
    let () = if whoWon = state.turn then won := !won + 1 else ();
      played := !played + 1 in
    whoWon

  | Leaf -> failwith "Tree policy on Leaf!";;

let mcts state = 
  let stateCopy = Model.copyState state in
  let root = newTree stateCopy
  and elapsedTime = ref 0.0
  and estIterTime = ref 0.0
  and iterations = ref 0 in
  let () = while !elapsedTime +. !estIterTime < computationalBudget do
      let () = iterations := !iterations + 1 in
      let start = Sys.time () in
      (* let () = Printf.printf "Kolejna iteracja\n" in *)
      let _ = treeExpansion computeUCB longTermClosestToGoalPolicy root in
      let stop = Sys.time () in
      let elapsed = stop -. start in
      elapsedTime := !elapsedTime +. elapsed;
      estIterTime := max !estIterTime elapsed 
    done in
  Printf.printf "Iterations: %d\n%!" !iterations;
  Printf.
    (match root with 
       Node (_,_,_,children) -> Array.iteri (fun i -> function None -> Printf.printf "\t%d blok\n%!" i
                                                             | Some (Node(pl,wo,_,_)) -> Printf.printf "\t%d %d/%d\n%!" i !wo !pl
                                                             | _ -> Printf.printf "%d przypal\n%!" i) children
     | Leaf -> failwith "");
  (*failwith "Koniec";*)
  getBestChildByF root computeBest;;


let play state = 
  let optimalMoveId = mcts state in
  (*let optimalMoveId = longTermClosestToGoalPolicy state in*)
  (* Printf.printf "optimal moveid %d\n" optimalMoveId;*)
  let newState = Model.makeMoveById state optimalMoveId  in
  if newState.terminal = None 
  then Model.Game newState
  else Model.GameOver newState;;