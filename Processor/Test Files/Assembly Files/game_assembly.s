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
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
nop
nop
nop
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
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
nop
nop
nop
sw $s0, 4($t1)              # could be wrong on this but i'm just trying to save the rng value for comparison later her
nop
nop
nop
addi $s1, $zero, 0          # for turn = turn + 1 later perchance idk 
nop
nop
nop
sw $s1, 8($t1)
dice_btn_left_press:        # only for dice roll prompt
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
bne $t8, $t2, dice_btn_left_press         # check if left button has been pressed
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
nop                     
nop
nop
addi $out, $zero, 1          # up button has been pressed -> processor_output = 1
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
nop                     
nop
nop
addi $out, $zero, 2      # down button has been pressed -> processor_output = 2
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
nop                         
nop
nop
addi $out, $zero, 3      # left button has been pressed -> processor_output = 3
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
addi $out, $zero, 4      # right button has been pressed -> processor_output = 4
nop                      
nop
nop
sw $out, 0($t1)
nop
nop
nop
j accusations 



accusation_check: # check if player guessed correctly 
nop
nop
nop
bne $s0, $out, ban_player          # player accused incorrectly
nop                                # player guessed correctly
nop
nop
lw $out, 8($t1)                    # get the current player info
nop
nop
nop
j end_game
# NOT FINISHED YET 



ban_player: # if player guesses incorrectly 
nop
nop
nop

# TO-DO: implement turn = turn - 1
# TO-DO: boot player from turns
# TO-DO: jeremyah this is all on you



continue_game: # player moves for the amount given by the dice roll
nop
nop
nop
lw $s2, 0($t7)              # read BTNL
nop
nop
nop
lw $s3, 0($t6)              # read BTNR
nop
nop
nop
lw $s4, 0($t5)              # read BTNU
nop
nop
nop
lw $s5, 0($t4)              # read BTND
nop
nop
nop
check_moves: # checks if the player's moves has reached to the maximum amount (rng value)
nop
nop
nop
sub $s6, $out, $s2          # dice roll - BTNL
sub $s6, $out, $s3          # dice roll - BTNR
sub $s6, $out, $s4          # dice roll - BTNU
sub $s6, $out, $s5          # dice roll - BTND
bne $s6, $zero, check_moves         # if player still has remaining valid moves, continue checking
nop
nop
nop
add $t8, $zero, $zero       # reset $r24 back to zero for the next player
nop
nop
nop
add $out, $zero, $zero      # reset $r25 back to zero for the next player
nop
nop
nop
addi $s1, $s1, 1           # turn = turn + 1 <- i think girl idk
nop
nop
nop
lw $out, 0($s1)             # attempt to get turn outputted
nop
nop
nop
sw $out, 8($t1)
nop
nop
nop
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
