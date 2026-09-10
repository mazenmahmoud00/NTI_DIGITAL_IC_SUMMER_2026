module sipo_alu_top #(
    parameter BUS = 19 , parameter WIDTH = 8 
)(
    input serial_in, clk, rstn, shift_en,
    output               a_is_zero,
    output  [WIDTH-1:0]  alu_out
); 

wire [BUS-1:0] parallel_out;

sipo #(
         .BUS(BUS)
) sipo_0 (
         .serial_in(serial_in),
         .clk(clk), 
         .rstn(rstn),
         .shift_en(shift_en),
         .parallel_out(parallel_out),
         .valid(valid)
        );

alu #(
         .WIDTH(WIDTH)
) alu_0 (
         .alu_en(valid),
         .in_a(parallel_out[15:8]),
         .in_b(parallel_out[7:0]),
         .opcode(parallel_out[18:16]),
         .a_is_zero(a_is_zero),
         .alu_out(alu_out)
        );

endmodule