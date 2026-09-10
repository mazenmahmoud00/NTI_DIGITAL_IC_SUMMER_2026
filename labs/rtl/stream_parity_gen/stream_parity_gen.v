module stream_parity_gen(
    input clk, rst, s_in, valid,
    output     parity_out
);

reg [7 : 0] last_8_bits;

function parity(input [7 : 0] last_8_bits_internal);
begin
parity = ^last_8_bits_internal;
end
endfunction

always@(posedge clk)
    if(rst)
        last_8_bits <= 8'b0;
    
    else 
        last_8_bits <= {last_8_bits [6 : 0] , s_in};

assign parity_out = valid ? parity(last_8_bits) : 1'b0;

endmodule

