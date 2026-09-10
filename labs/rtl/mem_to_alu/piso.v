module piso #(
    parameter WIDTH = 19
)(
    input             clk, rst_n, en,
    input [WIDTH-1:0] parallel_in,
    output reg        valid,
    output reg        serial_out
);

localparam N = $clog2(WIDTH+1);

reg [WIDTH-1:0] store;
reg [N-1:0]     count;

always @(posedge clk or negedge rst_n)

    if (!rst_n) 
        begin
        store      <=  'b0;
        serial_out <= 1'b0;
        valid      <= 1'b0;
        count      <=  'b0;
        end

    else if (en && !valid) 
        begin
        valid      <= 1'b1;
        store      <= {parallel_in[WIDTH-2:0],1'b0};
        serial_out <= parallel_in[WIDTH-1];
        count      <= 1'b1;
        end
        
    else if (valid && (count != WIDTH)) 
        begin
        store      <= {store[WIDTH-2:0],1'b0};
        serial_out <= store[WIDTH-1];
        count      <= count + 1'b1;
        end
    else 
        begin
        serial_out <= 1'b0;
        valid      <= 1'b0;
        count      <=  'b0;
        end

    
endmodule