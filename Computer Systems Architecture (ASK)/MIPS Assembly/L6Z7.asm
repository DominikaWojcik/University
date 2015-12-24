	.data
label:	.word 1,2
	.text
main:	lbu $t0, label
	lbu $t1, label+1
	lbu $t2, label+2
	lbu $t3, label+3
	lbu $t4, label+4
	
	
