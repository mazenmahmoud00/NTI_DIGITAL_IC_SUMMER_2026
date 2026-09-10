module light_chaser(
    input clk, rstn, hold,
    output reg [9:0] reg_out
);

wire clk_out;

clk_div #(.DIV_RATIO(8)) clk_div_inst (
    .clk_in(clk),
    .rstn(rstn),
    .clk_out(clk_out)
);

always@(posedge clk_out or negedge rstn) 
    if(!rstn) 
        reg_out <= 10'b1000000000;
    else if(!hold) 
        reg_out <= reg_out;
    else 
        reg_out <= {reg_out[0], reg_out[9:1]};    

endmodule