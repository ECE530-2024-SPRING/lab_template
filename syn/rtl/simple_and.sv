// A simple AND gate

module simple_and (ain, bin, and_out,clock,reset );

input ain, bin,clock,reset ;

output and_out;

wire  a_reg;

wire  b_reg;

wire  and_reg;

dff dff_a (

	.d (ain),
 	.clk (clock),
	.reset (reset),
	.q (a_reg)
	);

dff dff_b (

	.d (bin),
 	.clk (clock),
	.reset (reset),
	.q (b_reg)

	);

// AND = a & b 
assign and_reg = (a_reg & b_reg);

dff dff_and_out (

	.d (and_reg),
 	.clk (clock),
	.reset (reset),
	.q (and_out)

	);

endmodule

// dff definition

module dff (d, clk, reset, q);
input d, clk, reset;
output q;
reg q;
always @ (posedge clk or posedge reset) begin
 if (reset) begin
 q <= 0;
 end
 else begin
 q <= d;
 end
end
endmodule

