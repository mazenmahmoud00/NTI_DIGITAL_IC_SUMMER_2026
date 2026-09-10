module instruction_mem (
    input      [31:0] A,
    output reg [31:0] rd
);

reg [31:0] mem [0:255];

always @(*) 
    rd = mem[A[31:2]]; 
    
endmodule