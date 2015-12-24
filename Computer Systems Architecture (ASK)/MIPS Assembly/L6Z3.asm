addi $t0, $t0, 1
addi $t1, $zero, 0
addi $s1, $zero,0
LOOP: sllv $t2, $t0, $t1 #robimy sobie 2^i
and $t2, $t2, $s0 #andujemy $s0 z 2^i
beqz $t2, REPEAT
addi $s1, $s1, 1 #wynik zwiekszamy o 1
REPEAT: addi $t1, $t1, 1 #wykladnik zwiekszamy o 1
blt $t1, 32, LOOP

