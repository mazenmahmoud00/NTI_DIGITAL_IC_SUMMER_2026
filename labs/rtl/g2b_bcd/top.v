module top #(
    parameter WIDTH = 4
)(
    input   [WIDTH-1 : 0] gray_in,
    output  [6:0]         segment
);

wire [WIDTH-1 : 0] binary;

g2b #(WIDTH) g2b_inst (gray_in, binary);

binary_to_hex_7segment binary_to_hex_7segment_inst (binary, segment);


endmodule