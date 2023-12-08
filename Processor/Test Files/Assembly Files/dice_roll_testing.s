main:
addi $t2, $zero, 1			# r10 = 1 
addi $t3, $zero, 1000			# r11 = 1000 
addi $t7, $zero, 3000       		# r15 = 3000 (BTNL)
addi $t6, $zero, 4000       		# r14 = 4000 (BTNR)
addi $t1, $zero, 2000			# r9 = 2000 (processor_output)

dice_btn_left_press:        		# only for dice roll prompt
lw  $in, 0($t7)		        	# r24 = BTNL input  
bne $in, $t2, dice_btn_right_press	# check if left button has been pressed                                 	
addi $out, $zero, 1                  	# processor output = r25 = 1
sw $out, 0($t1)				# r9 = processor output = 1
lw $t0, 0($t1)				# r8 = r9 = 1

dice_btn_right_press:
lw $in, 0($t6)                           # r14 = BTNR input
bne $in, $t2, dice_btn_left_press        # check if right button has been pressed          
addi $out, $zero, 2			 # processor output = r25 = 2
sw $out 0($t1)				 # r9 = processor output = 2
lw $t0, 0($t1)				 # r8 = r9 = 2
j dice_btn_left_press
