module data_mem (
    input         clk, we,
    input  [31:0] A, wd,
    output [31:0] rd
);

reg [31:0] mem [0:127];

assign rd = mem[A[31:2]];

always @(posedge clk) 
    if (we) 
        mem[A[31:2]] <= wd;

endmodule