module rising_edge_detector_mealy    
( 
    input clk, rst, in,
    output reg tick_mealy
);

localparam S0  = 1'b0,
           S1  = 1'b1;

reg next_state;
reg current_state;

//state register
always@(posedge clk or posedge rst)
    if(rst)
        current_state<=S0;   
    else
        current_state<=next_state;

//next state logic    	
always@(*)
    begin
    next_state=S0;
    case(current_state)
        S0, S1 :
            if(in) 
                next_state=S1;
    endcase
    end

//output logic
always @(*) 
    tick_mealy = (current_state == S0) && in;

endmodule