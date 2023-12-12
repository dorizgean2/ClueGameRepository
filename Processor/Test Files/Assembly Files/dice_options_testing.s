main:
addi $t2, $zero, 1		# r10 = 1 
addi $t1, $zero, 2000		# r9 = 2000 (processor_input)
rng $s7, $zero, $zero
addi $t9, $s7, 100
addi $t0, $zero, 300        # t0 = turns {300, 301, 302, 303}
dice_roll_prompt:
addi $t9, $zero, 201

dice_btn_left_press:        # only for dice roll prompt
add $s1, $zero, $zero
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
nop
nop
nop
j movement

dice_btn_right_press:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
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
sw $t9, 0($t1)

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
bne $t9, $zero, end_test    

movement:
add $s1, $zero, $zero         # to keep track of difference
add $t8, $zero, $zero
addi $s3, $zero, 1000        # from VGA

check_movements:                # continuously read from vga until it has reached max movement numbers
add $t8, $zero, $zero
lw $t8, 0($t7)
lw $t8, 0($t6)
lw $t8, 0($t5)
lw $t8, 0($t4)
lw $t8, 0($s3)      
bne $t8, $zero, check_movements       # update next player information
j update_turn

update_turn:
addi $t0, $t0, 1
j dice_roll_prompt

end_test:
addi $t9, $zero, 203            # accusation has been made
nop


# addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
# addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
# addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
# addi $t4, $zero, 6000       # r12 = 6000 (BTND)