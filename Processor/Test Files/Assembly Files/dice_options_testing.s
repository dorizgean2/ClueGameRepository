main:
addi $t2, $zero, 1		# r10 = 1 
addi $t3, $zero, 1000		# r11 = 1000 
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
addi $t1, $zero, 2000		# r9 = 2000 (processor_output)
dice_btn_left_press:        # only for dice roll prompt
lw  $in, 0($t7)		        # r24 = button input
bne $in, $t2, dice_btn_right_press		# check if right button has been pressed                                              
addi $out, $zero, 1                  # processor output = 1
sw $out, 0($t1)
lw $t0, 0($t1)

dice_btn_right_press:
lw $in, 0($t6)
bne $in, $t2, dice_btn_left_press         # check if left button has been pressed
accusations: 
bne $out, $zero, end_test    

check_directions_button:
lw  $in, 0($t5)           # check if up button has been pressed
bne $in, $t2, btn_down_press
addi $out, $zero, 1          # up button has been pressed -> processor_output = 1
sw $out, 0($t1)              
lw $t0, 0($t1)
j accusations

btn_down_press:
lw $in, 0($t4)          # check if down button has been pressed
bne $out, $t2, btn_left_press
addi $out, $zero, 2      # down button has been pressed -> processor_output = 2
sw $out, 0($t1)
lw $t0, 0($t1)
j accusations

btn_left_press:
lw $in, 0($t7)
bne $in, $t2, btn_right_press
addi $out, $zero, 3      # left button has been pressed -> processor_output = 3
sw $out, 0($t1)
lw $t0, 0($t1)
j accusations

btn_right_press:
lw $in, 0($t6)
bne $in, $t2, check_directions_button        # goes back to checking buttons
addi $out, $zero, 4      # right button has been pressed -> processor_output = 4
sw $out, 0($t1)
lw $t0, 0($t1)
j accusations 


end_test:
