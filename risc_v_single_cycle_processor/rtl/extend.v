module extend (
    input  [31:7] instr,
    input  [1:0]  imm_src,
    output reg [31:0] imm_ext
); 

always @(*) 
    case (imm_src)
        2'b00: // I-type    
            imm_ext = {{20{instr[31]}}, instr[31:20]};
        
        2'b01: // S-type
            imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        
        2'b10: // B-type
            imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        
        default: 
            imm_ext = 32'b0;
    endcase


endmodule