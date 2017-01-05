open Model;;

let fps = 30;;
let deltaTime = 1.0 /. (float_of_int fps);;
let restartTime = 0.25;;

let handleWelcomeClick state = 
  if View.button1Clicked () 
  then Model.Game (Model.changeOpponent state Model.Player)
  else if View.button2Clicked ()
  then Model.Game (Model.changeOpponent state Model.AI)
  else Model.Welcome state;;

let handleGameOverClick state = 
  if View.button1Clicked ()
  then Model.Welcome (Model.newGame Model.Player)
  else Model.GameOver state;;

let handleGameClick state =
  if Graphics.button_down () then
    let closestPoint = View.getClosestMousePoint state in
    if Model.canMoveTo state closestPoint then
      let newState = Model.makeMove state closestPoint in
      if newState.terminal = None
      then Model.Game newState
      else Model.GameOver newState
    else Model.Game state
  else Model.Game state;;


let handleInputAndLogic phase = match phase with
    Model.Welcome state -> handleWelcomeClick state
  | Model.Game state -> (if state.turn && state.config.player2 = Model.AI 
                         then Ai.play state
                         else handleGameClick state)
  | Model.GameOver state -> handleGameOverClick state;;

let playGame () =
  let exitGame = ref false in
  let phase = ref (Model.Welcome (Model.newGame Model.Player)) in
  while not !exitGame do
    Unix.sleepf deltaTime;
    View.render !phase;
    let oldPhase = !phase in
    phase := handleInputAndLogic !phase;
    if (match oldPhase with Model.GameOver _ -> true | _ -> false) 
    then if (match !phase with Model.Welcome _ -> true | _ -> false) 
      then let () = Unix.sleepf restartTime in 
        exitGame := true;
  done;;



let main () =
  Random.self_init ();
  let () = View.init_window () in
  while true do
    playGame ()
  done;
  View.close_window ();;

main ();;