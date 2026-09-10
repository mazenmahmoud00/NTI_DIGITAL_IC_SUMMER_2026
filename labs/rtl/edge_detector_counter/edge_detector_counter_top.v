module edge_detector_counter_top (
    input clk, rst, in,
    output [6:0] segments
);


wire clk_div;
wire tick_mealy;
wire [3:0] count;

clk_div #( 
    .DIV_RATIO(8)
)clk_div_inst (
    .clk_in(clk),
    .rst(rst),
    .clk_out(clk_div)
);

rising_edge_detector_mealy rising_edge_detector_mealy_inst (
    .clk(clk_div),
    .rst(rst),
    .in(in),
    .tick_mealy(tick_mealy)
);  

four_bit_edge_counter  #(
    .WIDTH(4)
)four_bit_edge_counter_inst(
    .clk(clk_div),
    .rst(rst),
    .tick_in(tick_mealy),
    .count(count)
);

binary_to_hex_7segment binary_to_hex_7segment_inst(
    .sel(count),
    .segments(segments)
);

endmodule