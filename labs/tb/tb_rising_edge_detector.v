module tb_edge_detectors;

reg clk;
reg rst;
reg in;
wire tick_mealy;
wire tick_moore;

rising_edge_detector_mealy u_mealy (
    .clk        (clk),
    .rst        (rst),
    .in         (in),
    .tick_mealy (tick_mealy)
);

rising_edge_detector_moore u_moore (
    .clk        (clk),
    .rst        (rst),
    .in         (in),
    .tick_moore (tick_moore)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    in  = 0;
    repeat (2) @(negedge clk);
    rst = 0;
    @(negedge clk);

    in = 1;
    repeat (3) @(negedge clk); //in is high for 3 cycles
    in = 0;
    repeat (2) @(negedge clk);//in is low for 2 cycles 
    in = 1;
    repeat (2) @(negedge clk);//in is high for 2 cycles
    in = 0;
    repeat (1) @(negedge clk);//in is low for 1 cycle
    in = 1;
    @(negedge clk);//in is high for 1 cycle
    in = 0;
    #50;
    $stop;
    end

initial 
    $monitor("Time=%3t ns | rst=%b | in=%b | tick_mealy=%b | tick_moore=%b", 
            $time, rst, in, tick_mealy, tick_moore);
    

endmodule