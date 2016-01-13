gnuplot <<- EOF
	set ylabel "f(x)"
	set xlabel "x"
	set terminal eps


	set output "1.eps"
	set xrange [-1:1]
	set yrange [0:4]
	plot 1/(x*x*x*x + x*x + 0.9)

	set output "2.eps"
	set xrange [0:1]
	set yrange [0:4]
	plot 1/(1 + x*x*x*x)

	set output "3.eps"
	set xrange [0:1]
	set yrange [0:4]
	plot 2/(2 + sin(10*x*pi))


	set output "5.eps"
	set xrange [-0.9999:0.9999]
	set yrange [0:80]
	plot 1/sqrt(1 - x*x)
EOF
