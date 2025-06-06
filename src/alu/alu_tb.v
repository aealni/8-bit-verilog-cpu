`timescale 1ns/1ps
`include "../common/defines.vh"

module alu_tb;

reg	[7:0]	src1;
reg	[7:0]	src2;
reg	[1:0]	imm2;
reg			imm_sel;
reg	[1:0]	alu_op;
wire	[7:0]	result;
wire			zero_flag;

alu uut(
	.src1(src1),
	.src2(src2),
	.imm2(imm2),
	.imm_sel(imm_sel),
	.alu_op(alu_op),
	.result(result),
	.zero_flag(zero_flag)
);

initial begin
	$display("Starting ALU test");
	
	// case 1: simple src add
	src1 = 8'd10;
   src2 = 8'd5;
   imm2 = 2'b00;
   imm_sel = 0;
   alu_op = `ALU_ADD;
   #10;
	if (result !== 8'd15)
		$error("incorrect calc 1");
	if (zero_flag == 1)
		$error("incorrect zero flag 1");
	
	// case 2: simple src sub
	alu_op = `ALU_SUB;
   #10;
	if (result !== 8'd5)
		$error("incorrect calc 2");
	if (zero_flag == 1)
		$error("incorrect zero flag 2");
	
	// case 3: NAND register input
	src1 = 8'b11111111;
   src2 = 8'b10101010;
   imm2 = 2'b00;
   imm_sel = 0;
   alu_op = `ALU_NAND;
	#10;
	if (result !== 8'b01010101)
		$error("incorrect nand 3");
	if (zero_flag == 1)
		$error("incorrect zero flag 3");
	
	// case 4: ADD imm2
	src1 = 8'd0;
   src2 = 8'd0;
   imm2 = 2'b11;
   imm_sel = 1;
   alu_op = `ALU_ADD;
	#10;
	if (result !== 8'd3)
		$error("incorrect calc 4");
	if (zero_flag == 1)
		$error("incorrect zero flag 4");
	
	// case 5: SUB imm2
	src1 = 8'd5;
   src2 = 8'd0;
   imm2 = 2'b11;
   imm_sel = 1;
   alu_op = `ALU_SUB;
	#10;
	if (result !== 8'd2)
		$error("incorrect calc 5");
	if (zero_flag == 1)
		$error("incorrect zero flag 5");
		
	// case 6: zero flag
	src1 = 8'd0;
   src2 = 8'd0;
   imm2 = 2'b00;
   imm_sel = 0;
   alu_op = `ALU_ADD;
   #10;
	if (result !== 8'd0)
		$error("incorrect calc 6");
	if (zero_flag == 0)
		$error("incorrect zero flag 6");
		
	$display("Test finished");
	end
endmodule