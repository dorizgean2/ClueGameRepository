main:
addi $t2, $zero, 1		# r10 = 1 
addi $t3, $zero, 1000		# r11 = 1000 
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
addi $t1, $zero, 2000		# r9 = 2000 (processor_input)
dice_roll_prompt:
addi $t9, $zero, 201

dice_btn_left_press:        # only for dice roll prompt
sw $t9, 0($t1)
lw  $t8, 0($t7)		        # r24 = button output
add $s1, $t8, $zero
bne $s1, $t2, dice_btn_right_press		# check if right button has been pressed 
nop
nop
nop                                             
rng $t9, $zero, $zero                  # processor in = random generator
nop
nop
nop
sw $t9, 0($t1)
j dice_roll_prompt

dice_btn_right_press:
lw $t8, 0($t6)
add $s2, $t8, $zero
bne $s2, $t2, dice_btn_left_press         # check if left button has been pressed
addi $t9, $zero, 200                      # accusation prompts up
sw $t9, 0($t1)

check_directions_button:
lw  $t8, 0($t5)           # check if up button has been pressed
add $s3, $t8, $zero
bne $s3, $t2, btn_down_press
addi $t9, $zero, 2          # up button has been pressed -> processor_output = 1
sw $t9, 0($t1)              
lw $t0, 0($t1)
j accusations

btn_down_press:
lw $t8, 0($t4)          # check if down button has been pressed
add $s4, $t8, $zero 
bne $s4, $t2, btn_left_press
addi $t9, $zero, 3      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
lw $t0, 0($t1)
j accusations

btn_left_press:
lw $t8, 0($t7)
add $s5, $t8, $zero
bne $s5, $t2, btn_right_press
addi $t9, $zero, 4      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
lw $t0, 0($t1)
j accusations

btn_right_press:
lw $t8, 0($t6)
add $s6, $t8, $zero
bne $s6, $t2, check_directions_button        # goes back to checkt8g buttons
addi $t9, $zero, 5      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
lw $t0, 0($t1)
j accusations 

accusations:                            
bne $t9, $zero, end_test    

end_test:
nop



# addi $sp, $zero, 500
# addi $sp, $sp, -8
# sw $t2, 0($sp)
# sw $t3, 1($sp)
# sw $t7, 2($sp)
# sw $t6, 3($sp)
# sw $t5, 4($sp)
# sw $t4, 5($sp)
# sw $t1, 6(