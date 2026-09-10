module riscv_single (
    input clk,
    input rst
);

wire        pc_src, result_src, mem_write, alu_src, reg_write, zero;
wire [1:0]  imm_src;
wire [2:0]  alu_control;
wire [31:0] pc, pc_next, pc_plus_4, pc_target, instr;
wire [31:0] src_a, src_b, write_data, alu_out, read_data, result, imm_ext;

program_counter pcr (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc(pc)
);

adder pc_add_4 (
    .a(pc),
    .b(32'd4),
    .y(pc_plus_4)
);

instruction_mem imem (
    .A(pc),
    .rd(instr)
);

control c_unit (
    .op(instr[6:0]),
    .funct3(instr[14:12]),
    .funct7_b5(instr[30]),
    .zero(zero),
    .pc_src(pc_src),
    .result_src(result_src),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .imm_src(imm_src),
    .reg_write(reg_write),
    .alu_control(alu_control)
);

reg_file rf (
    .clk(clk),
    .we3(reg_write),
    .A1(instr[19:15]),
    .A2(instr[24:20]),
    .A3(instr[11:7]),
    .wd3(result),
    .rd1(src_a),
    .rd2(write_data)
);

extend ext (
    .instr(instr[31:7]),
    .imm_src(imm_src),
    .imm_ext(imm_ext)
);

alu alu_inst (
    .a(src_a),
    .b(src_b),
    .alu_control(alu_control),
    .alu_out(alu_out),
    .zero(zero)
);

data_mem dmem (
    .clk(clk),
    .we(mem_write),
    .A(alu_out),
    .wd(write_data),
    .rd(read_data)
);

adder pc_add_target (
    .a(pc),
    .b(imm_ext),
    .y(pc_target)
);

assign src_b = alu_src ? imm_ext : write_data;

assign result = result_src ? read_data : alu_out;

assign pc_next = pc_src ? pc_target : pc_plus_4;

endmodule