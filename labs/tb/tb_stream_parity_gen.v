module tb_stream_parity_gen ();

reg  clk, rst, s_in, valid;
wire parity_out;

stream_parity_gen dut (
    .clk(clk),
    .valid(valid),
    .rst(rst),
    .s_in(s_in),
    .parity_out(parity_out)
);

always #5 clk = ~clk;
integer error_count = 0;
reg expected;

task test_parity_gen;
integer i, j;
begin
    for (i = 0; i < 256; i = i + 1) 
        begin
        for (j = 7; j >= 0; j = j - 1) 
            begin
            s_in = i[j];
            @(negedge clk);
            end

        expected = ^i[7:0];

        if (parity_out == expected) 
            $display("[PASS] for [combination %3d = %b, parity_out: %b]",
                        i, i[7:0], parity_out);
        else 
            begin
            $display("[FAIL] for [combination %3d = %b, parity_out: %b, expected: %b]",
                    i, i[7:0], parity_out, expected);
            error_count = error_count + 1;
            end
        end
end
endtask

initial 
begin
    $display("\n[************************START************************]");
    clk = 0;
    s_in = 0;
    valid = 0;
    expected = 0;
    rst = 1;
    @(negedge clk);
    rst = 0;
    valid = 1;
    @(negedge clk); 
    test_parity_gen;

    if (error_count == 0) 
        $display("************************[PASSED SUCCESSFULLY]************************\n");
    else 
        $display("************************[FAILED with %0d errors]************************\n",
        error_count);
    
    @(negedge clk);
    $stop;
end

endmodule