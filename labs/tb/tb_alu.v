module tb_alu ();

parameter WIDTH = 8;

reg   [WIDTH-1:0] in_a, in_b;
reg   [2:0]       opcode;
reg               alu_en;
wire              a_is_zero;
wire  [WIDTH-1:0] alu_out; 

reg   [WIDTH-1:0] expected_out; 
reg               expected_a_is_zero;

alu #(WIDTH) dut (
    .alu_en(alu_en),
    .in_a(in_a),
    .in_b(in_b),
    .opcode(opcode),
    .a_is_zero(a_is_zero),
    .alu_out(alu_out)
);

integer i, fail;

initial 
    begin
    opcode = 0;
    in_a = 0;
    in_b = 0;
    alu_en = 0;
    fail = 0;

    for(i=0; i<8; i=i+1)
        begin
        #10;
        opcode = i[2:0];
        in_a = $random;
        in_b = $random;
        alu_en = $random;
        #10;
        $display("in_a = %b | in_b = %b | opcode = %b | alu_en = %b | alu_out = %b | a_is_zero = %b",
        in_a, in_b, opcode, alu_en, alu_out, a_is_zero);
        if((alu_out == expected_out) && (a_is_zero == expected_a_is_zero))
            $display("[PASS] alu_out = expected_out, a_is_zero = expected_a_is_zero");
        else 
            begin
            fail = fail + 1;
            $display("[FAIL] failed at opcode = %b (alu_out_exp = %b, a_is_zero_exp = %b)", 
                      opcode, expected_out, expected_a_is_zero);
            end
        end
    $display("number of fails = %0d", fail);
    $finish;    
    end

always @(*) begin
    expected_a_is_zero = alu_en ? (!in_a) : 1'b0;
    
    if (!alu_en)
        expected_out = '0;
    else
        case(opcode)
            3'b000 : expected_out = in_a + in_b;
            3'b001 : expected_out = in_a - in_b;
            3'b010 : expected_out = in_a & in_b;
            3'b011 : expected_out = in_a ^ in_b;
            3'b100 : expected_out = in_a | in_b;
            3'b101 : expected_out = in_a;
            default: expected_out = '0;
        endcase
end

endmodule