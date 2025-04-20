module lpupf_TOP (A_TOP, B_TOP, P_TOP, Q_TOP, R_TOP, CARRY_TOP_TO_MOD_B, CARRY_TOP_TO_MOD_C, CARRY_TOP_TO_MOD_D, clk_upf, AB_XOR_TOP, AB_AND_TOP, XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP, XOR_from_mod_A_TOP, AND_from_mod_A_TOP, XOR_mod_B_A_TOP, AND_mod_B_A_TOP, S_from_mod_B_TOP, C_from_mod_B_TOP,ISO,Isola,Isolb,Isolc,Isold, Isole, ctrl_a, ctrl_b, ctrl_c, ctrl_d, ctrl_e, S_from_mod_C_TOP, C_from_mod_C_TOP);

	input logic A_TOP, B_TOP, P_TOP, Q_TOP, R_TOP;

	input logic CARRY_TOP_TO_MOD_B, CARRY_TOP_TO_MOD_C, CARRY_TOP_TO_MOD_D;

	input logic clk_upf;

	input logic ISO,Isola,Isolb,Isolc,Isold,Isole;

	output logic AB_XOR_TOP, AB_AND_TOP;

	output logic XOR_from_mod_A_TOP, AND_from_mod_A_TOP;

	output logic XOR_mod_B_A_TOP, AND_mod_B_A_TOP;

	output logic XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP;

	output logic S_from_mod_B_TOP, C_from_mod_B_TOP, S_from_mod_C_TOP, C_from_mod_C_TOP;

	logic S_to_mod_B, C_to_mod_B, XOR_to_mod_C, AND_to_mod_C;

	logic XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C;

	logic XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A;

	logic S_mod_C_to_mod_A, C_mod_C_to_mod_A, S_mod_D_to_mod_A, C_mod_D_to_mod_A;

	assign AB_XOR_TOP = A_TOP ^ B_TOP;
	assign AB_AND_TOP = A_TOP & B_TOP;

	input logic ctrl_a, ctrl_b, ctrl_c, ctrl_d, ctrl_e;

    module_A module_A_inst (P_TOP, Q_TOP, R_TOP, S_to_mod_B, C_to_mod_B, XOR_to_mod_C, AND_to_mod_C,  S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_from_mod_A_TOP, AND_from_mod_A_TOP, XOR_mod_B_A_TOP, AND_mod_B_A_TOP, clk_upf);
//               module module_A (P,     Q,     R   ,  S_to_mod_B, C_to_mod_B, XOR_to_mod_C, AND_to_mod_C,  S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_from_mod_A_TOP, AND_from_mod_A_TOP, XOR_mod_B_A_TOP, AND_mod_B_A_TOP, clk_upf);

    module_B module_B_inst (S_to_mod_B, C_to_mod_B, CARRY_TOP_TO_MOD_B, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, /*XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B,*/ XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP, S_from_mod_B_TOP, C_from_mod_B_TOP, clk_upf, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C);
//              module module_B (S_to_mod_B, C_to_mod_B, CARRY_TOP_TO_MOD_B, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP, S_from_mod_B_TOP, C_from_mod_B_TOP, clk_upf);

    module_C module_C_inst (XOR_to_mod_C, AND_to_mod_C, CARRY_TOP_TO_MOD_C, S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, clk_upf);
//             module module_C (XOR_to_mod_C, AND_to_mod_C, CARRY_TOP_TO_MOD_C, S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, clk_upf);

	module_D module_D_inst (XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, CARRY_TOP_TO_MOD_D, S_to_mod_B, C_to_mod_B, S_from_mod_C_TOP, C_from_mod_C_TOP, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C, clk_upf);

endmodule


module module_A (P, Q, R, S_to_mod_B, C_to_mod_B, XOR_to_mod_C, AND_to_mod_C,  S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_from_mod_A_TOP, AND_from_mod_A_TOP, XOR_mod_B_A_TOP, AND_mod_B_A_TOP, clk_upf);

	input logic P, Q, R, clk_upf;

	output logic S_to_mod_B, C_to_mod_B, XOR_to_mod_C, AND_to_mod_C;

	input logic S_mod_C_to_mod_A, C_mod_C_to_mod_A;

	input logic XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A;

	output logic XOR_from_mod_A_TOP, AND_from_mod_A_TOP;

	output logic XOR_mod_B_A_TOP, AND_mod_B_A_TOP;

	logic P_bar, Q_bar;

	One_Bit_FA_SUB_SUB One_Bit_FA_mod_A (P, Q, R, S_to_mod_B, C_to_mod_B, clk_upf);

	assign P_bar = ~ P;
	assign Q_bar = ~ Q;

	XOR_AND_SUB_SUB_MODULE XOR_AND_1st_SUB_SUB_MODULE_mod_A (P_bar, Q_bar, XOR_to_mod_C, AND_to_mod_C);
	XOR_AND_SUB_SUB_MODULE XOR_AND_2nd_SUB_SUB_MODULE_mod_A (XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_mod_B_A_TOP, AND_mod_B_A_TOP);
	XOR_AND_SUB_SUB_MODULE XOR_AND_3rd_SUB_SUB_MODULE_mod_A (S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_from_mod_A_TOP, AND_from_mod_A_TOP);

endmodule


module module_B (S_to_mod_B, C_to_mod_B, CARRY_TOP_TO_MOD_B, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A, XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP, S_from_mod_B_TOP, C_from_mod_B_TOP, clk_upf, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C);


	input logic S_to_mod_B, C_to_mod_B, CARRY_TOP_TO_MOD_B, clk_upf;
	
	output logic XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A; 

	output logic S_from_mod_B_TOP, C_from_mod_B_TOP;

	input logic /*XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B,*/ XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C;
	output logic XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP;

	//logic S_to_mod_B, C_to_mod_B;
	logic S_to_mod_B_bar, C_to_mod_B_bar;
	
	assign S_to_mod_B_bar = ~S_to_mod_B;
	assign C_to_mod_B_bar = ~C_to_mod_B;

	One_Bit_FA_SUB_SUB One_Bit_FA_mod_B (S_to_mod_B, C_to_mod_B, CARRY_TOP_TO_MOD_B,  S_from_mod_B_TOP, C_from_mod_B_TOP, clk_upf);

	XOR_AND_SUB_SUB_MODULE XOR_AND_1st_SUB_SUB_MODULE_mod_B (S_to_mod_B_bar, C_to_mod_B_bar, XOR_from_mod_B_to_mod_A, AND_from_mod_B_to_mod_A);
	XOR_AND_SUB_SUB_MODULE XOR_AND_2nd_SUB_SUB_MODULE_mod_B (XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C, XOR_from_mod_C_B_OUT_TOP, AND_from_mod_C_B_OUT_TOP);

endmodule

module module_C (XOR_to_mod_C, AND_to_mod_C, CARRY_TOP_TO_MOD_C, S_mod_C_to_mod_A, C_mod_C_to_mod_A, XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, clk_upf);

	input logic XOR_to_mod_C, AND_to_mod_C, CARRY_TOP_TO_MOD_C, clk_upf;
	
	output logic S_mod_C_to_mod_A, C_mod_C_to_mod_A;
	
	output logic XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B;

	logic XOR_to_mod_C_bar, AND_to_mod_C_bar;

	assign XOR_to_mod_C_bar = ~XOR_to_mod_C;
	assign AND_to_mod_C_bar = ~AND_to_mod_C;

	One_Bit_FA_SUB_SUB One_Bit_FA_mod_C (XOR_to_mod_C, AND_to_mod_C, CARRY_TOP_TO_MOD_C, S_mod_C_to_mod_A, C_mod_C_to_mod_A, clk_upf);

	XOR_AND_SUB_SUB_MODULE XOR_AND_1st_SUB_SUB_MODULE_mod_C (XOR_to_mod_C_bar, AND_to_mod_C_bar, XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B);

endmodule

module module_D (XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, CARRY_TOP_TO_MOD_D, S_to_mod_B, C_to_mod_B, S_from_mod_C_TOP, C_from_mod_C_TOP, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C, clk_upf);

	input logic XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, CARRY_TOP_TO_MOD_D, clk_upf/*, S_mod_D_to_mod_A, C_mod_D_to_mod_A*/;
	
	output logic S_to_mod_B, C_to_mod_B;
	output logic S_from_mod_C_TOP, C_from_mod_C_TOP;
	
	output logic XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C;

	logic XOR_mod_C_to_mod_B_bar, AND_mod_C_to_mod_B_bar;

	assign XOR_mod_C_to_mod_B_bar = ~XOR_mod_C_to_mod_B;
	assign AND_mod_C_to_mod_B_bar = ~AND_mod_C_to_mod_B;
	
	XOR_AND_SUB_SUB_MODULE XOR_AND_1st_SUB_SUB_MODULE_mod_D (XOR_mod_C_to_mod_B_bar, AND_mod_C_to_mod_B_bar, XOR_mod_D_to_mod_C, AND_mod_D_to_mod_C);

	One_Bit_FA_SUB_SUB One_Bit_FA_mod_D (XOR_mod_C_to_mod_B, AND_mod_C_to_mod_B, CARRY_TOP_TO_MOD_D, S_to_mod_B, C_to_mod_B, clk_upf);

	XOR_AND_SUB_SUB_MODULE XOR_AND_2nd_SUB_SUB_MODULE_mod_D (S_to_mod_B, C_to_mod_B, S_from_mod_C_TOP, C_from_mod_C_TOP);

endmodule

module One_Bit_FA_SUB_SUB (A, B, Carry_in, Sum_out, Carry_out, Clk  );

	input  logic A, B;
	output logic Sum_out;
	input  logic Carry_in, Clk;
	output logic Carry_out;
	logic  Sum_comb, Carry_comb;
	

	// Syntax for the module instantiation:
	// cell_name instance_name(.port_name_from_module(port_name_at_instance_level), .....

	OneBit_Adder Fist_Adder  ( .a(A), .b(B), .cin(Carry_in),      .sum(Sum_comb), .cout(Carry_comb) ) ;

	always_latch
	        if (Clk)
	        begin
	        Sum_out      <= Sum_comb;
	        Carry_out    <= Carry_comb;
	        end

	endmodule

	module OneBit_Adder (a, b, cin, sum, cout);

        	input logic a, b, cin;
        	output logic   cout, sum;

        	assign sum  = a ^ b ^ cin;
        	assign cout = (a & b) | (b & cin) | (cin & a);

	endmodule


module XOR_AND_SUB_SUB_MODULE (A_SUB_SUB, B_SUB_SUB, AB_XOR_SUB_SUB, AB_AND_SUB_SUB);

	input logic A_SUB_SUB, B_SUB_SUB;
	output logic  AB_XOR_SUB_SUB, AB_AND_SUB_SUB;

	assign AB_XOR_SUB_SUB = A_SUB_SUB ^ B_SUB_SUB;
	assign AB_AND_SUB_SUB = A_SUB_SUB & B_SUB_SUB;

endmodule
