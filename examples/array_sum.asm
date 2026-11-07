# Array sum with a procedure call
# main: stores [10, 20, 30, 40, 50] at data address 16, calls SUM,
#       stores the result at address 21, then reloads it into R7 and halts.
# SUM:  R1 = array address, R2 = element count -> returns the sum in R3.
#
# Addr  Machine code   Assembly                     Comment

# ---- main ----
# 0x00  50100010       ADDI R1, R0, 16              R1 = array base address
# 0x01  5050000A       ADDI R5, R0, 10
# 0x02  20015000       SW   R5, 0(R1)               mem[16] = 10   (forwarding: R5)
# 0x03  50500014       ADDI R5, R0, 20
# 0x04  20015001       SW   R5, 1(R1)               mem[17] = 20
# 0x05  5050001E       ADDI R5, R0, 30
# 0x06  20015002       SW   R5, 2(R1)               mem[18] = 30
# 0x07  50500028       ADDI R5, R0, 40
# 0x08  20015003       SW   R5, 3(R1)               mem[19] = 40
# 0x09  50500032       ADDI R5, R0, 50
# 0x0A  20015004       SW   R5, 4(R1)               mem[20] = 50
# 0x0B  50200005       ADDI R2, R0, 5               R2 = number of elements
# 0x0C  61000010       JAL  SUM                     call SUM, R15 = 13 (jump stall)
# 0x0D  20013005       SW   R3, 5(R1)               mem[21] = sum
# 0x0E  10710005       LW   R7, 5(R1)               R7 = sum, read back from memory
# 0x0F  6000000F       HALT: J HALT                 jump to itself to stop

# ---- SUM procedure ----
# 0x10  50300000       SUM:  ADDI R3, R0, 0         sum = 0
# 0x11  50410000             ADDI R4, R1, 0         pointer = base address
# 0x12  30020006       LOOP: BEQ  R2, R0, DONE      exit when count is 0 (taken: flush)
# 0x13  10540000             LW   R5, 0(R4)         load element
# 0x14  00335000             ADD  R3, R3, R5        sum += element (load-use stall)
# 0x15  50440001             ADDI R4, R4, 1         pointer++
# 0x16  5022FFFF             ADDI R2, R2, -1        count--
# 0x17  30000FFB             BEQ  R0, R0, LOOP      always taken: back to LOOP (flush)
# 0x18  400F0000       DONE: JR   R15               return to main (jump stall)

# Branch targets are PC-relative: target = branch address + sign-extended Imm12
#   0x12 + 6  = 0x18 (DONE)
#   0x17 - 5  = 0x12 (LOOP)
