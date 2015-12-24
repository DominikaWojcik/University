main: 		la $a0, tablica
		lw $a1, rozmiar
		jal quicksorterino
		
		li $v0, 10
		syscall #koniec programu
		
quicksorterino: addi $sp, $sp, -20
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		#5 miejsc na stosie na jakies gowno
		blt $a1, 2, exit
		move $s0, $a0 
		move $s1, $a1
		move $s2, $s0
		addi $s2, $s2, 4
		move $s3, $s1
		subi $s3, $s3, 1
		sll  $s3, $s3, 2
		add $s3, $s0, $s3
		#w s2 mam poczatek, w s3 mam ostatni
		lw $t0, ($s0)
while:		beq $s2, $s3, endwhile
		lw $t2, ($s2)
		lw $t3, ($s3)
		ble $t3, $t0, else # IF  jesli wsk 2 mniejszy niz wybrany, to robimy swaperino
		subi $s3, $s3, 4 # zmniejszamy wsk 2 o 1
		j while
else:		sw $t2, ($s3) #swaperino
		sw $t3, ($s2)
		addi $s2, $s2, 4 # zwiekszamy wsk 1 o 1
		j while		
				
				
endwhile:	lw $t2, ($s2)
		blt $t2, $t0, swap #zamieniamy miejscami randoma z srodkiem
		subi $s2, $s2, 4 # jesli srodek wiekszy rowny randomowi, to zmniejszamy pierwszy wskaznik
swap:		lw $t2, ($s2) #swapujemy randoma ze srodkiem
		sw $t2, ($s0)
		sw $t0, ($s2)
		
		
		sub $t0, $s2, $s0 #zaczynamy rekujsje
		srl $t0, $t0, 2 # sprytnie nie dodajemy jedynki, obliczylismy dlugosc pierwszego przedzialu
		sub $s3, $s1, $t0 #zaczynamy liczyc dlugosc drugiego przedzialu
		subi $s3, $s3, 1 #obliczylismy dlugosc drugiego przedzialu
		move $a1, $t0
		jal quicksorterino
		addi $s2, $s2, 4
		move $a0, $s2
		move $a1, $s3
		jal quicksorterino
		
		# naprawiamy, co zepsuliœmy
exit:		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		addi $sp, $sp, 20
		jr $ra
		
.data
tablica: .word 1,4,2,8,3,6,0,8,9,3,2,5,5,7,3
rozmiar: .word 15
