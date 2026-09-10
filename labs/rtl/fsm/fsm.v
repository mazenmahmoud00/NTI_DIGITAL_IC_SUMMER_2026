module top_module 
( 
    input clk, rst, a, b
    output reg y0,y1 
);

localparam S0  = 2'b00,
           S1  = 2'b01,
           S2  = 2'b10;

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
            if(!a) 
                next_state=S0;
            else if(a&b) 
                next_state=S2;
            else 
                next_state=S1;
        S1 :
            if(a) 
                next_state=S0;
            else
                next_state=S1;
        S2 :
                next_state=S0;

        default :
                next_state=S0; 
        
    endcase
    end

//output logic
// assign y0 = (current_state==S0) || (current_state==S1);
// assign y1 = (current_state==S0) && (a&&b);

//output logic
// always @(*) 
//     begin 
//     y1 = (current_state == S0) || (current_state == S1);
//     y0 = (current_state == S0) && (a && b);
//     end

//output logic
always @ (*) 
    begin 
    if ((current_state == S0) || (current_state == S1))
        y1 = 1'b1;
    else 
        y1 = 1'b0;

    if ((current_state == S0) && (a&&b))
        y0 = 1'b1;
    else 
        y0 = 1'b0;
    end
    
endmodule

