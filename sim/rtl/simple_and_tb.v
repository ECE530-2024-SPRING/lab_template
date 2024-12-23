`timescale 1ns/1ns
module top();

reg ain, bin ,reset;
reg clock=1'b0;
wire and_out;

simple_and a_b_and(ain, bin, and_out, clock, reset );

always #5 clock = ~clock;

initial begin
#4 ain = 1'b0; bin = 1'b0; reset = 1'b1;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b1;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b1; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;

#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b0;

#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;
#4 ain = 1'b0; bin = 1'b0; reset = 1'b0;

#4 ain = 1'b1; bin = 1'b1; reset = 1'b1;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b1;
#4 ain = 1'b1; bin = 1'b1; reset = 1'b1;

#20 $stop;
end

initial begin
 $monitor("t=%3d ain=%d,bin=%d,reset=%d,and_out=%d,\n",$time,ain,bin,reset,and_out);
end

endmodule
