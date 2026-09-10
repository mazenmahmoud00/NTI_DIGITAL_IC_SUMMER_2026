# Test Branching (BEQ)
addi x1, x0, 5     # x1 = 5
addi x2, x0, 5     # x2 = 5
beq  x1, x2, label # Branch taken because x1 == x2
addi x3, x0, 99    # Should be skipped
label:
addi x4, x0, 1     # x4 = 1 (Branch taken verified)