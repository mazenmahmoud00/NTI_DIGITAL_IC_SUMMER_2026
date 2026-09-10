module tb_top ();

parameter WIDTH = 4;

reg   [WIDTH-1:0] gray_in, binary;
wire  [6:0] segment; 
reg   [6:0] expected; 

top #(WIDTH) dut (gray_in, segment);

integer i, fail_count;

initial 
begin
    fail_count = 0;
    gray_in = 0;
    for (i = 0; i < 16; i = i + 1) 
        begin
        gray_in = i;
        #10;
        if (segment != expected) 
            begin
            $display("[Test failed for (gray_in = %b) : (expected = %b) but (segment = %b)]",
                      gray_in, expected, segment);
            fail_count = fail_count + 1;
            end
        end

    if (fail_count == 0) 
        $display("[PASS]");
    else 
        $display("[FAIL] [%d tests failed]", fail_count);
    #50
    $finish;
end

//golden model 
always @(*) 
    begin
        binary[3] = gray_in[3];
        binary[2] = gray_in[3] ^ gray_in[2];
        binary[1] = gray_in[3] ^ gray_in[2] ^ gray_in[1];
        binary[0] = gray_in[3] ^ gray_in[2] ^ gray_in[1] ^ gray_in[0];
        case (binary)
            4'h0: expected = ~7'b0111111; // 0
            4'h1: expected = ~7'b0000110; // 1
            4'h2: expected = ~7'b1011011; // 2
            4'h3: expected = ~7'b1001111; // 3
            4'h4: expected = ~7'b1100110; // 4
            4'h5: expected = ~7'b1101101; // 5
            4'h6: expected = ~7'b1111101; // 6
            4'h7: expected = ~7'b0000111; // 7
            4'h8: expected = ~7'b1111111; // 8
            4'h9: expected = ~7'b1101111; // 9
            4'hA: expected = ~7'b1110111; // A
            4'hB: expected = ~7'b1111100; // B
            4'hC: expected = ~7'b0111001; // C
            4'hD: expected = ~7'b1011110; // D
            4'hE: expected = ~7'b1111001; // E
            4'hF: expected = ~7'b1110001; // F
            default: expected = 7'b1111111;
        endcase
    end


initial begin
    $monitor("gray_in = %b | expected = %b | segment = %b",
              gray_in, expected, segment);
end

endmodule