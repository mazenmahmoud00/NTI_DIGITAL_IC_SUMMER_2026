module ram#(
    parameter ADDR =  8, parameter WIDTH = 19 
)(
    input clk, rstn, wr_en, rd_en, 
    input  [ADDR-1  : 0] addr,
    input  [WIDTH-1 : 0] din,
    output reg [WIDTH-1 : 0] dout,
    output reg valid
);

localparam DEPTH = 2**ADDR;
reg [WIDTH-1 : 0] memory [0 : DEPTH-1];

//This ram can read & write simultenously if wr_en & rd_en are both high with the same priority
//If so the dout will be the old value not the new updated by din
always@(posedge clk or negedge rstn)

    if(!rstn) 
        begin
        dout <= 0;
	    valid <= 0;
        end
    else 
        begin 
        valid <= 0;

        if(wr_en)
	        memory[addr] <= din;

        if(rd_en)
	        begin
            dout <= memory[addr];
	        valid <= 1;
	        end
        end

endmodule