# 1000 BTNC
# 2000 processor_output (dice roll value)
# 3000 BTNL
# 4000 BTNR
# 5000 BTNU
# 6000 BTND 


main:
nop					
nop
nop
addi $t2, $zero, 1		# r10 = 1 
nop
nop
nop
addi $t3, $zero, 1000		# r11 = 1000 
nop
nop
nop
addi $t7, $zero, 4000       # r15 = 3000 (BTNL)
nop
nop
nop
addi $t6, $zero, 3000       # r14 = 4000 (BTNR)
nop
nop
nop
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
nop
nop
nop
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
nop
nop
nop
addi $t1, $zero, 2000		# r9 = 2000 (processor_output)
nop
nop
nop
rng $s0, $zero, $zero       # random generator for the suspect
sw $s0, 4($t1)


dice_btn_left_press: # only for dice roll prompt
nop
nop
nop
lw  $in, 0($t7)		# r24 = button input
nop
nop
nop
bne $t8, $t2, dice_btn_right_press		# check if right button has been pressed
nop                                 
nop
nop                                 # if left button has been pressed, then proceed to dice being rolled
rng $out, $zero, $zero              # random generator for dice roll
nop
nop
nop
sw $out, 0($t1)
nop
nop
nop
lw $t0, 0($t1)
nop
nop
nop
j continue_game             # player moves for x amount then game passes to next person


dice_btn_right_press:
nop
nop
nop
lw $t8, 0($t6)
nop
nop
nop
bne $t8, $t2, btn_left_press         # check if left button has been pressed
nop
nop
nop          
accusations: 
nop
nop
nop
bne $out, $zero, accusation_check    
nop
nop
nop                 
check_directions_button:
nop
nop
nop
lw  $in, 0($t5)           # check if up button has been pressed
nop
nop
nop
bne $in, $t2, btn_down_press
nop                     # up button has been pressed
nop
nop
addi $out, $zero, 1          # processor_output = 1
nop
nop
nop
sw $out, 0($t1)              
nop
nop
nop
j accusations




btn_down_press:
nop
nop
nop
lw $in, 0($t4)          # check if down button has been pressed
nop
nop
nop
bne $in, $t2, btn_left_press
nop                     # down button has been pressed
nop
nop
addi $out, $zero, 2      # processor_output = 2
nop
nop
nop
sw $out, 0($t1)
nop
nop
nop
j accusations



btn_left_press:
nop
nop
nop
lw $in, 0($t7)
nop
nop
nop
bne $in, $t2, btn_right_press
nop                 # left button has been pressed
nop
nop
addi $out, $zero, 3      # processor_output = 3
nop
nop
nop
sw $out, 0($t1)
nop
nop
nop
j accusations



btn_right_press:
nop
nop
nop
lw $in, 0($t6)
nop
nop
nop
bne $in, $t2, check_directions_button        # goes back to checking buttons
nop
nop
nop
addi $out, $zero, 4      # processor_output = 4
nop             # right button has been pressed
nop
nop
sw $out, 0($t1)
nop
nop
nop
j accusations 



accusation_check:
nop
nop
nop
bne $s1, $out, incorrect_input          # player accused incorrectly
nop
nop
nop



incorrect_input:
nop
nop
nop






continue_game: # after the dice roll
nop
nop
nop
lw $s2, 0($t7)
nop
nop
nop
lw $s3, 0($t6)
nop
nop
nop
lw $s4, 0($t5)
nop
nop
nop
lw $s5, 0($t4)
nop
nop
nop
check_moves:
nop
nop
nop
sub $s6, $out, $s2
nop
nop
nop
sub $s6, $out, $s3
nop
nop
nop
sub $s6, $out, $s4
nop
nop
nop
sub $s6, $out, $s5
nop
nop
nop
bne $s6, $zero, check_moves
nop
nop
nop
add $t8, $zero, $zero
nop
nop
nop
add $out, $zero, $zero
nop
nop
nop
j dice_btn_left_press