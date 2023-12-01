main:
nop				# Test button input from wrapper file		
nop
nop
addi $t2, $zero, 1		# r10 = 1 
nop
nop
nop
addi $t5, $zero, 10		# r13 = 10
nop
nop
nop
addi $t3, $zero, 1000		# r11 = 1000 = button address
nop
nop
nop
addi $t1, $zero, 2000		# r9 = 2000 = output address
btn_test:
nop
nop
nop
lw   $t8, 0($t3)		# r24 = button input
nop
nop
nop
bne  $t8, $t2, btn_test		# continuing looping until button is pressed
nop
nop
nop
addi $t9, $zero, 1		# r25 = processor output = 1
nop
nop
nop
sw   $t9, 0($t1)		# address 2000 = processor output
nop
nop
nop
lw   $t0, 0($t1) 		# r8 = load[address 2000] = processor output
nop
nop
nop
add  $t4, $t4, $t0		# check if data is changing to 1 
nop
nop
nop
add  $t8, $zero, $zero		# r24 = 0
nop
nop
nop
add  $t9, $zero, $zero		# r25 = 0
nop
nop
nop
add  $t0, $zero, $zero		# r8 = 0
nop
nop
nop
blt  $t4, $t5, btn_test 	# continue looping until button is pressed 10 times
nop
nop
nop
addi $t6, $t0, 1		# check if loop ending condition is met
nop				# FINAL: r14 = 1
