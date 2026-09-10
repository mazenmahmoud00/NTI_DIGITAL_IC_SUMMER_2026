module control (
    input      [6:0] op,
    input      [2:0] funct3,
    input            funct7_b5,
    input            zero,       
    output           pc_src,       
    output           result_src,
    output           mem_write,
    output           alu_src,
    output     [1:0] imm_src,
    output           reg_write,
    output     [2:0] alu_control
);

wire [1:0] alu_op;
wire       branch;

main_decoder md (
    .op(op),
    .branch(branch),
    .result_src(result_src),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .imm_src(imm_src),
    .reg_write(reg_write),
    .alu_op(alu_op)
);

alu_decoder ad (
    .op(op[5]),          
    .funct3(funct3),
    .funct7_b5(funct7_b5),
    .alu_op(alu_op),
    .alu_control(alu_control)
);


assign pc_src = branch & zero;

endmodule