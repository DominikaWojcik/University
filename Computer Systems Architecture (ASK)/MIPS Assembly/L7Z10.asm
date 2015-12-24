	la $t1, tab
	la $t2, tab2
	lw $t3, rozmiar
while:	beqz $t3, exit_zero
	lw $t4, ($t1)
	lw $t5, ($t2)
	bne $t4, $t5, exit
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	subi $t3, $t3, 1
	j while
exit_zero: li $t1, 0
exit:	li $v0, 10
	syscall
	
.data
tab: .word 1,2,3,4,5,6
tab2: .word 1,2,3,5,5,6
rozmiar: .word 6