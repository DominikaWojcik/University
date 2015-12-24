j main
policz:	srl $t0, $a0, 16 #przesuwamy w prawo
	sll $t0, $t0, 16 #i w lewo z powrotem, mamy a
	sll $t1, $a0, 16 #b
	add $t2, $t1, $t0 # 2^16 (a+b)
	sub $t3, $t0, $t1 #2^16 (a-b)
	srl $t3, $t3, 16 # (a-b) na 16 bitach
	or $v0, $t3, $t2 # lacze
	jr $ra
	
main: 	move $a0, $s0
	jal policz