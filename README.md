# ClueGameRepository - Final Project for ECE350

## Made by Jeremyah Flowers (jtf45) and Doriz Concepcion (dsc54)

Notes about C code:
-------------------

When developing the C-code outline for the assembly, remember that each line will be mapped to the cooresponding
line in (pseudo-)MIPS. This means using complex functions and/or long lines of codes is ill-advised, as this will 
make it harder to map and debug code in assembly. Instead, it is preferred to used simple, clean logic that can be
easily followed in C, assmebly, and by other programmers (i.e., me).

For ease of implementation, each step should be directly mapped **AHEAD OF TIME** to the processor's ISA (listed below):

Examples of Good vs. Bad C Code for Conversion:
----------------------------------------------------------------------------

Here is an example of what that would look like, let's say you write:

    x = y + 1;

This can be directly translated in assembly as

    addi $RD, $RS, 1

Instead, let's say you write:

    x = (y + 1)*strlen(a)/b[20];

This can be directly translated in assembly as

    doityourself $imnot, $debugging, $that 

----------------------------------------------------------------------------

Notes about Assembly code:
----------------------------------
**CODE MUST BE READABLE TO BE PROPERLY IMPLEMENTED/DEBUGGED**

**EDITORS**: Please make sure to add comments when creating or adding new functionality to the code.

Original ISA:
    1.  add $RD, $RS, $RT
    2.  addi $rd, $rs, N
    3.  sub $rd, $rs, $rt
    4.  and $rd, $rs, $rt
    5.  or $rd, $rs, $rt
    6.  sll $rd, $rs, shamt
    7.  sra $rd, $rs, shamt
    8.  mul $rd, $rs, $rt
    9.  div $rd, $rs, $rt
    10. sw $rd, N($rs)
    11. lw $rd, N($rs)
    12. j T
    13. bne $rd, $rs, N
    14. jal T
    15. jr $rd
    16. blt $rd, $rs, N
    17. bex T
    18. setx T
Customized ISA (TBD):
    19. rng $rd (writes a random number to RD)


