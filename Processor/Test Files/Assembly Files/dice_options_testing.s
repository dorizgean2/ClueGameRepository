main:
addi $t2, $zero, 1		    # r10 = 1 
nop
nop
nop    
addi $t1, $zero, 2000		# r9 = 2000 (processor_output)
nop
nop
nop    

rng $s7, $zero, $zero       # killer's identity is randomized
nop
nop
nop    
addi $t9, $s7, 100          # room, killer, and weapon is selected
nop
nop
nop    
sw $t9, 0($t1)              # outputs t9 or room, killer, weapon selection
nop
nop
nop    

addi $s0, $zero, 304        # s0 set to be max turns
nop
nop
nop    
addi $t0, $zero, 300        # t0 = turns {300, 301, 302, 303}
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    

dice_roll_prompt:
addi $t9, $zero, 201                    # processor saves 201 = "dice roll?" prompt
nop
nop
nop    
sw $t9, 0($t1)                          # processor outputs "dice roll?" prompt
nop
nop
nop    

dice_btn_left_press:                    # check if left button is pressed
nop
nop
nop    
add $s1, $zero, $zero                   # set s1 = 0
nop
nop
nop    
add $t8, $zero, $zero                   # set t8 = button input = 0
nop
nop
nop    
addi $t7, $zero, 3000                   # set t7 = 3000 (BTNL)
nop
nop
nop    
                

lw  $t8, 0($t7)		                    # t8 = button left input
nop
nop
nop    
add $s1, $t8, $zero                     # set s1 = button left input
nop
nop
nop    

bne $s1, $t2, dice_btn_right_press		# check if left button has been pressed 
nop
nop
nop    

addi $t9, $zero, 199             
nop
nop
nop           
sw $t9, 0($t1)

nop
nop
nop                

rng $t9, $zero, $zero                   # processor in = random generator

nop
nop
nop

sw $t9, 0($t1)                          # processor output random number

nop
nop
nop

j movement
nop
nop
nop    

dice_btn_right_press:
nop
nop
nop    
addi $t6, $zero, 4000                   # t6 = 4000 (BTNR)
nop
nop
nop    
addi $t3, $zero, 7000                   # t3 = 7000 (Red Button)
nop
nop
nop    

add $t8, $zero, $zero                   # t8 = 0
nop
nop
nop    
lw $t8, 0($t6)                          # t8 = button right input
nop
nop
nop    

add $s2, $t8, $zero                     # s2 = button right input
nop
nop
nop    
bne $s2, $t2, dice_btn_left_press       # check if right button has been pressed
nop
nop
nop    

addi $t9, $zero, 200                    # save ACCUSE prompt to processor output
nop
nop
nop    
sw $t9, 0($t1)                          # processor outputs accuse prompt
nop
nop
nop    

add $t8, $zero, $zero                   # t8 = 0


read_red_button:
nop
nop
nop 
lw $t8, 0($t3)                          # read red button
add $s3, $t8, $zero                     # save red button input to s3
nop
nop     
nop

bne $s3, $t2, read_red_button           # check if s2 = 1 (or button is pressed)
nop
nop
nop    

addi $t9, $zero, 202                    # save end accuse someone (202) to processor output
nop
nop
nop    
sw $t9, 0($t1)                          # processor outputs end accuse


check_directions_button:           
nop
nop
nop         
addi $t5, $zero, 5000                   # t5 = 5000 (BTNU)
nop
nop
nop    
add $s3, $zero, $zero                   # s3 = 0
nop
nop
nop    
add $t8, $zero, $zero                   # t8 = 0
nop
nop
nop    
lw  $t8, 0($t5)                         # check if up button has been pressed
nop
nop
nop    
add $s3, $t8, $zero                     # save button input to s3
nop
nop
nop    
bne $s3, $t2, btn_down_press
nop
nop
nop    
addi $t9, $zero, 700                    # up button has been pressed -> processor_output = 700
nop
nop
nop    
sw $t9, 0($t1)                          # processor outputs 700
nop
nop
nop    
j accuse_weapon_prompt                  

btn_down_press:
nop
nop
nop    
addi $t4, $zero, 6000                   # r12 = 6000 (BTND)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t4)                          # check if down button has been pressed
nop
nop
nop    
add $s3, $t8, $zero 
nop
nop
nop    
bne $s3, $t2, btn_left_press
nop
nop
nop    
addi $t9, $zero, 701                    # down button has been pressed -> processor_output = 701
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_weapon_prompt

btn_left_press:
nop
nop
nop    
addi $t7, $zero, 3000                   # r15 = 3000 (BTNL)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t7)
nop
nop
nop    
add $s3, $t8, $zero
nop
nop
nop    
bne $s3, $t2, btn_right_press
nop
nop
nop    
addi $t9, $zero, 702                # left button has been pressed -> processor_output = 702
nop
nop
nop    
sw $t9, 0($t1)

j accuse_weapon_prompt

btn_right_press:
nop
nop
nop    
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t6)
nop
nop
nop    
add $s3, $t8, $zero
nop
nop
nop    
bne $s3, $t2, check_directions_button        # goes back to checkt8g buttons
nop
nop
nop    
addi $t9, $zero, 703      # right button has been pressed -> processor_t9put = 4
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_weapon_prompt  

movement:
nop
nop
nop    
add $t9, $t0, $zero
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
addi $s3, $zero, 1000           # s3 = 1000 -> data from VGA
nop
nop
nop    
check_movements:                # continuously read from vga until it has reached max movement numbers
nop
nop
nop    
add $t8, $zero, $zero           # t8 = processor input = 0
nop
nop
nop    
lw $t8, 0($s3)      
nop
nop
nop    
add $s6, $t8, $zero
nop
nop
nop    
blt $t2, $s6, check_movements       # update next player information
nop
nop
nop    
update_turn:
nop
nop
nop    
addi $t0, $t0, 1                      # t0 = set turn = turn + 1
nop
nop
nop    
add $t9, $zero, $t0                   # save current turn in processor
nop
nop
nop    
sw $t9, 0($t1)                        # output current turn to VGA
nop
nop
nop    
j dice_roll_prompt


accuse_weapon_prompt:
nop
nop
nop    
addi $t9, $zero, 203            # accusation has been made
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
add $s4, $zero, $zero
nop
nop
nop    
add $s5, $zero, $zero
nop
nop
nop    
addi $t3, $zero, 8000           # blue button
read_blue_button:
nop
nop
nop
lw $t8, 0($t3)
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop
bne $s5, $t2, read_blue_button
nop
nop
nop    
addi $t9, $zero, 204        # accuse weapon selection shows up 
nop
nop
nop    
sw $t9, 0($t1)

check_directions_button_weapons:
nop
nop
nop    
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t4)          # check if down button has been pressed
nop
nop
nop    
add $s4, $t8, $zero 
nop
nop
nop    
bne $s4, $t2, btn_left_press_weapons
nop
nop
nop    
addi $t9, $zero, 704      # down button has been pressed -> processor_t9put = 2
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_room_prompt

btn_left_press_weapons:
nop
nop
nop    
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t7)
nop
nop
nop    
add $s4, $t8, $zero
nop
nop
nop    
bne $s4, $t2, btn_right_press_weapons
nop
nop
nop    
addi $t9, $zero, 705      # left button has been pressed -> processor_t9put = 3
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_room_prompt

btn_right_press_weapons:
nop
nop
nop    
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t6)
nop
nop
nop    
add $s4, $t8, $zero
nop
nop
nop    
bne $s4, $t2, next_page_button        # goes back to checkt8g buttons
nop
nop
nop    
addi $t9, $zero, 706      # right button has been pressed -> processor_t9put = 4
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_room_prompt 

next_page_button:
add $t8, $zero, $zero
nop
nop
nop    
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
nop
nop
nop    
add $s5, $zero, $zero
read_next_button:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop
bne $s5, $t2, check_directions_button_weapons
nop
nop
nop    
addi $t9, $zero, 205            # next page of weapon selections
nop
nop
nop    
sw $t9, 0($t1)

next_page_check:
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t4)          # check if down button has been pressed
nop
nop
nop    
add $s4, $t8, $zero 
nop
nop
nop    
bne $s4, $t2, btn_left_press_weapons_next
nop
nop
nop    
addi $t9, $zero, 707      # down button has been pressed -> processor_t9put = 2
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_room_prompt

btn_left_press_weapons_next:
nop
nop
nop    
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t7)
nop
nop
nop    
add $s4, $t8, $zero
nop
nop
nop    
bne $s4, $t2, btn_right_press_weapons_next
nop
nop
nop    
addi $t9, $zero, 708      # left button has been pressed -> processor_t9put = 3
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accuse_room_prompt

btn_right_press_weapons_next:
nop
nop
nop    
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t6)
nop
nop
nop    
add $s4, $t8, $zero
nop
nop
nop    
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
nop
nop
nop    
addi $t9, $zero, 207                # accuse room selection image is up
nop
nop
nop    
sw $t9, 0($t1)

check_directions_button_rooms:
nop
nop
nop    
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t4)          # check if down button has been pressed
nop
nop
nop    
add $s5, $t8, $zero 
nop
nop
nop    
bne $s5, $t2, btn_left_press_rooms
nop
nop
nop    
addi $t9, $zero, 100     # down button has been pressed -> processor_t9put = 2
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check

btn_left_press_rooms:
nop
nop
nop    
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t7)
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop    
bne $s5, $t2, btn_right_press_rooms
nop
nop
nop    
addi $t9, $zero, 101      # left button has been pressed -> processor_t9put = 3
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check

btn_right_press_rooms:
nop
nop
nop    
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t6)
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop    
bne $s5, $t2, check_directions_button_rooms       # goes back to checkt8g buttons
nop
nop
nop    
addi $t9, $zero, 102      # right button has been pressed -> processor_t9put = 4
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check 

next_page_button_rooms:
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
nop
nop
nop    
add $s7, $zero, $zero

read_next_button_rooms:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
nop
nop
nop    
add $s7, $t8, $zero
nop
nop
nop
bne $s7, $t2, read_next_button_rooms
nop
nop
nop    
addi $t9, $zero, 208           # next page of room selection appears
nop
nop
nop    
sw $t9, 0($t1)

next_page_check_rooms:
nop
nop
nop    
addi $t4, $zero, 6000      # r12 = 6000 (BTND)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t4)          # check if down button has been pressed
nop
nop
nop    
add $s5, $t8, $zero 
nop
nop
nop    
bne $s5, $t2, btn_left_press_rooms_next
nop
nop
nop    
addi $t9, $zero, 103      # down button has been pressed -> processor_t9put = 2
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check

btn_left_press_rooms_next:
nop
nop
nop    
addi $t7, $zero, 3000       # r15 = 3000 (BTNL)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t7)
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop    
bne $s5, $t2, btn_right_press_rooms_next
nop
nop
nop    
addi $t9, $zero, 104      # left button has been pressed -> processor_t9put = 3
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check

btn_right_press_rooms_next:
nop
nop
nop    
addi $t6, $zero, 4000       # r14 = 4000 (BTNR)
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
lw $t8, 0($t6)
nop
nop
nop    
add $s5, $t8, $zero
nop
nop
nop    
bne $s5, $t2, next_page_button_rooms_next        # goes back to checkt8g buttons
nop
nop
nop    
addi $t9, $zero, 105      # right button has been pressed -> processor_t9put = 4
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
j accusations_check 

next_page_button_rooms_next:
nop
nop
nop    
add $t8, $zero, $zero
nop
nop
nop    
addi $t3, $zero, 7000            # r12 = 7000 (Red Button)
nop
nop
nop    
add $s7, $zero, $zero

read_next_button_rooms_next:
nop
nop
nop 
lw $t8, 0($t3)                  # read red button
nop
nop
nop    
add $s7, $t8, $zero
nop
nop
nop
bne $s7, $t2, check_directions_button_rooms
nop
nop
nop    
addi $t9, $zero, 207
nop
nop
nop    
sw $t9, 0($t1)
nop
nop
nop    
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