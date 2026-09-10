module tb_edge_detector_counter_top;

reg clk;
reg rst;
reg in;
wire [6:0] segments;

edge_detector_counter_top dut (
    .clk      (clk),
    .rst      (rst),
    .in       (in),
    .segments (segments)
);

always #5 dut.clk_div_inst.clk_out = ~dut.clk_div_inst.clk_out;

initial begin
    dut.clk_div_inst.clk_out = 0;
    rst = 1;
    in  = 0;
    repeat (2) @(negedge dut.clk_div_inst.clk_out);
    rst = 0;
    @(negedge dut.clk_div_inst.clk_out);

    in = 1;
    repeat (3) @(negedge dut.clk_div_inst.clk_out); // in is high for 3 cycles
    in = 0;
    repeat (2) @(negedge dut.clk_div_inst.clk_out); // in is low for 2 cycles
    in = 1;
    repeat (2) @(negedge dut.clk_div_inst.clk_out); // in is high for 2 cycles
    in = 0;
    repeat (1) @(negedge dut.clk_div_inst.clk_out); // in is low for 1 cycle
    in = 1;
    @(negedge dut.clk_div_inst.clk_out);            // in is high for 1 cycle
    in = 0;
    #50;
    $stop;
end
 
initial 
    $monitor("Time=%3t ns | rst=%b | in=%b | clk_div=%b | tick_mealy=%b | count=%b | segments=%b", 
            $time, rst, in, dut.clk_div_inst.clk_out, dut.tick_mealy, dut.count, segments);
endmodule