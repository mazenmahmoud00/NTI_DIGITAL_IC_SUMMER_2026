    module alu (
        input      [31:0] a, b,
        input      [2:0]  alu_control,
        output reg [31:0] alu_out,
        output            zero
    );

    always @(*) 
        case (alu_control)
            3'b000:  // Addition (add, addi, loads, stores)
                alu_out = a + b;   

            3'b001:  // Subtraction (sub, beq)
                alu_out = a - b;  
                                    
            3'b010:  // Bitwise AND (and, andi)
                alu_out = a & b;   

            3'b011:  // Bitwise OR (or, ori)
                alu_out = a | b;    

            3'b100:  // Set less than (slt, slti)
                alu_out = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; 

            default: 
                alu_out = 32'b0;
        endcase


    assign zero = (alu_out == 32'b0);

    endmodule