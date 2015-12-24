main:		move $s0, $0 # indeks na 0
		li $v0, 5
		syscall
		move $a0, $v0
		jal wypisz
		
loop:		bge $s0, 32, exit
		move $a0, $v0
		jal pokolenie
		move $a0, $v0
		jal wypisz
		addi $s0, $s0, 1
		j loop

exit:		li $v0, 10
		syscall

pokolenie: 	addi $sp, $sp, -16
		sw $ra, ($sp)
		sw $s0, 4($sp) #pokolenie
		sw $s1, 8($sp) # nast pokolenie
		sw $s2, 12($sp) # indeks i petli while
		###############
		move $s0, $a0
		move $s1, $0 # nast pok =0
		move $s2, $0 # i = 0
while:		bge $s2, 32, endwhile
		addi $t0, $0, 1
		sllv $t0, $t0, $s2 # $t0 = 2^i
		move $t1, $0 # j=0
		sll $t2, $s0, 2
		and $t2, $t2, $t0
		beqz $t2, endif1
		addi $t1, $t1, 1
endif1:		sll $t2, $s0, 1
		and $t2, $t2, $t0
		beqz $t2, endif2
		addi $t1, $t1, 1
endif2:		srl $t2, $s0, 1
		and $t2, $t2, $t0
		beqz $t2, endif3
		addi $t1, $t1, 1
endif3:		srl $t2, $s0, 2
		and $t2, $t2, $t0
		beqz $t2, endif4
		addi $t1, $t1, 1
endif4:		and $t2, $t0, $s0 #sprawdz, czy komorka i byla martwa czy zywa
		beqz $t2, martwa
		bne $t1, 2, next_iter # jesli 2 zywych sasiadowi i komórka jest zywa, to nast komorka jest zywa
		or $s1, $s1, $t0 # ustaw na 1 w nast pokoleniu (dodaj 2^i)
		j next_iter
martwa:		blt $t1, 2, next_iter
		bgt $t1, 3, next_iter # jesli komorka byla martwa i miala 0,1,4 sasiadow, to zostaje martwa
		or $s1, $s1, $t0 #  jesli ma 2 lub 3 sasiadow to ozywa
next_iter:	addi $s2, $s2, 1 #i++
		j while
		################
endwhile:	move $v0, $s1
		lw $s2, 12($sp)
		lw $s1, 8($sp)
		lw $s0, 4($sp)
		lw $ra, ($sp)
		addi $sp, $sp, 16
		jr $ra		

wypisz:		addi $sp, $sp, -12
		sw $ra, ($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		##############
		move $s1, $a0
		move $s0, $0
wypisz_while:	bge $s0, 32, wypisz_exit
		addi $t0, $0, 1
		sllv $t0, $t0, $s0 #biorê 2^i
		and $t0, $t0, $s1 #sprawdzam, czy w pokoleniu na i-tej pozycji jest zapalony bit
		beqz $t0, wypisz0
		la $a0, X
		li $v0, 4
		syscall
		j wypisz_next
wypisz0:	la $a0, x
		li $v0, 4
		syscall 
wypisz_next:	addi $s0, $s0, 1
		j wypisz_while
wypisz_exit:	la $a0, nl
		li $v0, 4
		syscall
		move $v0, $s1
		lw $s1, 8($sp)
		lw $s0, 4($sp)
		lw $ra, ($sp)
		addi $sp, $sp, 12
		jr $ra
		
		
.data
X:	.asciiz "X"
x:	.asciiz "x" 
nl:	.asciiz "\n"