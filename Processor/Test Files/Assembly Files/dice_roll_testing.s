main:
addi $t2, $zero, 1			# r10 = 1 
addi $t3, $zero, 1000			# r11 = 1000 
addi $t7, $zero, 3000       		# r15 = 3000 (BTNL)
addi $t6, $zero, 4000       		# r14 = 4000 (BTNR)
addi $t1, $zero, 2000			# r9 = 2000 (processor_output)

dice_btn_left_press:        		# only for dice roll prompt
lw  $t8, 0($t7)		        	# r24 = BTNL input  
add $s1, $t8, $zero
bne $s1, $t2, dice_btn_right_press	# check if left button has been pressed                                 	
addi $t9, $zero, 1                  	# processor output = r25 = 1
sw $t9, 0($t1)				# r9 = processor output = 1
lw $t0, 0($t1)				# r8 = r9 = 1
add $s1, $zero, $zero
add $t8, $zero, $zero
add $t9, $zero, $zero
add $t0, $zero, $zero
j dice_btn_left_press

dice_btn_right_press:
lw $t8, 0($t6)                           # r14 = BTNR input
add $s2, $t8, $zero
bne $s2, $t2, dice_btn_left_press        # check if right button has been pressed          
addi $t9, $zero, 2			 # processor output = r25 = 2
sw $t9 0($t1)				 # r9 = processor output = 2
lw $t0, 0($t1)				 # r8 = r9 = 2
add $s1, $zero, $zero
add $t8, $zero, $zero
add $t9, $zero, $zero
add $t0, $zero, $zero
j dice_btn_left_press
