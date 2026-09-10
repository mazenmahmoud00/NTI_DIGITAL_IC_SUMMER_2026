module main_decoder (
    input      [6:0] op,
    output reg       branch,
    output reg       result_src,
    output reg       mem_write,
    output reg       alu_src,
    output reg [1:0] imm_src,
    output reg       reg_write,
    output reg [1:0] alu_op
);

always @(*) 
begin
    branch     = 1'b0;
    result_src = 1'b0;
    mem_write  = 1'b0;
    alu_src    = 1'b0;
    imm_src    = 2'b0;
    reg_write  = 1'b0;
    alu_op     = 2'b0;

    case (op)
        7'b0000011: // I-type (load)
        begin 
            result_src = 1'b1; 
            alu_src    = 1'b1; 
            reg_write  = 1'b1; 
        end
        7'b0100011: // S-type (store)
        begin 
            mem_write  = 1'b1; 
            alu_src    = 1'b1; 
            imm_src    = 2'b01; 
        end
        7'b0110011: // R-type
        begin 
            reg_write  = 1'b1; 
            alu_op     = 2'b10; 
        end
        7'b1100011: // beq
        begin 
            branch     = 1'b1; 
            imm_src    = 2'b10; 
            alu_op     = 2'b01; 
        end
        7'b0010011:// I-type (immediate ALU operations)
        begin
            reg_write  = 1'b1;
            alu_src    = 1'b1;  
            alu_op     = 2'b10;
        end

    endcase
end

endmodule