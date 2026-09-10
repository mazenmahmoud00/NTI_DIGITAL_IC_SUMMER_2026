module g2b #(
    parameter WIDTH = 4
)(
    input   [WIDTH-1 : 0] gray_in,
    output  [WIDTH-1 : 0] binary
);

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1)   
        assign binary[i] = ^gray_in[WIDTH-1:i];
endgenerate

endmodule