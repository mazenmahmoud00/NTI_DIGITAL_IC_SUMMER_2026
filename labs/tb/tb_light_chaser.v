module tb_light_chaser ();

reg clk, rstn, hold;
wire [9:0] reg_out;

light_chaser dut (
    .clk(clk),
    .rstn(rstn),
    .hold(hold),
    .reg_out(reg_out)
);

always #5 clk = ~clk;

initial begin
    $display(" Time  | rstn | hold | clk_out | reg_out");
    $monitor("%6t |   %b  |  %b   |    %b    | %b",
             $time, rstn, hold, dut.clk_out, reg_out);

    clk = 0;
    rstn = 0;
    hold = 0;

    @(negedge clk);
    rstn = 1;

    repeat (2) @(negedge dut.clk_out);
    hold = 1;
    repeat (5) @(negedge dut.clk_out);
    hold = 0;
    repeat (3) @(negedge dut.clk_out);
    hold = 1;
    repeat (5) @(negedge dut.clk_out);

    repeat (2) @(negedge dut.clk_out);
    $finish;
end

endmodule