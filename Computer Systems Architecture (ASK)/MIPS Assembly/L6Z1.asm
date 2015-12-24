add $s0, $a0, $zero
add $s1, $a1, $zero
add $s2, $zero, $zero #suma
addi $s3, $zero, -10000 #maksimum
add $t0, $zero, $zero #przygotowanie

REPEAT : sll $t1, $t0, 2
add $t1, $t1, $s0 
lw $t2, ($t1) # wczytanie nast s³owa
add $s2, $s2, $t2 #dodanie do sumy
blt $t2, $s3, OLD_MAX
add $s3, $zero, $t2
OLD_MAX: addi $t0, $t0, 1
bne $t0, $s1, REPEAT

add $v0, $s2, $zero
add $v1, $s3, $zero


