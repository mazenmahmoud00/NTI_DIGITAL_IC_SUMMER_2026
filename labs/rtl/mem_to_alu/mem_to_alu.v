module mem_to_alu #(
    parameter ADDR = 8 , parameter WIDTH = 19 , parameter INPUT_WIDTH = 8
)(
    input                    i_clk, i_rstn, i_wr_en, i_rd_en, 
    input      [ADDR-1  : 0] i_addr,
    input      [WIDTH-1 : 0] i_din,
    output                   o_a_is_zero,
    output     [WIDTH-1:0]   o_alu_out
); 

wire [WIDTH-1 : 0] parallel_out;
wire [WIDTH-1 : 0] dout;
wire valid_0, valid_1, valid_2, serial_out;

ram#(
    .ADDR(ADDR), .WIDTH(WIDTH)
) ram_0 (
    .clk     (i_clk),
    .rstn    (i_rstn),
    .wr_en   (i_wr_en),
    .rd_en   (i_rd_en),
    .addr    (i_addr),
    .din     (i_din),
    .dout    (dout),
    .valid   (valid_0)
);


piso #(
        .WIDTH(WIDTH)
) piso_0 (
        .clk         (i_clk),
        .rst_n       (i_rstn),
        .en          (valid_0),
        .parallel_in (dout),
        .valid       (valid_1),
        .serial_out  (serial_out)
    );

sipo #(
         .WIDTH(WIDTH)
) sipo_0 (
         .serial_in(serial_out),
         .clk(i_clk), 
         .rstn(i_rstn),
         .shift_en(valid_1),
         .parallel_out(parallel_out),
         .valid(valid_2)
        );

alu #(
         .INPUT_WIDTH(INPUT_WIDTH)
) alu_0 (
         .alu_en(valid_2),
         .in_a(parallel_out[15:8]),
         .in_b(parallel_out[7:0]),
         .opcode(parallel_out[18:16]),
         .a_is_zero(o_a_is_zero),
         .alu_out(o_alu_out)
        );

endmodule