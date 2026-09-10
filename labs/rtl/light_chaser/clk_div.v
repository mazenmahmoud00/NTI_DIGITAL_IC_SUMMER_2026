module clk_div #(
    parameter DIV_RATIO = 8
)
(
    input clk_in, rstn,
    output reg clk_out
);

localparam COUNTER_THRESHOLD = (DIV_RATIO / 2) - 1;
localparam COUNTER_WIDTH = $clog2(COUNTER_THRESHOLD+1);

reg [COUNTER_WIDTH-1 : 0] counter;

always @(posedge clk_in or negedge rstn) 

    if (!rstn) 
        begin
        counter <= 0;
        clk_out <= 0;
        end
    else if (counter < COUNTER_THRESHOLD) 
        counter <= counter + 1;
    else  
        begin
        clk_out <= ~clk_out;
        counter <= 0;
        end  

endmodule
