ocamlc: fib.ml
	ocamlc fib.ml -o fib-ocamlc
	time ocamlrun fib-ocamlc

ocamlopt: fib.ml
	ocamlopt fib.ml -o fib-ocamlopt
	time ./fib-ocamlopt

clean:
	rm fib.cmo fib.cmi fib.cmx fib.o fib-*
