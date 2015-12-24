main: 		li $v0, 6
		syscall
		mov.s $f2, $f0 # a w $f2
		li $v0, 6
		syscall
		mov.s $f1, $f0 # epsilon w $f1
		mov.s $f0, $f2 # a w $f0
		mov.s $f3, $f0 # x_0 = a
		mov.s $f2, $f28 ###ustawiam na zero, bo kto mi zabroni

		
while:		sub.s $f4, $f3, $f2 # | x_n+1 - x_n |
		abs.s $f4, $f4
		c.le.s $f4, $f1 # mniejsze od epsilona
		bc1t endwhile
		div.s $f4, $f0, $f3 ### x_x / a
		add.s $f4, $f4, $f3
		addi $t1, $0, 2
		mtc1 $t1, $f5 ###robimy dwójkê float
		cvt.s.w $f5, $f5 # konwertujemy te dwojke na IEE 754
		div.s $f4, $f4, $f5 ### policzony pierwiastek
		mov.s $f2, $f3 ## zamiana poprzednich
		mov.s $f3, $f4 ## z_n+1
		j while	  
endwhile: 	mov.s $f12, $f3 #wypisanie pierwiastka
		li $v0, 2
		syscall
		li $v0, 10 #exit
		syscall
		
