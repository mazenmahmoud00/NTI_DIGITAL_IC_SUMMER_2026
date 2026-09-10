module FA_behavioral (input a,b,cin, output reg sum,cout);

reg [1:0] temp;

always@(*)  {cout , sum} = a + b + cin ;
    
endmodule