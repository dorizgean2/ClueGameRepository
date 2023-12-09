# NOTE: cleaner version from the original game_assembly file

main:
addi $t2, $zero, 1		# r10 = 1 
addi $t3, $zero, 1000		# r11 = 1000 
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
addi $t1, $zero, 2000		# r9 = 2000 (processor_input)
rng $s0, $zero, $zero       # random generator for the killer's identity
dice_btn_left_press:        # only for dice roll prompt
lw  $t8, 0($t7)		        # r24 = button output
add $s1, $t8, $zero
bne $s1, $t2, dice_btn_right_press		# check if right button has been pressed                                              
rng $t9, $zero, $zero                  # processor in = random number generator
sw $t9, 0($t1)
lw $t0, 0($t1)
j continue_game

dice_btn_right_press:
lw $t8, 0($t6)
add $s2, $t8, $zero
bne $s2, $t2, dice_btn_left_press         # check if left button has been pressed

accusations: 
bne $t9, $zero, accusation_check    

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


continue_game:  # count how many the player moves (max = dice roll)
add $s3, $zero, $zero          
add $s4, $zero, $zero
add $s5, $zero, $zero
add $s6, $zero, $zero
lw $s2, 0($t7)          # read from each button 
lw $s3, 0($t6)
lw $s4, 0($t5)
lw $s5, 0($t4)
check_moves:
sub $s7, $s0, $s2
sub $s7, $s0, $s3
sub $s7, $s0, $s4
sub $s7, $s0, $s5
bne $s7, $zero, check_moves     # if player still has remaining valid moves, continue until they have reached the max number/zero



reset:  # reset everything <- this happens before the next turn
add $t9, $zero, $zero
add $t8, $zero, $zero
add $s2, $zero, $zero
add $s3, $zero, $zero          
add $s4, $zero, $zero
add $s5, $zero, $zero
add $s6, $zero, $zero



j dice_btn_left_press



accusation_check:           # check if player guessed correctly
bne $t9, $s0, ban_player    # player guessed incorrectly
#TO-DO: Save the current player's turn number
j reset


ban_player:






