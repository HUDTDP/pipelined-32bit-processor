# Self-checking test program for the pipelined 32-bit RISC processor
# Every test puts its result in R3 and the expected value in R4.
# PASS: R14 = 0x600D and mem[0] = 0x600D.  FAIL: R14 = 0x0BAD, mem[0] = 0x0BAD, R13 = failed test.

# ---- Setup ----
       ADDI R1, R0, 7          # 0x00  50100007  R1 = 7
       ADDI R2, R0, -3         # 0x01  5020FFFD  R2 = -3 (0xFFFFFFFD)
# ---- Test 1: ADD ----
       ADDI R13, R0, 1         # 0x02  50D00001  R13 = test number 1
       ADD R3, R1, R2          # 0x03  00312000  7 + (-3)
       ADDI R4, R0, 4          # 0x04  50400004  expected 4
       BNE R3, R4, FAIL        # 0x05  31034096  result != expected -> FAIL
# ---- Test 2: SUB ----
       ADDI R13, R0, 2         # 0x06  50D00002  R13 = test number 2
       SUB R3, R1, R2          # 0x07  01312000  7 - (-3)
       ADDI R4, R0, 10         # 0x08  5040000A  expected 10
       BNE R3, R4, FAIL        # 0x09  31034092  result != expected -> FAIL
# ---- Test 3: SLT (signed) ----
       ADDI R13, R0, 3         # 0x0A  50D00003  R13 = test number 3
       SLT R3, R2, R1          # 0x0B  02321000  -3 < 7 signed
       ADDI R4, R0, 1          # 0x0C  50400001  expected 1
       BNE R3, R4, FAIL        # 0x0D  3103408E  result != expected -> FAIL
# ---- Test 4: SLTU (unsigned) ----
       ADDI R13, R0, 4         # 0x0E  50D00004  R13 = test number 4
       SLTU R3, R2, R1         # 0x0F  03321000  0xFFFFFFFD < 7 unsigned
       ADDI R4, R0, 0          # 0x10  50400000  expected 0
       BNE R3, R4, FAIL        # 0x11  3103408A  result != expected -> FAIL
# ---- Test 5: AND ----
       ADDI R13, R0, 5         # 0x12  50D00005  R13 = test number 5
       AND R3, R1, R2          # 0x13  04312000  7 & 0xFFFFFFFD
       ADDI R4, R0, 5          # 0x14  50400005  expected 5
       BNE R3, R4, FAIL        # 0x15  31034086  result != expected -> FAIL
# ---- Test 6: OR ----
       ADDI R13, R0, 6         # 0x16  50D00006  R13 = test number 6
       OR R3, R1, R2           # 0x17  05312000  7 | 0xFFFFFFFD
       ADDI R4, R0, -1         # 0x18  5040FFFF  expected 0xFFFFFFFF
       BNE R3, R4, FAIL        # 0x19  31034082  result != expected -> FAIL
# ---- Test 7: XOR ----
       ADDI R13, R0, 7         # 0x1A  50D00007  R13 = test number 7
       XOR R3, R1, R2          # 0x1B  06312000  7 ^ 0xFFFFFFFD
       ADDI R4, R0, -6         # 0x1C  5040FFFA  expected 0xFFFFFFFA
       BNE R3, R4, FAIL        # 0x1D  3103407E  result != expected -> FAIL
# ---- Test 8: NOR ----
       ADDI R13, R0, 8         # 0x1E  50D00008  R13 = test number 8
       NOR R3, R1, R2          # 0x1F  07312000  ~(7 | 0xFFFFFFFD)
       ADDI R4, R0, 0          # 0x20  50400000  expected 0
       BNE R3, R4, FAIL        # 0x21  3103407A  result != expected -> FAIL
# ---- Test 9: ADDI (negative immediate) ----
       ADDI R13, R0, 9         # 0x22  50D00009  R13 = test number 9
       ADDI R3, R1, -10        # 0x23  5031FFF6  7 + (-10)
       ADDI R4, R0, -3         # 0x24  5040FFFD  expected -3
       BNE R3, R4, FAIL        # 0x25  31034076  result != expected -> FAIL
# ---- Test 10: SLTI (signed) ----
       ADDI R13, R0, 10        # 0x26  50D0000A  R13 = test number 10
       SLTI R3, R2, 0          # 0x27  52320000  -3 < 0
       ADDI R4, R0, 1          # 0x28  50400001  expected 1
       BNE R3, R4, FAIL        # 0x29  31034072  result != expected -> FAIL
# ---- Test 11: SLTIU (sign-extended imm, unsigned compare) ----
       ADDI R13, R0, 11        # 0x2A  50D0000B  R13 = test number 11
       SLTIU R3, R1, 0xFFFF    # 0x2B  5331FFFF  7 <u 0xFFFFFFFF
       ADDI R4, R0, 1          # 0x2C  50400001  expected 1
       BNE R3, R4, FAIL        # 0x2D  3103406E  result != expected -> FAIL
# ---- Test 12: ANDI (zero-extended) ----
       ADDI R13, R0, 12        # 0x2E  50D0000C  R13 = test number 12
       ANDI R3, R2, 0xFFFF     # 0x2F  5432FFFF  0xFFFFFFFD & 0x0000FFFF
       ORI R4, R0, 0xFFFD      # 0x30  5540FFFD  expected 0x0000FFFD
       BNE R3, R4, FAIL        # 0x31  3103406A  result != expected -> FAIL
# ---- Test 13: ORI (zero-extended) ----
       ADDI R13, R0, 13        # 0x32  50D0000D  R13 = test number 13
       ORI R3, R1, 0x8000      # 0x33  55318000  7 | 0x00008000
       ORI R4, R0, 0x8007      # 0x34  55408007  expected 0x00008007
       BNE R3, R4, FAIL        # 0x35  31034066  result != expected -> FAIL
# ---- Test 14: XORI (zero-extended) ----
       ADDI R13, R0, 14        # 0x36  50D0000E  R13 = test number 14
       XORI R3, R2, 0xFFFF     # 0x37  5632FFFF  0xFFFFFFFD ^ 0x0000FFFF
       LUI R4, 0xFFFF          # 0x38  5C40FFFF  expected 0xFFFF0002 (built with LUI + ORI)
       ORI R4, R4, 2           # 0x39  55440002
       BNE R3, R4, FAIL        # 0x3A  31034061  result != expected -> FAIL
# ---- Test 15: SLL ----
       ADDI R13, R0, 15        # 0x3B  50D0000F  R13 = test number 15
       SLL R3, R1, 4           # 0x3C  58310004  7 << 4
       ADDI R4, R0, 0x70       # 0x3D  50400070  expected 0x70
       BNE R3, R4, FAIL        # 0x3E  3103405D  result != expected -> FAIL
# ---- Test 16: SRL (logical) ----
       ADDI R13, R0, 16        # 0x3F  50D00010  R13 = test number 16
       SRL R3, R2, 28          # 0x40  5932001C  0xFFFFFFFD >>> 28
       ADDI R4, R0, 15         # 0x41  5040000F  expected 0xF
       BNE R3, R4, FAIL        # 0x42  31034059  result != expected -> FAIL
# ---- Test 17: SRA (arithmetic) ----
       ADDI R13, R0, 17        # 0x43  50D00011  R13 = test number 17
       SRA R3, R2, 1           # 0x44  5A320001  -3 >> 1
       ADDI R4, R0, -2         # 0x45  5040FFFE  expected -2
       BNE R3, R4, FAIL        # 0x46  31034055  result != expected -> FAIL
# ---- Test 18: ROR ----
       ADDI R13, R0, 18        # 0x47  50D00012  R13 = test number 18
       ROR R3, R1, 1           # 0x48  5B310001  rotate 7 right by 1
       LUI R4, 0x8000          # 0x49  5C408000  expected 0x80000003
       ORI R4, R4, 3           # 0x4A  55440003
       BNE R3, R4, FAIL        # 0x4B  31034050  result != expected -> FAIL
# ---- Test 19: LUI ----
       ADDI R13, R0, 19        # 0x4C  50D00013  R13 = test number 19
       LUI R3, 0x1234          # 0x4D  5C301234  0x1234 << 16
       ADDI R4, R0, 0x1234     # 0x4E  50401234  expected 0x12340000 (built with SLL)
       SLL R4, R4, 16          # 0x4F  58440010
       BNE R3, R4, FAIL        # 0x50  3103404B  result != expected -> FAIL
# ---- Test 20: R0 is hardwired to zero ----
       ADDI R13, R0, 20        # 0x51  50D00014  R13 = test number 20
       ADDI R0, R0, 5          # 0x52  50000005  write to R0 must be ignored
       ADD R3, R0, R0          # 0x53  00300000  R3 = R0 + R0
       ADDI R4, R0, 0          # 0x54  50400000  expected 0
       BNE R3, R4, FAIL        # 0x55  31034046  result != expected -> FAIL
# ---- Test 21: Forwarding EX/MEM -> EX ----
       ADDI R13, R0, 21        # 0x56  50D00015  R13 = test number 21
       ADDI R5, R0, 3          # 0x57  50500003
       ADD R3, R5, R5          # 0x58  00355000  R5 needed by the very next instruction
       ADDI R4, R0, 6          # 0x59  50400006  expected 6
       BNE R3, R4, FAIL        # 0x5A  31034041  result != expected -> FAIL
# ---- Test 22: Forwarding MEM/WB -> EX ----
       ADDI R13, R0, 22        # 0x5B  50D00016  R13 = test number 22
       ADDI R5, R0, 4          # 0x5C  50500004
       ADDI R6, R0, 1          # 0x5D  50600001  one instruction in between
       ADD R3, R5, R5          # 0x5E  00355000  R5 two instructions back
       ADDI R4, R0, 8          # 0x5F  50400008  expected 8
       BNE R3, R4, FAIL        # 0x60  3103403B  result != expected -> FAIL
# ---- Test 23: Forwarding both operands from different stages ----
       ADDI R13, R0, 23        # 0x61  50D00017  R13 = test number 23
       ADDI R5, R0, 2          # 0x62  50500002
       ADDI R6, R0, 9          # 0x63  50600009
       ADD R3, R5, R6          # 0x64  00356000  R5 from MEM/WB, R6 from EX/MEM
       ADDI R4, R0, 11         # 0x65  5040000B  expected 11
       BNE R3, R4, FAIL        # 0x66  31034035  result != expected -> FAIL
# ---- Test 24: Forwarding priority (newest value wins) ----
       ADDI R13, R0, 24        # 0x67  50D00018  R13 = test number 24
       ADDI R5, R0, 1          # 0x68  50500001
       ADDI R5, R0, 20         # 0x69  50500014  R5 written twice in a row
       ADD R3, R5, R0          # 0x6A  00350000  must get 20, not 1
       ADDI R4, R0, 20         # 0x6B  50400014  expected 20
       BNE R3, R4, FAIL        # 0x6C  3103402F  result != expected -> FAIL
# ---- Test 25: SW then LW with load-use stall ----
       ADDI R13, R0, 25        # 0x6D  50D00019  R13 = test number 25
       ADDI R5, R0, 77         # 0x6E  5050004D
       SW R5, 100(R0)          # 0x6F  20005064  mem[100] = 77 (store data forwarded)
       LW R6, 100(R0)          # 0x70  10600064
       ADD R3, R6, R6          # 0x71  00366000  uses R6 right after LW -> 1-cycle stall
       ADDI R4, R0, 154        # 0x72  5040009A  expected 154
       BNE R3, R4, FAIL        # 0x73  31034028  result != expected -> FAIL
# ---- Test 26: LW with base register + displacement ----
       ADDI R13, R0, 26        # 0x74  50D0001A  R13 = test number 26
       ADDI R5, R0, 98         # 0x75  50500062
       LW R3, 2(R5)            # 0x76  10350002  mem[98 + 2] = mem[100]
       ADDI R4, R0, 77         # 0x77  5040004D  expected 77
       BNE R3, R4, FAIL        # 0x78  31034023  result != expected -> FAIL
# ---- Test 27: Load feeding a store (LW -> SW) ----
       ADDI R13, R0, 27        # 0x79  50D0001B  R13 = test number 27
       LW R6, 100(R0)          # 0x7A  10600064
       SW R6, 101(R0)          # 0x7B  20006065  store the value just loaded
       LW R3, 101(R0)          # 0x7C  10300065
       ADDI R4, R0, 77         # 0x7D  5040004D  expected 77
       BNE R3, R4, FAIL        # 0x7E  3103401D  result != expected -> FAIL
# ---- Test 28: BEQ not taken ----
       ADDI R13, R0, 28        # 0x7F  50D0001C  R13 = test number 28
       BEQ R1, R2, FAIL        # 0x80  3001201B  7 != -3, must fall through
# ---- Test 29: BNE taken flushes wrong-path instructions ----
       ADDI R13, R0, 29        # 0x81  50D0001D  R13 = test number 29
       ADDI R3, R0, 5          # 0x82  50300005
       BNE R1, R2, T29         # 0x83  31012003  taken
       ADDI R3, R0, 99         # 0x84  50300063  wrong path: must be flushed
       ADDI R3, R0, 99         # 0x85  50300063  wrong path: must be flushed
T29:   ADDI R4, R0, 5          # 0x86  50400005  expected 5
       BNE R3, R4, FAIL        # 0x87  31034014  result != expected -> FAIL
# ---- Test 30: BEQ taken on a just-computed register ----
       ADDI R13, R0, 30        # 0x88  50D0001E  R13 = test number 30
       ADDI R5, R0, 7          # 0x89  50500007
       BEQ R5, R1, T30         # 0x8A  30051002  R5 forwarded into the branch compare
       J FAIL                  # 0x8B  6000009B  reached only if the branch was not taken
T30:   BNE R0, R0, FAIL        # 0x8C  3100000F  BNE not taken (R0 == R0)
# ---- Test 31: J ----
       ADDI R13, R0, 31        # 0x8D  50D0001F  R13 = test number 31
       J T31                   # 0x8E  60000090
       J FAIL                  # 0x8F  6000009B  skipped by J
T31:   ADDI R3, R0, 0          # 0x90  50300000
# ---- Test 32: JAL / JR procedure call ----
       ADDI R13, R0, 32        # 0x91  50D00020  R13 = test number 32
       JAL FUNC                # 0x92  6100009E  R15 = return address
RET32: ADDI R4, R0, 42         # 0x93  5040002A  expected 42 from FUNC
       BNE R3, R4, FAIL        # 0x94  31034007  result != expected -> FAIL
       ADDI R3, R15, 0         # 0x95  503F0000  check the saved return address
       ADDI R4, R0, RET32      # 0x96  50400093  expected address of RET32
       BNE R3, R4, FAIL        # 0x97  31034004  result != expected -> FAIL

# ---- All tests passed ----
PASS:  ADDI R14, R0, 0x600D    # 0x98  50E0600D  R14 = 0x600D (good)
       SW R14, 0(R0)           # 0x99  2000E000  mem[0] = 0x600D
DONE:  J DONE                  # 0x9A  6000009A

# ---- Failure: R13 holds the number of the test that failed ----
FAIL:  ADDI R14, R0, 0x0BAD    # 0x9B  50E00BAD  R14 = 0x0BAD (bad)
       SW R14, 0(R0)           # 0x9C  2000E000  mem[0] = 0x0BAD
STOP:  J STOP                  # 0x9D  6000009D

# ---- Procedure used by test 32 ----
FUNC:  ADDI R3, R0, 42         # 0x9E  5030002A  return value
       JR R15                  # 0x9F  400F0000  return to caller
