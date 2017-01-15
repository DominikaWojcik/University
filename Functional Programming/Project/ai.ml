open Model;;

(*
Leaf: nigdy nie przeanalizowany wezel
Node: wezel
    Ile razy zagrano w tym wezle
    Stan w wezle
    Dzieci - None jeśli takiego dziecka być nie moze,
    Tablica mówiąca ile razy każde dziecko zostało wybrane
    Tablica mówiąca jaka jest sumaryczna nagroda każdego dziecka
 *)
type mctsNode = 
    Leaf 
  | Node of int ref * Model.gameState * mctsNode option array * int array * float array;;

let getInitialMctsChildren moveArray =
  Array.map (fun available -> if available then Some Leaf else None) moveArray;;

let newTree state = 
  Node(ref 0, state, getInitialMctsChildren @@ Model.getMoves state, Array.make 8 0, Array.make 8 0.0);;

let computationalBudget = 0.095;;

let foldi f initAcc arr = 
  snd @@ Array.fold_left (function i,acc -> fun elem -> i+1, f i acc elem) (0,initAcc) arr;; 


let isFullyExpanded node = match node with
    Node (_,_,children,_,_) ->
    fst @@ Array.fold_left (fun acc child -> match child with
        | Some Leaf -> Some (snd acc), (snd acc) + 1
        | _ -> fst acc, (snd acc) + 1)
      (None, 0) 
      children
  | Leaf -> failwith "Fully expanded on leaf";;

let computeUCB played childPlayed childReward = 
  let mean = childReward /. float_of_int childPlayed in
  let expCoef = 0.5 in
  let exploration = sqrt((2. *. (log (float_of_int played))) /. float_of_int childPlayed) in
  mean +. expCoef *. exploration;;

let computeBest played childPlayed childReward =
  let mean = childReward /. float_of_int childPlayed in
  mean;;

let getBestChildByF node f = match node with
    Node(played,_,children,childPlayed,childReward) -> 
    let bestChildren = fst @@ foldi (fun i -> function best,bestVal -> fun childNode ->
        match childNode with
          Some (Node _) ->
          let curVal = f !played (Array.get childPlayed i) (Array.get childReward i) in
          if curVal > bestVal
          then [i],curVal
          else if curVal = bestVal then i::best,bestVal else best,bestVal
        | None -> best,bestVal
        | Some Leaf -> failwith "Child of fully expanded node can't be a leaf!" ) 
        ([],0.0) children in
    List.nth bestChildren (Random.int @@ List.length bestChildren)
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
  chosenMove;;

let rec simulate state policy depth = match state.terminal with
    None ->
    let nextMove = policy state in
    let nextState = Model.makeMoveById state nextMove in
    simulate nextState policy (depth+1)
  | Some who -> who;;


let rollout policy node = match node with
    Node (played, state, _, _, _) ->
    let whoWon = match state.terminal with
        None ->
        let workingCopyState = Model.copyState state in
        simulate workingCopyState policy 1 
      | Some who -> who in
    played := !played + 1;
    whoWon
  | Leaf -> failwith "You can't rollout a Leaf";;

let terminalNodeReward = float_of_int (1000 * 1000 * 1000);;

let rec treeExpansion treePolicy rolloutPolicy node = match node with
    Node(played, state, children, childPlayed, childReward) ->
    let whoWon, reward, whichChild = match state.terminal with
        None -> (match isFullyExpanded node with
            Some id -> 
            let newNode = 
              let newState = Model.makeMoveByIdCopy state id in
              let newChildren = 
                if newState.terminal = None 
                then getInitialMctsChildren @@ Model.getMoves newState
                else Array.make 8 None in
              Node(ref 0, newState, newChildren, Array.make 8 0, Array.make 8 0.0) in
            Array.set children id (Some newNode);
            rollout rolloutPolicy newNode, 1.0, id

          | None -> 
            let childId = getBestChildByF node treePolicy in
            match Array.get children childId with
              Some childNode -> 
              let who, rew = treeExpansion treePolicy rolloutPolicy childNode in
              who, rew, childId
            | None -> failwith "Best child in nonterminal fullyExpanded node cannot be None")
      | Some who -> who, terminalNodeReward, -1 in
    let () = (if whichChild != -1 
              then (Array.set childPlayed whichChild ((Array.get childPlayed whichChild) + 1);
                    if whoWon = state.turn 
                    then Array.set childReward whichChild ((Array.get childReward whichChild) +. reward)));
      played := !played + 1 in
    whoWon, if reward = terminalNodeReward then 1.0 else reward
  | Leaf -> failwith "Tree policy on Leaf!";;

let mcts state = 
  let rolloutPolicy = randomPolicy
  and treePolicy = computeUCB in
  let stateCopy = Model.copyState state in
  let root = newTree stateCopy
  and elapsedTime = ref 0.0
  and estIterTime = ref 0.0
  and iterations = ref 0 in
  let () = while !elapsedTime +. !estIterTime < computationalBudget do
      let () = iterations := !iterations + 1 in
      let start = Sys.time () in
      let _ = treeExpansion treePolicy rolloutPolicy root in
      let stop = Sys.time () in
      let elapsed = stop -. start in
      elapsedTime := !elapsedTime +. elapsed;
      estIterTime := max !estIterTime elapsed 
    done in
  (*
  Printf.printf "Iterations: %d\n%!" !iterations;
  Printf.
    (match root with 
       Node (_,_,children,childPl,childRew) -> Array.iteri (fun i -> function None -> Printf.printf "\t%d blok\n%!" i
                                                                            | Some (Node _) -> Printf.printf "\t%d %f/%d\n%!" i (Array.get childRew i) (Array.get childPl i)
                                                                            | _ -> Printf.printf "%d przypal\n%!" i) children
     | Leaf -> failwith "");
  *)
  getBestChildByF root computeBest;;


let play state = 
  let optimalMoveId = mcts state in 
  (*let optimalMoveId = longTermClosestToGoalPolicy state in*)
  let newState = Model.makeMoveById state optimalMoveId  in
  if newState.terminal = None 
  then Model.Game newState
  else Model.GameOver newState;;