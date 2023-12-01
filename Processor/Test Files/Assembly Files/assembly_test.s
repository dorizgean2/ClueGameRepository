main:
    nop                     # Basic Control Test with no Data Hazards
    nop                     # Values initialized using addi (positive only) and sub
    nop                     # Registers 10,11 track correct and 20-23 track incorrect
    nop                     # Values and comments in the test of JR must be updated if code modified.
    nop                     # Author: Nathaniel Brooke, Modified by Will Denton
    nop
    nop                     # Initialize Values
    addi $r1, $r0, 4		# r1 = 4
    addi $r2, $r0, 5		# r2 = 5
    nop                   # Final Check (All Correct)
    and $r0, $r11, $r11		# r11 should be 15
    and $r0, $r23, $r23		# r23 should be 0
    addi $r1, $r0, 1
    nop
    nop
    nop
    lw $r2, 1000($r0)
    nop
    nop
    nop
    bne $r2, $r1, main
    addi $r3, $r0, 1