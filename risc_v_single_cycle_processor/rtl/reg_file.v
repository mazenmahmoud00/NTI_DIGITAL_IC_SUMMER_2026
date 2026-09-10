module reg_file (
    input          clk, we3,
    input   [4:0]  A1, A2, A3,
    input   [31:0] wd3,
    output  [31:0] rd1, rd2
);

reg [31:0] registers [0:31];

assign rd1 = (A1 == 5'b0) ? 32'b0 : registers[A1];
assign rd2 = (A2 == 5'b0) ? 32'b0 : registers[A2];

always @(posedge clk) 
    if (we3 && (A3 != 5'b0)) 
        registers[A3] <= wd3;
    
endmodule