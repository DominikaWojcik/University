main:		li $v0, 5
		syscall # wczytujê ziarno generatora
		move $a0, $v0
		li $v0, 40
		syscall # ustawiam losowe ziarno generatora
		li $s7, 0 #ustawiam bool done = false
while:		beq $s7, 1, exit # while done == false
		jal rand_pnt
		move $s0, $v0 # $s0 - wsp x lewego górnego rogu
		move $s1, $v1 # $s1 - wsp y lewego górnego rogu
		move $a0, $s0
		jal get_side
		move $s2, $v0 # $s2 - liczba wierszy
		move $a0, $s1
		jal get_side
		move $s3, $v0 # $s3 - liczba kolumn
		##### Mam juz ustalony prostok¹t #####
		##### Teraz trzeba go narysowaæ     #####
		move $s4, $0 # indeks wiersza
		move $s5, $0 # indeks kolumny
		jal rand_RGB
		move $s7, $v0 # wybrany kolor dla tego prostokata

		
for1:		bge $s5, $s3, endfor1
		add $a0, $s1, $s5 #do nr kol pocz doda³em nr akt kol
		move $a1, $s0 # przesun¹³em do a1 numer wierza pocz
		move $a2, $s2 # przesunalem do a2 liczbe wierszy do pomalowania
		move $a3, $s7 # przesunalem do a3 kolor
		jal rysuj_kol
							
		addi $s5, $s5, 1 # i++
		j for1
endfor1:	
		li $v0, 32
		li $a0, 1000
		syscall # sleep 1 second
		j while
exit:		li $v0, 10
		syscall # exit

get_side:	move $t0, $a0
		li $v0, 42
		li $a0, 0
		sub $t0, $0, $t0 # - bok
		addi $a1, $t0, 511 # wyliczona maks dl boku
		syscall
		move $v0, $a0
		jr $ra

rand_pnt:	addi $sp, $sp, -8
		sw $ra, ($sp)
		sw $s0, 4($sp)
		##############
		li $v0, 42
		li $a0, 0
		li $a1, 511
		syscall #generujê x
		move $s0, $a0
		li $v0, 42
		li $a0, 0
		li $a1, 511
		syscall #generujê y
		##############
		move $v1, $a0
		move $v0, $s0
		lw $ra, ($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		

rand_RGB:	addi $sp, $sp, -8
		sw $ra, ($sp)
		sw $s0, 4($sp)
		##############
		li $v0, 42
		li $a0, 0
		li $a1, 0xFF
		syscall
		move $s0, $a0 # B ustawione
		li $v0, 42
		li $a0, 0
		li $a1, 0xFF
		syscall
		move $t0, $a0
		sll $t0, $t0, 8
		or $s0, $s0, $t0 # G ustawione
		li $v0, 42
		li $a0, 0
		li $a1, 0xFF
		syscall
		move $t0, $a0
		sll $t0, $t0, 16
		or $s0, $s0, $t0 # R ustawione
		##############
		move $v0, $s0
		lw $ra, ($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		
rysuj_kol:	addi $sp, $sp, -24
		sw $ra, ($sp)
		sw $s0, 4($sp) # nr kolumny
		sw $s1, 8($sp) # nr wiersza poczatkowego, poŸniej adres komorki pamieci do pomalowania
		sw $s2, 12($sp) # ile wierszy trzeba pomalowac
		sw $s3, 16($sp) # kolor
		sw $s4, 20($sp) # s4 - licznik wierszy
		############
		move $s0, $a0 # przesun nr kol
		move $s1, $a1 # biorê nr wiersza poczatkowego
		move $s2, $a2 # biore liczbe wierszy do pomalowania 
		move $s3, $a3 # ustaw kolor
		move $s4, $0 # ustaw licznik wierszy na zero
		
		mul $s1, $s1, 512 # numer wiersza pocz * 512
		add $s1, $s1, $s0 # dok³adna pozycja pierwszego piksela
		sll $s1, $s1, 2 # * 4 bajty
		addi $s1, $s1, 0x10000000 #doda³em adres pocz¹tku pamiêci
		
ptla:		bge $s4, $s2, koniec
		sw $s3, ($s1)
		addi $s1, $s1, 2048 #dodajê 512 * 4 bajty
		addi $s4, $s4, 1
		j ptla
		
koniec:		lw $ra, ($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		addi $sp, $sp, 24
		jr $ra
		
.data
nl: .asciiz "\n"
