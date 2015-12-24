
	j main
	
fib:	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	move $s0, $a0
	blt $s0 2 fibase
	subi $a0, $s0, 1
	jal fib
	addi $s1, $v0, 0
	subi $a0, $s0, 2
	jal fib
	add $v0, $s1, $v0
	j fibex
fibase: li $v0 1

fibex:	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

main:	li $v0, 5
	syscall
	move $a0, $v0
	jal fib
	move $a0, $v0
	li $v0, 1
	syscall
