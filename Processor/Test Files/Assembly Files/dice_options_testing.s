main:
addi $t2, $zero, 1		# r10 = 1 
addi $t1, $zero, 2000		# r9 = 2000 (processor_input)
rng $s7, $zero, $zero       # killer's identity is randomized
addi $t9, $s7, 100          # room selection
addi $s0, $zero, 304
sw $t9, 0($t1)
addi $t0, $zero, 301        # t0 = turns {300, 301, 302, 303}
add $t9, $t0, $zero
sw $t9, 0($t1)
dice_roll_prompt:
addi $t9, $zero, 201
sw $t9, 0($t1)

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
addi $s2, $zero, 300
bne $t0, $s2, movement1
addi $s2, $zero, 301
bne $t0, $s2, movement2
addi $s2, $zero, 302
bne $t0, $s2, movement3
j movement4

dice_btn_right_press:
addi $t6, $zero, 4000               # r14 = 4000 (BTNR)
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
addi $t9, $zero, 700          # up button has been pressed -> processor_output = 1
sw $t9, 0($t1)              
j accuse_weapon_prompt

btn_down_press:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s3, $t8, $zero 
bne $s3, $t2, btn_left_press
addi $t9, $zero, 701      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accuse_weapon_prompt

btn_left_press:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s3, $t8, $zero
bne $s3, $t2, btn_right_press
addi $t9, $zero, 702      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accuse_weapon_prompt

btn_right_press:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s3, $t8, $zero
bne $s3, $t2, check_directions_button        # goes back to checkt8g buttons
addi $t9, $zero, 703      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accuse_weapon_prompt  

movement1:
add $t8, $zero, $zero
addi $s3, $zero, 1000        # from VGA

check1_movements:                # continuously read from vga until it has reached max movement numbers
add $t8, $zero, $zero
lw $t8, 0($s3)      
bne $t8, $zero, check1_movements       # update next player information

update_turn1:
addi $t0, $t0, 1
add $t9, $t0, $zero
sw $t9, 0($t1)
j dice_roll_prompt

movement2:
add $t8, $zero, $zero
addi $s3, $zero, 1000        # from VGA

check2_movements:                # continuously read from vga until it has reached max movement numbers
add $t8, $zero, $zero
lw $t8, 0($s3)      
bne $t8, $zero, check2_movements       # update next player information

update_turn2:
addi $t0, $t0, 1
add $t9, $t0, $zero
sw $t9, 0($t1)
j dice_roll_prompt

movement3:
add $t8, $zero, $zero
addi $s3, $zero, 1000        # from VGA

check3_movements:                # continuously read from vga until it has reached max movement numbers
add $t8, $zero, $zero
lw $t8, 0($s3)      
bne $t8, $zero, check3_movements       # update next player information

update_turn3:
addi $t0, $t0, 1
add $t9, $t0, $zero
sw $t9, 0($t1)
j dice_roll_prompt

movement4:
add $t8, $zero, $zero
addi $s3, $zero, 1000        # from VGA

check4_movements:                # continuously read from vga until it has reached max movement numbers
add $t8, $zero, $zero
lw $t8, 0($s3)      
bne $t8, $zero, check4_movements       # update next player information

update_turn4:
addi $t0, $zero, 300
add $t9, $t0, $zero
sw $t9, 0($t1)
j dice_roll_prompt


accuse_weapon_prompt:
addi $t9, $zero, 203            # accusation has been made
sw $t9, 0($$t1)
add $t8, $zero, $zero
add $s4, $zero, $zero
add $s5, $zero, $zero
addi $t3, $zero, 8000           # blue button
read_blue_button:
nop
nop
nop
lw $t8, 0($t3)
add $s5, $t8, $zero
nop
nop
nop
bne $s5, $t2, read_blue_button
addi $t9, $zero, 204        # accuse weapon selection shows up 
sw $t9, 0($t1)

check_directions_button_weapons:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s4, $t8, $zero 
bne $s4, $t2, btn_left_press_weapons
addi $t9, $zero, 704      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accuse_room_prompt

btn_left_press_weapons:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s4, $t8, $zero
bne $s4, $t2, btn_right_press_weapons
addi $t9, $zero, 705      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accuse_room_prompt

btn_right_press_weapons:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s4, $t8, $zero
bne $s4, $t2, next_page_button        # goes back to checkt8g buttons
addi $t9, $zero, 706      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accuse_room_prompt 

next_page_button:
add $t8, $zero, $zero
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
add $s5, $zero, $zero
read_next_button:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
add $s5, $t8, $zero
nop
nop
nop
bne $s5, $t2, check_directions_button_weapons
addi $t9, $zero, 205            # next page of weapon selections
sw $t9, 0($t1)

next_page_check:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s4, $t8, $zero 
bne $s4, $t2, btn_left_press_weapons_next
addi $t9, $zero, 707      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accuse_room_prompt

btn_left_press_weapons_next:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s4, $t8, $zero
bne $s4, $t2, btn_right_press_weapons_next
addi $t9, $zero, 708      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accuse_room_prompt

btn_right_press_weapons_next:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s4, $t8, $zero
bne $s4, $t2, next_page_button_next        # goes back to checkt8g buttons
addi $t9, $zero, 709      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accuse_room_prompt 

next_page_button_next:
add $t8, $zero, $zero
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
add $s5, $zero, $zero
read_next_button_next:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
add $s5, $t8, $zero
nop
nop
nop
bne $s5, $t2, check_directions_button
addi $t9, $zero, 204
sw $t9, 0($t1)

accuse_room_prompt:
addi $t9, $zero, 206                      # ACCUSE ROOM prompts up
sw $t9, 0($t1)
add $t8, $zero, $zero
add $s7, $zero, $zero
add $s5, $zero, $zero
addi $t3, $zero, 9000           # yellow button
read_yellow_button:
nop
nop
nop 
lw $t8, 0($t3)                  # read yellow button
add $s7, $t8, $zero
nop
nop
nop
bne $s7, $t2, read_yellow_button
addi $t9, $zero, 207                # accuse room selection image is up
sw $t9, 0($t1)

check_directions_button_rooms:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s5, $t8, $zero 
bne $s5, $t2, btn_left_press_rooms
addi $t9, $zero, 100     # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accusations_check

btn_left_press_rooms:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s5, $t8, $zero
bne $s5, $t2, btn_right_press_rooms
addi $t9, $zero, 101      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accusations_check

btn_right_press_rooms:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s5, $t8, $zero
bne $s5, $t2, check_directions_button_rooms       # goes back to checkt8g buttons
addi $t9, $zero, 102      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accusations_check 

next_page_button_rooms:
add $t8, $zero, $zero
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
add $s7, $zero, $zero
read_next_button_rooms:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
add $s7, $t8, $zero
nop
nop
nop
bne $s7, $t2, read_next_button_rooms
addi $t9, $zero, 208           # next page of room selection appears
sw $t9, 0($t1)

next_page_check_rooms:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
add $t8, $zero, $zero
lw $t8, 0($t4)          # check if down button has been pressed
add $s5, $t8, $zero 
bne $s5, $t2, btn_left_press_rooms_next
addi $t9, $zero, 103      # down button has been pressed -> processor_t9put = 2
sw $t9, 0($t1)
j accusations_check

btn_left_press_rooms_next:
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
add $t8, $zero, $zero
lw $t8, 0($t7)
add $s5, $t8, $zero
bne $s5, $t2, btn_right_press_rooms_next
addi $t9, $zero, 104      # left button has been pressed -> processor_t9put = 3
sw $t9, 0($t1)
j accusations_check

btn_right_press_rooms_next:
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
add $t8, $zero, $zero
lw $t8, 0($t6)
add $s5, $t8, $zero
bne $s5, $t2, next_page_button_rooms_next        # goes back to checkt8g buttons
addi $t9, $zero, 105      # right button has been pressed -> processor_t9put = 4
sw $t9, 0($t1)
j accusations_check 

next_page_button_rooms_next:
add $t8, $zero, $zero
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
add $s7, $zero, $zero
read_next_button_rooms_next:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
add $s7, $t8, $zero
nop
nop
nop
bne $s7, $t2, check_directions_button_rooms
addi $t9, $zero, 207
sw $t9, 0($t1)
j accusations_check


accusations_check:
nop



# addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
# addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
# addi $t5, $zero, 5000       # r13 = 5000 (BTNU)
# addi $t4, $zero, 6000       # r12 = 6000 (BTND)




#800 - identity check
#801 - weapon check
#802 - room check