main:	li $v0, 8
	la $a0, buffer
	li $a1, 32
	syscall # wczytuje do buffera
	lbu $t0, duzeA # A 65
	lbu $t1, maleA # a 97
	sub $t2, $t1, $t0 # A-a
	la $s0, buffer
	subi $s0, $s0, 1 #t aktycnie odejmujemy 1, by bylo latwiej liniê ponizej
	
petla:	addi $s0, $s0, 1
	lbu $t3, ($s0) # wyciagamy z pamieci znak
	beqz $t3, print # jak jest zerem, to konczymy
	blt $t3, $t1, duza # sprawdzamy, czy zak jest maly, czy duzy
	sub $t3, $t3, $t2 # zwiekszamy znak
	j zapisz
duza:	add $t3, $t3, $t2 # powiekszamy znak
zapisz:	sb $t3, ($s0) #zapisujemy z powrotem do pamieci
	j petla
	
print:	move $t3, $0
	subi $s0, $s0, 1
	sb $t3, ($s0) #zapisuje 0 na koncu, bo inaczej mi drukuje "*" na koncu ciagu
	la $a0, buffer
	li $v0, 4 
	syscall # wypisujemy wynik	
	
	li $v0, 10
	syscall # koniec programu
	
.data
buffer:	.space 32  # buffer ma 32 zarezerwowanych bajtow
duzeA: 	.ascii "A"
maleA: 	.ascii "a"

	
	