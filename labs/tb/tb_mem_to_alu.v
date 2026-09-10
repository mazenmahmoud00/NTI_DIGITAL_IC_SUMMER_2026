module tb_mem_to_alu ();

parameter ADDR        = 8;
parameter WIDTH       = 19;
parameter INPUT_WIDTH = 8;

reg                    i_clk;
reg                    i_rstn;
reg                    i_wr_en;
reg                    i_rd_en;
reg  [ADDR-1:0]        i_addr;
reg  [WIDTH-1:0]       i_din;
wire                   o_a_is_zero;
wire [INPUT_WIDTH-1:0] o_alu_out;

integer fail_count;

always #5 i_clk = ~i_clk;

mem_to_alu #(
    .ADDR(ADDR),
    .WIDTH(WIDTH),
    .INPUT_WIDTH(INPUT_WIDTH)
) dut (
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_wr_en(i_wr_en),
    .i_rd_en(i_rd_en),
    .i_addr(i_addr),
    .i_din(i_din),
    .o_a_is_zero(o_a_is_zero),
    .o_alu_out(o_alu_out)
);

task self_testing(
    input [ADDR-1:0] addr,
    input [2:0]      opcode,
    input [INPUT_WIDTH-1:0]      in_a,
    input [INPUT_WIDTH-1:0]      in_b);
    reg   [INPUT_WIDTH-1:0] expected_out;
    reg                     expected_a_is_zero;
begin
    //Golden model
    expected_a_is_zero = !in_a;

    case (opcode)
        3'b000:  
            expected_out = in_a + in_b;
        3'b001:  
            expected_out = in_a - in_b;
        3'b010:  
            expected_out = in_a & in_b;
        3'b011:  
            expected_out = in_a ^ in_b;
        3'b100:  
            expected_out = in_a | in_b;
        3'b101:  
            expected_out = in_a;
        default: 
            expected_out = 'b0;
    endcase
    
    //writing the {opcode , in_a , in_b} in the ram addr
    @(negedge i_clk);
    i_addr  = addr;
    i_din   = {opcode, in_a, in_b};
    i_wr_en = 1'b1;
    i_rd_en = 1'b0;
    @(negedge i_clk);
    i_wr_en = 1'b0;

    //reading the data from the addr
    @(negedge i_clk);
    i_addr  = addr;
    i_rd_en = 1'b1;
    @(negedge i_clk);
    i_rd_en = 1'b0;
 
    //shifting from ram to alu passing by piso & sipo
    // WIDTH cycles to come out of the piso & another cycle for it to come out of the sipo
    repeat(WIDTH+1) @(negedge i_clk);
    
    //Comparing with (Golden model)
    if (o_alu_out === expected_out && o_a_is_zero == expected_a_is_zero) 
        begin
        $display("\t\t\t\t[PASS (output = expected)]\nTime=%4t | o_alu_out=%0b (Expected=%0b) | a_is_zero=%0b (Expected=%0b)", 
                 $time, o_alu_out, expected_out, o_a_is_zero, expected_a_is_zero);
        $display("==============================================================================");
        end 
    else 
        begin
        fail_count = fail_count + 1;
        $display("\t\t\t\t[FAIL (output != expected)]\nTime=%4t | o_alu_out=%0b (Expected=%0b) | a_is_zero=%0b (Expected=%0b)", 
                 $time, o_alu_out, expected_out, o_a_is_zero, expected_a_is_zero);
        $display("==============================================================================");
        end
end
endtask

initial begin
    $display("\n\n====================================[STARTING]====================================");     
    i_clk   = 0;
    i_rstn  = 0;
    i_wr_en = 0;
    i_rd_en = 0;
    i_addr  = 0;
    i_din   = 0;
    fail_count = 0;

    repeat(3) @(negedge i_clk);
    i_rstn = 1;   
    repeat(2) @(negedge i_clk);
    
    //test case 1 (5 + 5 == 10) & writing in addr 0
    self_testing(7'd0, 3'b000, 8'd5, 8'd5);
    repeat(2) @(negedge i_clk);
    
    //test case 2 (8 - 3 == 5)  & writing in addr 1
    self_testing(7'd1, 3'b001, 8'd8, 8'd3);
    repeat(2) @(negedge i_clk);

    //test case 3 (10101010 & 0000_1111 == 0000_1010) & rewriting in addr 0
    self_testing(7'd0, 3'b010, 8'b10101010,  8'b0000_1111);
    repeat(2) @(negedge i_clk);

    //test case 4 (10101010 ^ 10101010 == 11111111) & rewriting in addr 1
    self_testing(7'd1, 3'b011, 8'b1010_1010, 8'b0101_0101);
    repeat(2) @(negedge i_clk);

    //test case 5 in_a = 0
    self_testing(7'd2, 3'b011, 8'b0, 8'b0);
    #50;
    
     $display("\t\t\t\t[Fail count = %0d]",fail_count);
     $display("====================================[FINISHED]====================================\n\n");     
    #50
    $finish;
end

initial begin
    $monitor("Time=%4t | rstn=%0b | wr_en=%0b | rd_en=%0b | addr=%0b | a_is_zero=%0b | alu_out=%0b", 
             $time, i_rstn, i_wr_en, i_rd_en, i_addr, o_a_is_zero, o_alu_out);
end

endmodule