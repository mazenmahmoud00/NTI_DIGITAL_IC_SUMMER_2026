module half_adder (input a,b, output sum,cout);

xor (sum,a,b);
and (cout,a,b);

endmodule


module FA_structural(input a,b,cin, output sum,cout);

half_adder half_adder_1(a,b,sum_1,cout1);
half_adder half_adder_2(sum_1,cin,sum,cout2);
or (cout,cout1,cout2);

endmodule