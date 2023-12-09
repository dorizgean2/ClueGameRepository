main:
addi $t2, $zero, 1		# r10 = 1 
addi $t3, $zero, 1000		# r11 = 1000 
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
addi $t1, $zero, 2000		# r9 = 2000 (processor_output)
rng $s0, $zero, $zero       # random generator for the suspect
sw $s0, 4($t1)              # could be wrong on this but i'm just trying to save the rng value for comparison later her
addi $s1, $zero, 0          # for turn = turn + 1 later perchance idk 
sw $s1, 8($t1)

dice_btn_left_press:                    # only for dice roll prompt
lw  $t8, 0($t7)		                    # r24 = button input
bne $t8, $t2, dice_btn_right_press		# check if right button has been pressed                             # if left button has been pressed, then proceed to dice being rolled
rng $t9, $zero, $zero                  # random generator for dice roll
sw $t9, 0($t1)
lw $t0, 0($t1)
j continue_game             # player moves for x amount then game passes to next person


dice_btn_right_press:
lw $t8, 0($t6)
bne $t8, $t2, dice_btn_left_press         # check if left button has been pressed
accusations: 
bne $t9, $zero, accusation_check    
check_directions_button:
lw  $t8, 0($t5)           # check if up button has been pressed
bne $t8, $t2, btn_down_press
addi $t9, $zero, 1          # up button has been pressed -> processor_output = 1
sw $t9, 0($t1)       
j accusations


btn_down_press:
lw $t8, 0($t4)          # check if down button has been pressed
bne $t8, $t2, btn_left_press
addi $t9, $zero, 2      # down button has been pressed -> processor_output = 2
sw $t9, 0($t1)
j accusations


btn_left_press:
lw $t8, 0($t7)
bne $t8, $t2, btn_right_press
addi $t9, $zero, 3      # left button has been pressed -> processor_output = 3
sw $t9, 0($t1)
j accusations



btn_right_press:
lw $t8, 0($t6)
bne $t8, $t2, check_directions_button        # goes back to checking buttons
addi $t9, $zero, 4      # right button has been pressed -> processor_output = 4
sw $t9, 0($t1)
j accusations 



accusation_check: # check if player guessed correctly 
bne $s0, $t9, ban_player          # player accused incorrectly                               # player guessed correctly
lw $t9, 8($t1)                    # get the current player info
j end_game
# NOT FINISHED YET 



ban_player: # if player guesses incorrectly 

# TO-DO: implement turn = turn - 1
# TO-DO: boot player from turns
# TO-DO: jeremyah this is all on you



continue_game: # player moves for the amount given by the dice roll
lw $s2, 0($t7)              # read BTNL
lw $s3, 0($t6)              # read BTNR
lw $s4, 0($t5)              # read BTNU
lw $s5, 0($t4)              # read BTND
check_moves: # checks if the player's moves has reached to the maximum amount (rng value)
sub $s6, $t9, $s2          # dice roll - BTNL
sub $s6, $t9, $s3          # dice roll - BTNR
sub $s6, $t9, $s4          # dice roll - BTNU
sub $s6, $t9, $s5          # dice roll - BTND
bne $s6, $zero, check_moves         # if player still has remaining valid moves, continue checking
add $t8, $zero, $zero       # reset $r24 back to zero for the next player
add $t9, $zero, $zero      # reset $r25 back to zero for the next player
addi $s1, $s1, 1           # turn = turn + 1 <- i think girl idk
lw $t9, 0($s1)             # attempt to get turn outputted
sw $t9, 8($t1)
j dice_btn_left_press       # next player's turn 



end_game: 



player_win:



killer_wins:


# 1000 BTNC
# 2000 processor_output (dice roll value)
# 3000 BTNL
# 4000 BTNR
# 5000 BTNU
# 6000 BTND 
