module alu_decoder (
    input             op,
    input      [2:0]  funct3,
    input             funct7_b5,
    input      [1:0]  alu_op,
    output reg [2:0]  alu_control
);

always @(*) 
    case (alu_op) 
        2'b00:  // SW (I-type) & LW (S-type)
            alu_control = 3'b000; // memory instructions  (Addition for load & store)
            
        2'b01:  // beq (B-type) 
            alu_control = 3'b001; // branches instruction (Substraction for comparison)

        2'b10 : // (R-type) & Immediate ALU operations (I type)
            case (funct3)
                3'b000:  // ADD / SUB
                    alu_control = (op & funct7_b5) ? 3'b001 : 3'b000;
                    
                3'b010:  // SLT, SLTI 
                    alu_control = 3'b100;
                    
                3'b011:  // SLTU, SLTIU 
                    alu_control = 3'b101;

                3'b110:  // OR, ORI
                    alu_control = 3'b011;
                    
                3'b111:  // AND, ANDI
                    alu_control = 3'b010;
                    
                default: 
                    alu_control = 3'b000;
            endcase
    endcase

endmodule