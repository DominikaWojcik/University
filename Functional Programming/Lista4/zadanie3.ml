type 'a mtree = MNode of 'a * 'a forest
and 'a forest = EmptyForest | Forest of 'a mtree * 'a forest;;

let mTreeA = 
  MNode(
    1,
    Forest(
      MNode(
        2, 
        Forest(
          MNode(
            4, EmptyForest),
          Forest(
            MNode(
              5, EmptyForest),
            EmptyForest))), 
      Forest(
        MNode(
          3, 
          Forest(
            MNode(
              6, EmptyForest),
            Forest(
              MNode(
                7, EmptyForest),
              EmptyForest))), 
        EmptyForest)));;

let dfs multiTree = 
  let rec dfsTree tree vis = match tree with
      MNode (value, sonsForest) -> dfsForest sonsForest (value::vis)
  and dfsForest forest vis = match forest with
      EmptyForest -> vis
    |Forest (tree, peers) -> 
      let vis2 = dfsTree tree vis in
      dfsForest peers vis2
  in List.rev @@ dfsTree multiTree [];;

let bfs multiTree = 
  let rec bfsLevel trees vis = 
    if trees = [] then vis else
      let rec newVis = (List.rev @@ List.map (function MNode (value, _) -> value) trees) @ vis
      and allTreesInForest f = match f with
          EmptyForest -> []
        |Forest(tree, rest) -> tree::allTreesInForest rest in 
      let nextLevel = List.concat @@ List.map 
          (function MNode (_, sons) -> allTreesInForest sons) trees in
      bfsLevel nextLevel newVis in
  List.rev @@ bfsLevel [multiTree] [];;

(* TESTY *)
dfs(mTreeA);;
bfs(mTreeA);;

type 'a mtree_lst = MTree of 'a * ('a mtree_lst) list;;

let mTreeB = 
  MTree(1,[
      MTree(2,[
          MTree(4,[]);
          MTree(5,[])
        ]);
      MTree(3,[
          MTree(6,[]);
          MTree(7,[])
        ])
    ]);;

let dfs2 multiTree =
  let rec dfsAux tree vis = match tree with
      MTree (value, sons) -> List.fold_left 
                               (fun acc son -> dfsAux son acc) 
                               (value::vis) 
                               sons
  in List.rev (dfsAux multiTree []);;

let bfs2 multiTree = 
  let rec bfsLevel trees vis = 
    if trees = [] then vis else
      let newVis = (List.rev @@ List.map (function MTree (value, _) -> value) trees) @ vis
      and nextLevel = List.concat @@ List.map 
          (function MTree (_, sons) -> sons) trees in
      bfsLevel nextLevel newVis in
  List.rev @@ bfsLevel [multiTree] [];;

dfs2 mTreeB;;
bfs2 mTreeB;;