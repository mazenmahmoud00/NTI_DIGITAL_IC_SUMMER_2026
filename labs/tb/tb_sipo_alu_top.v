module tb_sipo_alu_top ();

parameter BUS   = 19;
parameter WIDTH = 8;

reg              clk;
reg              rstn;
reg              shift_en;
reg              serial_in;
wire             a_is_zero;
wire [WIDTH-1:0] alu_out;

always #5 clk = ~clk;

sipo_alu_top #(
    .BUS(BUS),
    .WIDTH(WIDTH)
) dut (
    .serial_in(serial_in),
    .clk(clk),
    .rstn(rstn),
    .shift_en(shift_en),
    .a_is_zero(a_is_zero),
    .alu_out(alu_out)
);

task word_sender(input [2:0] opcode, input [7:0] in_a, input [7:0] in_b);
    reg [18:0] word;
    integer j;
begin
    word = {opcode, in_a, in_b};
    for (j = 18; j >= 0; j = j - 1) 
        begin
        @(negedge clk);
        shift_en  = 1'b1;
        serial_in = word[j];
        end
    @(negedge clk);
    shift_en  = 1'b0;
    serial_in = 1'b0;
end
endtask

task check_word(input [2:0] opcode, input [7:0] in_a, input [7:0] in_b);
    reg [WIDTH-1:0] expected_out;
begin
    case (opcode)
        3'b000: 
            expected_out = in_a + in_b;
        3'b001: 
            expected_out = in_a - in_b;
        3'b010: 
            expected_out = in_a & in_b;
        3'b011: 
            expected_out = in_a ^ in_b;
        3'b100: 
            expected_out = in_a | in_b;
        3'b101: 
            expected_out = in_a;
        default: 
            expected_out = 'b0;
    endcase

    word_sender(opcode, in_a, in_b);

    if (alu_out === expected_out) 
        begin
        $display("==============================================================================");
        $display("[PASS] Time=%3t | Opcode=%0b | in_a=%0d | in_b=%0d | alu_out=%0b (Expected=%0b)", 
                 $time, opcode, in_a, in_b, alu_out, expected_out);
        $display("==============================================================================");
        end 
    else 
        begin
        $display("==============================================================================");
        $display("[FAIL] Time=%3t | Opcode=%0b | in_a=%0d | in_b=%0d | alu_out=%0b (Expected=%0b)", 
               $time, opcode, in_a, in_b, alu_out, expected_out);
        $display("==============================================================================");
        end
end
endtask

initial begin
    clk       = 0;
    rstn      = 0;
    shift_en  = 0;
    serial_in = 0;
    repeat(3) @(negedge clk);

    rstn = 1;   
    repeat(1) @(negedge clk);

    check_word(3'b000, 8'd5, 8'd5);
    repeat(2) @(negedge clk);

    check_word(3'b001, 8'd8, 8'd3);
    repeat(2) @(negedge clk);

    check_word(3'b010, 8'b10101010, 8'b0000_1111);
    repeat(2) @(negedge clk);

    check_word(3'b011, 8'b1010_1010, 8'b0101_0101);
    #50;

    $finish;
end

initial begin
    $monitor("Time=%3t | rstn=%0b | shift_en=%0b | serial_in=%0b | valid=%0b | a_is_zero=%0b | alu_out=%0b ", 
             $time, rstn, shift_en, serial_in, dut.sipo_0.valid,  a_is_zero, alu_out);
end

endmodule