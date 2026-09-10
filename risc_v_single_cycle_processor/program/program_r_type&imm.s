# Test R-Type, Immediate ALU Operations, and Logic
addi x1, x0, 10    # x1 = 10
addi x2, x0, 5     # x2 = 5
add  x4, x1, x2    # x4 = 10 + 5 = 15 (ADD)
sub  x5, x1, x2    # x5 = 10 - 5 = 5  (SUB)
and  x6, x1, x2    # x6 = 10 & 5 = 0  (AND)
or   x7, x1, x2    # x7 = 10 | 5 = 15 (OR)
xor  x8, x1, x2    # x8 = 10 ^ 5 = 15 (XOR)
slt  x9, x2, x1    # x9 = (5 < 10) = 1 (SLT)
ori  x10, x1, 5    # x10 = 10 | 5 = 15 (ORI)
andi x11, x1, 5    # x11 = 10 & 5 = 0  (ANDI)
slti x12, x1, 20   # x12 = (10 < 20) = 1 (SLTI)