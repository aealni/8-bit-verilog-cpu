`include "../common/defines.vh"

module alu(
	input			[7:0] src1,		// value from first source reg
	input 		[7:0] src2, 	// recieves 8 bit vals from registers
	input			[1:0] imm2,		// 2 bit immediate value from control unit
	input 				imm_sel, // 1 = use imm2, 0 = use src2
	input			[1:0] alu_op, 	// 00 ADD, 01 SUB, 10 NAND, 11 NULL
	output reg 	[7:0] result,
	output reg			zero_flag
);

wire [7:0] operand2;

// zext imm2 to 8 bits or use src2 input
assign operand2 = imm_sel ? {6'b000000, imm2} : src2;	// assign sr2 val or zext imm2

always@(*) begin
	case (alu_op)
		`ALU_ADD: 	result = src1 + operand2;
		`ALU_SUB: 	result = src1 - operand2;
		`ALU_NAND: 	result = ~(src1 & operand2);
		`ALU_NULL:	result = 8'd0;
		default: result = 8'd0;
	endcase
	
	if (alu_op !== `ALU_NULL)
		zero_flag = (result == 8'd0);
end

endmodule