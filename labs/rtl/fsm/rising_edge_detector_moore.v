module rising_edge_detector_moore  
( 
    input clk, rst, in,
    output reg tick_moore
);

localparam S0  = 2'b00,
           S1  = 2'b01,
           S2  = 2'b10; // TICK

reg [1:0] next_state;
reg [1:0] current_state;

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
        S0 :
            if(in) 
                next_state=S2;
        S1 :
            if(in) 
                next_state=S1;
        S2 :
            if(in) 
                next_state=S1;
    endcase
    end

//output logic
always @(*) 
    tick_moore = (current_state == S2);

endmodule