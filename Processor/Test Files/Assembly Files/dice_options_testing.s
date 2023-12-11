main:
addi $t2, $zero, 1		# r10 = 1 
addi $t1, $zero, 2000		# r9 = 2000 (processor_input)
rng $s7, $zero, $zero
addi $t9, $s7, 100
dice_roll_prompt:
addi $t9, $zero, 201

dice_btn_left_press:        # only for dice roll prompt
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
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
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t3, $zero, 8000            # r12 = 8000 (Red Button)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s2, $t8, $zero
bne $s2, $t2, dice_btn_left_press         # check if left button has been pressed
addi $t9, $zero, 200                      # ACCUSE prompts up
sw $t9, 0($t1)
add $t8, $zero, $zero
read_red_button:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
add $s3, $t8, $zero
nop
nop
nop
bne $s3, $t2, read_red_button
addi $t9, $zero, 202

check_directions_button:
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
add $s3, $zero, $zero
add $t8, $zero, $zero
lw  $t8, 0($t5)           # check if up button has been pressed
add $s3, $t8, $zero
bne $s3, $t2, btn_down_press
addi $t9, $zero, 2          # up button has been pressed -> processor_output = 1
sw $t9, 0($t1)              
j accusations

btn_down_press:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s4, $t8, $zero 
bne $s4, $t2, btn_left_press
addi $t9, $zero, 3      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accusations

btn_left_press:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s5, $t8, $zero
bne $s5, $t2, btn_right_press
addi $t9, $zero, 4      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accusations

btn_right_press:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s6, $t8, $zero
bne $s6, $t2, check_directions_button        # goes back to checkt8g buttons
addi $t9, $zero, 5      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accusations 

accusations:                 
sw $t9, 0($t1)           
bne $t9, $zero, end_test    

# continue_game:
# lw $s2, 0($t7)          
# nop
# nop
# nop
# lw $s3, 0($t6)
# nop
# nop
# nop
# lw $s4, 0($t5)
# nop
# nop
# nop
# lw $s5, 0($t4)
# nop
# nop
# nop
# check_moves:
# sub $s7, $s0, $s2
# sub $s7, $s0, $s3
# sub $s7, $s0, $s4
# sub $s7, $s0, $s5
# bne $s7, $zero, continue_game     # if player still has remaining valid moves, continue until they have reached the max number/zero
# reset:  
# add $t9, $zero, $zero
# add $t8, $zero, $zero
# add $s2, $zero, $zero
# add $s3, $zero, $zero          
# add $s4, $zero, $zero
# add $s5, $zero, $zero
# add $s6, $zero, $zero
# j dice_roll_prompt


end_test:
addi $t9, $zero, 203            # accusation has been made
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