# Processor
## NAME (NETID)
Jeremyah Flowers (jtf45)

## Description of Design
Overview of Design :
 - Five stage pipeline processor that runs most (up until sort) of the processor test cases. Uses provided wrapper, along    previously developed regfile, multdiv, and alu modules. Successfully completes all ISA instructions: multiplication, di   division, addition, subtraction, shift left logical, shift right logical, branch not equals, branch less than, load       word, store word, exceptions, etc. Also fully functions and runs under the time constraints. 

General Description :
 Lines 65-92 : 
    - Initializes processor wires as well as input and output enable bits for each register
 Lines 95-108 :
    - Serves as "fetch" stage for the pipeline processor. Gets instructions from imem and outputs them to decode. 
 Lines 111-136 :
    - Serves as "decode" stage for the pipeline processor. Gets instructions from fetch stage, decodes them, then outputs
      the data from the respective registers from reg-file.
 Lines 141-296 :
    - Bulk of pipeline processor logic: handles most of the instructions including but not limited to - multiplication, 
      division, addition, subtraction, shifts, and all J1, J2, and I type instructions. 
    - Raises exceptions for ALU and MULTDIV modules and also does sign extending.
    - Contains most of the control logic for the pipeline processor - including logic for bypassing, stalling, etc.
 Lines 299-334 :
    - Handles memory stage for pipeline processor. Also asserts several wires used in the logic for execute and writeback       stages.

 Lines 337-388 :
    - Handles control for the writeback stage and also asserts the exceptions for the ALU, Multdiv, and Set exception 
      instructions. 
    - Outputs data to write-reg and chooses data based on the instruction's opcode.

## Bypassing
    Bypassing is handled during the execute stage using conditional statements. The following control signals were 
    assessed using bypassing:
        - Execute and memory/writeback share the same RD and RS (given its not a store word instruction)
        - Execute and memory/writeback share the same RD and RS (given its not consecutive load words)
        - Execute and memory/writeback share the same RD and RS (given its a mult/div instruction)
        - Execute and memory/writeback share the same RD and RD (given its a jr or branch instruction)
        - Execute and memory/writeback share the same RD and RT (given its not a store word instruction)
        - Execute and memory/writeback share the same RD and RT (given its not consecutive load words)
        - Execute and memory/writeback share the same RD and RT (given its a mult/div instruction)

## Stalling
Stalling logic is handled in one of two cases:
    1. During a mult div instruction, the entire CPU is stalled until the mult/div is ready signal is raised.
    2. During a lw instruction when the data after it depends on the data it is writing.
In either case, the stall logic is handled similiarly, but is terminated differently based on the instruction passed.    

## Optimizations
No optimizations were made to the CPU.

## Bugs
The only known (found) bug is in sort, where the CPU fails to properly compute the desired output. My guess is was by-
passing; however, upon further inspection, the CPU fails even without any bypasses being asserted in the test. 
My second guess would be the data being improperly handled in between passing instructions, but as of currently, 
the exact reason is unknown.
