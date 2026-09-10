module sipo #(
    parameter WIDTH = 19
)(
    input                clk, rstn, shift_en, serial_in,
    output reg [WIDTH-1:0] parallel_out,
    output reg           valid
); 

localparam N = $clog2(WIDTH+1);
reg [N-1:0] count;

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        begin
        parallel_out <= 'b0;
        count        <= 'b0;
        valid        <= 1'b0;
        end

    else if (shift_en)
        begin
        parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
        
        if (count == WIDTH - 1) 
            begin
            count <= 'b0;
            valid <= 1'b1;
            end

        else 
            begin
            count <= count + 1'b1;
            valid <= 1'b0;
            end
        end

    else 
        valid <= 1'b0;
end

endmodule