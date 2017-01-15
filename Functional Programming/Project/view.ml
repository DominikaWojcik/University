(*#load "graphics.cma";;
  #load "unix.cma";;*)
open Model;;

let windowTitle = "Paper soccer";;
let windowX = 830;;
let windowY = 630;;


let myGreen = Graphics.rgb 0 104 10;;
let myGrey = Graphics.rgb 220 220 220;;

let rec init_window () =
  let aux () =
    Graphics.open_graph "";
    Graphics.set_window_title windowTitle;
    Graphics.resize_window windowX windowY in
  try aux () with
    Unix.Unix_error(Unix.EINTR,_,_) -> init_window ();;

let close_window () = 
  Graphics.close_graph ();;

let clear () =
  Graphics.clear_graph ();;

let grassX = 540;;
let grassY = 630;;
let square = 45;;
let dotRadius = 1;;
let boldLineWidth = 3;;
let normalLineWidth = 1;;
let currentFieldDotRadius = 4;;
let selectedPointRadius = 4;;

let smallFont = "-adobe-times-bold-r-normal--14-100-100-100-p-76-iso8859-1";;
let normalFont = "-adobe-times-bold-r-normal--25-180-100-100-p-132-iso8859-1";;
let bigFont = "-adobe-times-bold-r-normal--34-240-100-100-p-177-iso8859-1";;

let smallFontSize = 14;;
let normalFontSize = 25;;
let bigFontSize = 34;;

let player1String = "PLAYER 1";;
let player2String = "PLAYER 2";;
let activePlayer = " <<<";;
let won = " WON!";;

let player1X = 238;;
let player1Y = 590;;
let player2X = 238;;
let player2Y = 25;;

let textCenter = grassX + (windowX - grassX) / 2;;
let alignTextCenter text = 
  textCenter - (fst (Graphics.text_size text)) / 2;;

let opponentString = "OPPONENT:";;
let playerString = "PLAYER";;
let aiString = "AI";;
let nextString = "NEXT";;

let buttonX = 140;;
let buttonY = 50;;

let button1Y = 300;;
let button2Y = 200;;
let mainTextY = 400;;

let pitchX = 8;;
let pitchY = 10;;
let bottomLeftCornerInReal = (2,2);;

let realPitchPoints = [|(2,2);
                        (2,12);
                        (5,12);
                        (5,13);
                        (7,13);
                        (7,12);
                        (10,12);
                        (10,2);
                        (7,2);
                        (7,1);
                        (5,1);
                        (5,2);
                        (2,2)|];;

let virtualPitchPoints = [|(-pitchX / 2, -pitchY / 2);
                           (-pitchX / 2, pitchY / 2);
                           (-1, pitchY / 2);
                           (-1, pitchY / 2 + 1);
                           (1, pitchY / 2 + 1);
                           (1, pitchY / 2);
                           (pitchX / 2, pitchY / 2);
                           (pitchX / 2, -pitchY / 2);
                           (1, -pitchY / 2);
                           (1, -pitchY / 2 - 1);
                           (-1, -pitchY / 2 - 1);
                           (-1, -pitchY / 2);
                           (-pitchX / 2, -pitchY / 2)|];;

let sampleLine = [|(0,0);(-1,0)|];;
let lastLine = [|(-1,0);(-2,1)|];;


let virtualToReal state = function x,y ->
  (fst bottomLeftCornerInReal + state.config.pitchX / 2 + x, 
   snd bottomLeftCornerInReal + state.config.pitchY / 2 + y);;

let realToCanvas = function x,y ->
  x * square, y * square;;

let virtualToCanvas state point = realToCanvas @@ virtualToReal state point;;

let canvasToReal = function x,y ->
  (x + square/2) / square, (y + square/2) / square;;

let realToVirtual state = function x,y ->
  x - (fst bottomLeftCornerInReal) - state.config.pitchX/2,
  y - (snd bottomLeftCornerInReal) - state.config.pitchY/2;;

let drawPitch state =
  Graphics.set_color myGreen;
  Graphics.fill_rect 0 0 grassX grassY;
  Graphics.set_color myGrey;
  for x = 1 to grassX / square - 1 do
    for y = 1 to grassY / square - 1 do
      Graphics.fill_circle (x*square) (y*square) dotRadius
    done
  done;

  Graphics.set_color Graphics.white;

  Graphics.set_line_width boldLineWidth;
  Graphics.draw_poly_line @@ Array.map (virtualToCanvas state) virtualPitchPoints;;

let getClosestMousePoint state =
  realToVirtual state @@ canvasToReal (Graphics.mouse_pos ());;

let drawGameState state = 
  Graphics.set_line_width normalLineWidth;
  Graphics.set_color Graphics.white;

  (* Całą sciezka pilki *)
  Graphics.draw_poly_line @@ Array.map (virtualToCanvas state) (Array.of_list state.path);
  (* Ostatni ruch *)
  Graphics.set_line_width boldLineWidth;
  Graphics.draw_poly_line @@ Array.map (virtualToCanvas state) (Array.of_list state.lastMove);
  (* Pozycja pilki *)
  let x,y = (virtualToCanvas state) @@ List.hd state.lastMove in
  Graphics.fill_circle x y currentFieldDotRadius;


  (* Aktywni gracze *)
  let p1String = if not state.turn then player1String ^ activePlayer else player1String
  and p2String = if state.turn then player2String ^ activePlayer else player2String in
  Graphics.set_color Graphics.white;
  Graphics.set_font smallFont;
  Graphics.moveto player1X player1Y;
  Graphics.draw_string p1String;
  Graphics.moveto player2X player2Y;
  Graphics.draw_string p2String;

  (* Wskazywane pole *)
  Graphics.set_color Graphics.red;
  Graphics.set_font smallFont;
  Graphics.moveto 0 0;
  let str = Printf.sprintf "Wskazywany punkt: (%d,%d)" (fst @@ getClosestMousePoint state) (snd @@ getClosestMousePoint state) in
  Graphics.draw_string str;;

let mouseInRectangle x y w h = 
  let mX, mY = Graphics.mouse_pos () in
  x <= mX && mX <= x + w && y <= mY && mY <= y + h;;

let buttonClicked x y w h = 
  Graphics.button_down () && mouseInRectangle x y w h;;

let button1Clicked () = buttonClicked (textCenter - buttonX/2) (button1Y + (normalFontSize - buttonY)/2) buttonX buttonY;;
let button2Clicked () = buttonClicked (textCenter - buttonX/2) (button2Y + (normalFontSize - buttonY)/2) buttonX buttonY;;;;

let drawBoxAroundText pos text = 
  let textX, textY = Graphics.text_size text in
  let centerX, centerY = fst pos + textX/2, snd pos + textY/2 in
  (if mouseInRectangle (centerX - buttonX/2) (centerY - buttonY/2) buttonX buttonY
   then Graphics.set_color myGrey
   else Graphics.set_color Graphics.black);
  Graphics.set_line_width boldLineWidth;
  Graphics.draw_rect (centerX - buttonX/2) (centerY - buttonY/2) buttonX buttonY;;

let drawWelcomeState state = 
  Graphics.set_color Graphics.white;
  Graphics.fill_rect (grassX+1) 0 (windowX-grassX) windowY;

  Graphics.set_color Graphics.black;
  Graphics.set_font bigFont;

  let opX, opY = (alignTextCenter opponentString), mainTextY in
  Graphics.moveto opX opY;
  Graphics.draw_string opponentString;

  Graphics.set_font normalFont;

  let plX, plY = (alignTextCenter playerString), button1Y in
  Graphics.moveto plX plY;
  Graphics.set_color Graphics.black;
  Graphics.draw_string playerString;
  drawBoxAroundText (plX, plY) playerString;

  let aiX, aiY = (alignTextCenter aiString), button2Y in
  Graphics.moveto aiX aiY;
  Graphics.set_color Graphics.black;
  Graphics.draw_string aiString;
  drawBoxAroundText (aiX, aiY) aiString;;

let drawMouseTarget state = 
  (* Zaznaczone pole *)
  let closestPoint = getClosestMousePoint state in
  if canMoveTo state closestPoint then
    let () = Graphics.set_line_width normalLineWidth;
      Graphics.set_color Graphics.white in
    let x,y = virtualToCanvas state closestPoint in
    Graphics.draw_circle x y selectedPointRadius
  else ();;

let drawGameOverState state = 
  let resultString = (match state.terminal with
        Some result -> (if result 
                        then player2String 
                        else player1String) ^ won
      | None -> failwith "GameOver state without a winner!") in
  Graphics.set_color Graphics.white;
  Graphics.fill_rect (grassX+1) 0 (windowX-grassX) windowY;

  Graphics.set_color Graphics.black;
  Graphics.set_font bigFont;

  let reX, reY = (alignTextCenter resultString), mainTextY in
  Graphics.moveto reX reY;
  Graphics.draw_string resultString;

  Graphics.set_font normalFont;

  let neX, neY = (alignTextCenter nextString), button1Y in
  Graphics.moveto neX neY;
  Graphics.set_color Graphics.black;
  Graphics.draw_string nextString;
  drawBoxAroundText (neX, neY) nextString;;

let render phase =
  Graphics.auto_synchronize false;
  clear();
  let () = match phase with
      Welcome state ->
      drawPitch state;
      drawGameState state;
      drawWelcomeState state;
    | Game state ->
      drawPitch state;
      drawGameState state;
      if not (state.turn && state.config.player2 = Model.AI) 
      then drawMouseTarget state;
    | GameOver state ->
      drawPitch state;
      drawGameState state;
      drawGameOverState state in
  Graphics.auto_synchronize true;
  Graphics.synchronize ();;

