module four_bit_edge_counter #(
    parameter WIDTH = 4
)(
    input clk, rst, tick_in,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or posedge rst)
    if (rst) 
        count <='b0;
    else if (tick_in) 
        count <= count + 1;
    
endmodule