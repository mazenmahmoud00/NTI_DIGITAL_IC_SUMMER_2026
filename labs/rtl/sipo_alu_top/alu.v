module alu #(
    parameter WIDTH = 8
)(
    input                  alu_en,
    input      [WIDTH-1:0] in_a, in_b,
    input      [2:0]       opcode,
    output                 a_is_zero,
    output reg [WIDTH-1:0] alu_out
); 

assign a_is_zero = alu_en ? (!in_a) : 1'b0;

always @(*) begin
    if (alu_en) 
        case (opcode)
            3'b000:  
                alu_out = in_a + in_b;
            3'b001:  
                alu_out = in_a - in_b;
            3'b010:  
                alu_out = in_a & in_b;
            3'b011:  
                alu_out = in_a ^ in_b;
            3'b100:  
                alu_out = in_a | in_b;
            3'b101:  
                alu_out = in_a;
            default: 
                alu_out = 'b0;
        endcase
    else 
        alu_out = 'b0; 
        
    end

endmodule