julia program.jl



for i in `ls *.dat`; do
	gnuplot <<- EOF
		set ylabel "e(x)"
		set xlabel "x"
		set terminal eps
		set output "${i%%.*}.eps"
		plot "$i" with lines
	EOF
done