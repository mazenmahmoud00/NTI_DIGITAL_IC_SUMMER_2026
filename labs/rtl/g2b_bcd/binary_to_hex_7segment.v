module binary_to_hex_7segment (
    input [3:0] sel,
    output reg [6:0] segment
);
    always @(*) 
    begin
        case (sel) //active low segments
            4'h0: segment = ~7'b0111111; // 0
            4'h1: segment = ~7'b0000110; // 1
            4'h2: segment = ~7'b1011011; // 2
            4'h3: segment = ~7'b1001111; // 3
            4'h4: segment = ~7'b1100110; // 4
            4'h5: segment = ~7'b1101101; // 5
            4'h6: segment = ~7'b1111101; // 6
            4'h7: segment = ~7'b0000111; // 7
            4'h8: segment = ~7'b1111111; // 8
            4'h9: segment = ~7'b1101111; // 9
            4'hA: segment = ~7'b1110111; // A
            4'hB: segment = ~7'b1111100; // B
            4'hC: segment = ~7'b0111001; // C
            4'hD: segment = ~7'b1011110; // D
            4'hE: segment = ~7'b1111001; // E
            4'hF: segment = ~7'b1110001; // F
            default: segment = 7'b1111111;
        endcase
    end
endmodule