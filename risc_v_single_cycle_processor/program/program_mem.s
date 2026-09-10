# Test Store (SW) and Load (LW)
addi x4, x0, 0     # Clear x4 first
addi x1, x0, 50    # x1 = 50
addi x2, x0, 0     # Base address = 0
sw   x1, 16(x2)    # MEM[16] = 50
lw   x4, 16(x2)    # x4 = MEM[16] (should be 50)