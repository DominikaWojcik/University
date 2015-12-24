.data
path: .ascii "tekst.txt"
buffer:	.space 1024
size: .word 1024
.text

main:		la $a0, path
		jal ile_niep
		move $a0, $v0
		li $v0, 1
		syscall
		li $v0, 10
		syscall

ile_niep: 	addi $sp, $sp, -20
		sw $ra, ($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)   # file descriptor
		###############
		li   $v0, 13      # system call for open file
		li   $a1, 0       # Open for reading
		li   $a2, 0	  # 
		syscall           # open a file (file descriptor returned in $v0)
		move $s3, $v0     # save the file descriptor 
		###############
		li $v0, 14	  # system call for reading from filr
		move $a0, $s3	  # move file descriptor
		la $a1, buffer	  # address of buffer
		lw $a2, size	  # size of buffer in bytes
		syscall
		###############
		move $s0, $0 	  # licznik linii ustawiony na 0
		move $s1, $0	  # wynik ustawiony na zero
		lw $s2, size	  # wczytaj rozmiar
		la $t0, buffer	  # zapisz adres bufora w $t0
		li $t2, 0	  # w $t2 pamietam, czy widzialem znak nie bedacy zerem lub spacja
while:		bge $s0, $s2, endwhile	  # while index < size
		add $t1, $t0, $s0 # obliczenie adresu bajtu do wczytania
		lbu $t1, ($t1) 	  # wczytanie znaku
		beq $t1, 0x0A, LF	# czy spotka³em line feed
		beq $t1, 0x30, next_iter # czy spotka³em zero
		beq $t1, 0x20, next_iter # czy spotka³em spacje
		beq $t1, 0x0D, next_iter # powrót karetki
		beq $t1, 0x00, next_iter # kod 0
		
		li $t2, 1		# spotkalem "niepusta" linie
		j next_iter
LF:		add $s1, $s1, $t2	# jesli spotkalem niepusta linie, to dodaje 1, jesli nie to nic sie nie dzieje
		li $t2, 0		# resetujê szukanie niepustej linii
		
next_iter:	addi $s0, $s0, 1       # index = index + 1
		j while
		###############
endwhile:	add $s1, $s1, $t2 # na koncu nie ma line feed, wiec musze sprawdzic manualnie, czy nie bylo pustej linii
		li $v0, 16 	  # system call for closing file
		move $a0, $s3	  # file descriptor for the file
		syscall		  # closes
		move $v0, $s1	# przesuwam do $v0 wynik
		###############
		lw $ra, ($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		addi $sp, $sp, 20
		jr $ra