main:
nop				# Test button input from wrapper file		
nop
nop
addi $t2, $zero, 1		# r10 = 1 
nop
nop
nop
addi $t5, $zero, 10
nop
nop
nop
addi $t3, $zero, 1000		# r11 = 1000 = button address
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
addi $t4, $zero, 1		# check if loop ending condition is met 
nop
nop
nop
addi $t9, $zero, 1		# r25 = 1
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
blt  $t4, $t5, btn_test 	# continue looping until button is pressed 10 times
nop
nop
nop
addi $t6, $t0, 1		# check if loop ending condition is met
nop				# FINAL: r14 = 1
