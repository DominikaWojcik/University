prog: model.cmx view.cmx ai.cmx game.cmx
	ocamlfind ocamlopt -package graphics,unix -linkpkg -o prog -g model.cmx view.cmx ai.cmx game.cmx

model.cmx: model.ml
	ocamlopt -c -g model.ml

view.cmx: view.ml
	ocamlopt -c -g view.ml

ai.cmx: ai.ml
	ocamlopt -c -g ai.ml

game.cmx: game.ml
	ocamlopt -c -g game.ml

clean:
	rm *.cmi *.cmx *.o prog