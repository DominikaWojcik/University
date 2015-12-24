.macro signext (%rd, %rs )
	xori %rd, %rs, 128
	subi %rd, %rd, 128
.end_macro
.macro extract (%rd, %rs, %p, %s)
	add %rd, $0, %p
	subi %rd, %rd, 1
	srlv %rd, %rs, %rd ### przesunalem o p-1 w prawo
	addi $at, $0, 32
	sub $at, $at, %s
	sllv %rd, %rd, $at ### przesuniête o 32-s w lewo
	srlv %rd %rd, $at ### przesuniête z powrotem 32-s w prawo
	sllv %rd, %rd, %p ## przesuniête p w lewo na wlasciwe miejsce
.end_macro
.macro insert (%rd, %rs, %p, %s)
	subi %s, %s, 32
	subi, %s, $0, %s ## 32 - s
	li $at, -1
	srlv $at, $at, %s ## jedynki na ost s miejscach
	sllv $at, $at, %p ## rownolegle z luka
	nor $at, $at, $at
	and %rd, %rd, $at ### czyszczê lukê
	sllv $at, %rs, %s ### zostawiam z lewej strony s bitow do wstawienia
	srlv $at, $at, %s ### zostalo s bitow do wstawienia z prawej strony
	sllv $at, $at, %p ### przesuwam w miejsce luki
	or %rd, $at, %rd  ### wstawiam do luki
	nor %s, %s, %s    ### s - 32
	addi %s, %s, 32   ### naprawiam %s 
.end_macro
.text

	li $t0, 255
	signext($t0, $t0)
	
	li $t1, -1
	li $t3, 5
	li $t4, 3
	extract ($t2, $t1,$t3,$t4)
	
	
	