main:
nop				# Test button input from wrapper file		
nop
nop
addi $t2, $zero, 1		# r10 = 1 
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
nop				# FINAL: $r12 = 1
