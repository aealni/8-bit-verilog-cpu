`include "../common/defines.vh"

module control_unit(
	input clk,
   input reset,
   input [7:0] instruction,	// instruction to extract data from
   input zero_flag,				// from alu
	input [4:0] pc,				// from pc
   output reg pc_write,			// pc write enable
   output reg pc_src,			// decide pc next source (0 for PC+1, 1 for jmp addr) (mux input)
   output reg ir_write,			// ir write enable
   output reg reg_write,		// register write enable
	output reg reg_src,			// register write data source (ALU or RAM)
	output reg [1:0] reg_dest,	// destination register (R0 for LOAD/STORE, src1 for ALU ops)
   output reg [1:0] alu_op,	// alu operation
   output reg [1:0] alu_src1,	// alu operand 1 register, sent to reg_file, also used for STORE to send R0 to RAM
   output reg [1:0] alu_src2,	// alu operand 2 reg if imm_sel = 0
   output reg imm_sel,			// 0 for register, 1 for imm2 for alu src2 (mux input, implicit in ALU)
   output reg mem_read,			// ram read enable
   output reg mem_write,		// ram write enable
   output reg mem_addr_src		// select PC (0) or IR[4:0] for ram access) (mux input)
);
	
parameter FETCH	= 3'd0;
parameter DECODE	= 3'd1;
parameter EXECUTE	= 3'd2;
parameter MEM		= 3'd3;
parameter WRITEBK	= 3'd4;
parameter HALT		= 3'd5;

reg [2:0] state, next_state;	// store state and next state

wire [2:0] opcode = instruction[7:5];
wire 		  immsel	= instruction[4];		// decide whether to use zero extended imm2
wire [1:0] src1	= instruction[3:2];	// also destination reg for alu ops
wire [1:0] src2 	= instruction[1:0];	// if imm_sel = 1

always @(posedge clk or posedge reset) begin
	if (reset)
		state <= FETCH;
	else
		state <= next_state;
end

// control signal and next state logic
always @(*) begin
	// default values
	pc_write			= 0;
	pc_src			= 0;
	ir_write			= 0;
	reg_write		= 0;
	reg_src			= `REG_SRC_ALU;
	reg_dest			= 0;
	alu_op			= `ALU_NULL;
	alu_src1			= 0;
	alu_src2			= 0;
	imm_sel			= 0;
	mem_read			= 0;
	mem_write		= 0;
	mem_addr_src	= 0;
	next_state = FETCH;
	
	case (state)
		FETCH: begin // fetch instruction based on pc and increment pc
			mem_read = 1;
			mem_addr_src = `MEM_ADDR_PC;
			ir_write = 1;
			pc_write = 1;
			pc_src = `PC_SRC_INC;
			next_state = DECODE;
		end
		
		DECODE: begin
			case (opcode)
					`OPCODE_HALT:	next_state = HALT;
					`OPCODE_LOAD,
					`OPCODE_STORE:	next_state = MEM;
					`OPCODE_ADD,
					`OPCODE_SUB,
					`OPCODE_NAND,
					`OPCODE_JZ,
					`OPCODE_JMP: 	next_state = EXECUTE;
					default:			next_state = HALT;	// for illegal opcodes
			endcase
		end
		
		EXECUTE: begin
			case (opcode)
				`OPCODE_ADD: begin
					alu_op = `ALU_ADD;
					alu_src1 = src1;
					alu_src2 = src2;
					imm_sel = immsel;
					next_state = WRITEBK;
				end
				`OPCODE_SUB: begin
					alu_op = `ALU_SUB;
					alu_src1 = src1;
					alu_src2 = src2;
					imm_sel = immsel;
					next_state = WRITEBK;
				end
				`OPCODE_NAND: begin
					alu_op = `ALU_NAND;
					alu_src1 = src1;
					alu_src2 = src2;
					imm_sel = immsel;
					next_state = WRITEBK;
				end
				`OPCODE_JMP: begin
					pc_write = 1;
					pc_src = `PC_SRC_JUMP;
					next_state = (pc == 5'd31) ? HALT : FETCH;
				end
				`OPCODE_JZ: begin
					if (zero_flag) begin
						pc_write = 1;
						pc_src = `PC_SRC_JUMP;
				end
				next_state = (pc == 5'd31) ? HALT : FETCH;
				end
				default:			next_state = HALT;
			endcase
		end
		
		MEM: begin
			case (opcode)
				`OPCODE_LOAD: begin
					mem_read = 1;
					mem_addr_src = `MEM_ADDR_IR;
					next_state = WRITEBK;
				end
				`OPCODE_STORE: begin
					alu_src1 = 2'd0;
					mem_write = 1;
					mem_addr_src = `MEM_ADDR_IR;
				next_state = (pc == 5'd31) ? HALT : FETCH;
				end
				default: next_state = HALT;
			endcase
		end
		
		WRITEBK: begin
			case (opcode)
				`OPCODE_ADD,
				`OPCODE_SUB,
				`OPCODE_NAND: begin
					reg_write = 1;
					reg_src = `REG_SRC_ALU;
					reg_dest = src1;
					next_state = (pc == 5'd31) ? HALT : FETCH;
				end
				`OPCODE_LOAD: begin
					reg_write = 1;
					reg_src = `REG_SRC_RAM;
					reg_dest = 0;
					next_state = (pc == 5'd31) ? HALT : FETCH;
				end
				default:			next_state = HALT;
			endcase
		end
		
		HALT: begin
			next_state = HALT; // remain in halt
		end
	endcase
end

endmodule
