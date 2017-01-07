(* Punkt na planszy *)
type point = int * int;;
type player = Player | AI;;

(* Konfiguracja gry:
    Rozmiar X 
    Rozmiar Y 
    Szerokosc bramki *)
type gameConfig = {
  pitchX : int;
  pitchY : int;
  goalWidth : int;
  player1 : player;
  player2 : player;
}

(* Stan gry:
    Sciezka pilki od poczatku gry
    Trasa ostatniego gracza - punkty (na początku 1 punkt - srodek, potem przynajmniej 2)
    Konfiguracja gry 
    Słownik punkt - możliwe ruchy (tablica boolowska)
    Do którego gracza należy tura (1,2) *)
type gameState = {
  path : point list;
  lastMove : point list;
  config : gameConfig;
  moves : (point, bool array) Hashtbl.t;
  turn : bool;
  lastTurn : bool;
  terminal : bool option;
}

type gamePhase = Welcome of gameState | Game of gameState | GameOver of gameState;;

let (++) = function x,y -> function a,b -> x+a,y+b;;
let (--) = function x,y -> function a,b -> x-a,y-b;;

let copyState state = 
  let copiedMoves = Hashtbl.copy state.moves in
  Hashtbl.iter (fun key moves -> Hashtbl.replace copiedMoves key (Array.copy moves)) state.moves;
  (* Printf.printf "copied state in point (%d,%d)\n" (fst @@ List.hd state.path)(snd @@ List.hd state.path);
     Array.iteri (fun i av -> Printf.printf "\t%d %B\n" i av) (Hashtbl.find copiedMoves (List.hd state.path)); *)
  {
    path = state.path;
    lastMove = state.lastMove;
    config = state.config;
    turn = state.turn;
    lastTurn = state.lastTurn;
    moves = copiedMoves;
    terminal = state.terminal;
  };;

let possibleMoves = [(-1,0);(-1,1);(0,1);(1,1);(1,0);(1,-1);(0,-1);(-1,-1)];;

let findIndex xs elem = 
  let rec aux ys n = match ys with
      [] -> raise Not_found
    | y::ys' -> if y = elem then n
      else aux ys' (n+1) in
  aux xs 0;; 

let isMoveCorrect config = function (x1,y1) -> function (x2,y2) -> 
  let adjacent = (x1 != x2 || y1 != y2) && abs (x1-x2) <= 1 && abs(y1-y2) <= 1 in
  let alongBound = (x1 = x2 && abs x1 = config.pitchX / 2) || 
                   (y1 = y2 && abs y1 = config.pitchY / 2 && abs x1 >= config.goalWidth / 2 && abs x2 >= config.goalWidth / 2) ||
                   (abs x1 = abs x2 && abs x1 = config.goalWidth / 2 && abs y1 < abs y2 && abs y1 = config.pitchY/2) in
  let outOfPitch = abs x2 > config.pitchX / 2 ||
                   (abs y2 > config.pitchY / 2 && not (abs x2 <= config.goalWidth / 2 && abs x1 <= config.goalWidth / 2)) in
  adjacent && not alongBound && not outOfPitch;;

let canMoveTo state targetPoint =
  let fromPoint = List.hd state.path in
  let isCorrect = isMoveCorrect state.config fromPoint targetPoint in
  if not isCorrect then false else
    let delta = fst targetPoint - fst fromPoint, snd targetPoint - snd fromPoint in
    let notUsedBefore = Array.get (Hashtbl.find state.moves fromPoint) @@ findIndex possibleMoves delta in
    notUsedBefore;;

let getInitialMoves config = function x,y -> 
  let all = Array.make (List.length possibleMoves) true in
  let () = List.iteri (function i -> function (dX,dY) -> 
      let vX, vY = x + dX, y + dY in
      let isOk = isMoveCorrect config (x,y) (vX,vY) in 
      Array.set all i isOk) 
      possibleMoves in
  all;;

let getMoves state =
  Hashtbl.find state.moves (List.hd state.path);; 

let newGame vsPlayer = 
  let config = { pitchX = 8;
                 pitchY = 10;
                 goalWidth = 2;
                 player1 = Player;
                 player2 = vsPlayer;
               } in
  let allMoves = Hashtbl.create ((config.pitchX+1) * (config.pitchY+1)) in
  for x = 0 to config.pitchX do
    for y = 0 to config.pitchY do
      let point = x - config.pitchX / 2, y - config.pitchY / 2 in
      let moves = getInitialMoves config point in
      Hashtbl.add allMoves point moves
    done
  done;

  let nextTurn = Random.bool () in
  { path = [(0,0)];
    lastMove = [(0,0)];
    config = config;
    moves = allMoves;
    turn = nextTurn;
    lastTurn = nextTurn;
    terminal = None; };;

let getTerminality state point = 
  if snd point = state.config.pitchY / 2 + 1 then Some true
  else if snd point = -state.config.pitchY / 2 - 1 then Some false
  else 
    let edgesCount = Array.fold_left 
        (fun acc move -> if move then acc + 1 else acc) 
        0 
        (Hashtbl.find state.moves point) in
    if edgesCount = 0 then Some (not state.turn) else None;;

let canBounce state = function x,y as point ->
  let bound = abs x = state.config.pitchX/2 || 
              ((abs y = state.config.pitchY/2 && x != 0) || abs y = state.config.pitchY/2 + 1) in
  if bound then true else         
    let usedEdgesCount = Array.fold_left 
        (fun acc move -> if not move then acc + 1 else acc) 
        0 
        (Hashtbl.find state.moves point) in
    usedEdgesCount > 1 && usedEdgesCount < 8;;


let makeMove state nextPoint =
  if canMoveTo state nextPoint 
  then
    let fromPoint = List.hd state.path in

    let delta = fst nextPoint - fst fromPoint, snd nextPoint - snd fromPoint in

    let moveId = findIndex possibleMoves delta in

    let newLastMove = if state.lastTurn = state.turn 
      then nextPoint :: state.lastMove
      else [nextPoint; fromPoint] in 

    let () = Array.set (Hashtbl.find state.moves fromPoint) moveId false;
      if Hashtbl.mem state.moves nextPoint then
        let reverseDelta = fst fromPoint - fst nextPoint, snd fromPoint - snd nextPoint in
        let reverseMoveId = findIndex possibleMoves reverseDelta in
        Array.set (Hashtbl.find state.moves nextPoint) reverseMoveId false in

    let isTerminal = getTerminality state nextPoint in

    let nextTurn = if canBounce state nextPoint
      then state.turn else not state.turn in

    { path = nextPoint :: state.path;
      lastMove = newLastMove;
      config = state.config;
      turn = nextTurn;
      lastTurn = state.turn;
      moves = state.moves;
      terminal = isTerminal;
    }
  else 
    failwith "Can't make this move!";;

let makeMoveById state id = 
  let delta = List.nth possibleMoves id 
  and currentPoint = List.hd state.path in
  let nextPoint = fst currentPoint + fst delta, snd currentPoint + snd delta in
  makeMove state nextPoint;;

let makeMoveCopy state =
  makeMove (copyState state);;

let makeMoveByIdCopy state id = 
  let delta = List.nth possibleMoves id 
  and currentPoint = List.hd state.path in
  let nextPoint = fst currentPoint + fst delta, snd currentPoint + snd delta in
  makeMoveCopy state nextPoint;;

let changeOpponent state op = 
  {
    path = state.path;
    lastMove = state.lastMove;
    config = {
      pitchX = state.config.pitchX;
      pitchY = state.config.pitchY;
      goalWidth = state.config.goalWidth;
      player1 = state.config.player1;
      player2 = op;
    };
    turn = state.turn;
    lastTurn = state.lastTurn;
    moves = state.moves;
    terminal = state.terminal;
  };;

let dist p1 p2 = 
  let p = p1 -- p2 in
  let x,y = abs (fst p), abs (snd p) in
  x + y - min x y;;

let distanceToEnemyGoal state moveId =
  let curPoint = List.hd state.path
  and delta = List.nth possibleMoves moveId in
  let nextPoint = curPoint ++ delta
  and goalX, goalY = 0, 
                     if state.turn 
                     then state.config.pitchY / 2 + 1 
                     else -state.config.pitchY / 2 - 1 in
  dist nextPoint (goalX, goalY);;

let getAllReachableStates state = 
  let rec aux = function pathFromStart, st ->
    if st.turn = state.turn then
      let availableMoves = snd @@ Array.fold_left 
          (function i,acc -> fun elem -> i+1 ,if elem then i::acc else acc)
          (0,[]) 
          (getMoves st) in
      let reachableStates = List.map (fun i -> i::pathFromStart, makeMoveByIdCopy st i) availableMoves in
      let nextLevels = List.concat @@ List.map (fun p -> aux p) reachableStates in
      reachableStates @ nextLevels
    else [] in
  aux ([], state);;

let getAllReachableStates2 state =
  let st = copyState state in
  let visited = Hashtbl.create 8 in
  let currentPoint = List.hd st.path in
  let () = Hashtbl.add visited currentPoint currentPoint in

  let getNotVisitedNeighbours point = 
    let moveArray = Hashtbl.find st.moves point in
    let result = snd @@ Array.fold_left 
        (function pos,acc -> fun elem -> 
            let neighbour = point ++ (List.nth possibleMoves pos) in
            pos+1, if elem && not (Hashtbl.mem visited neighbour) 
            then
              let () = Hashtbl.add visited neighbour point in 
              (neighbour,pos)::acc 
            else acc ) 
        (0,[]) 
        moveArray in
    List.map (function neighbour, i -> 
        Array.set moveArray i false;
        (if Hashtbl.mem st.moves neighbour then
           let neighbourMoveArray = Hashtbl.find st.moves neighbour
           and reverseMoveId = findIndex possibleMoves (point -- neighbour) in
           Array.set neighbourMoveArray reverseMoveId false);
        neighbour ) result in

  let rec getNotVisited xs acc = match xs with
      point::xs' -> getNotVisited xs' ((getNotVisitedNeighbours point) @ acc)  
    | [] -> acc in

  let rec aux layer = 
    if layer = [] then [] else
      let canContinue = List.filter (fun p -> p = currentPoint || (getTerminality st p = None && canBounce st p)) layer in
      let nextLayer = getNotVisited canContinue [] in
      layer @ (aux nextLayer) in

  List.filter (fun p -> p != currentPoint) @@ aux [currentPoint], visited;;




