`include "../common/defines.vh"
`timescale 1ns/1ps

module cu_tb;

reg clk;
reg reset;
reg [7:0] instruction;
reg zero_flag;
reg [4:0] pc;
wire pc_write;
wire pc_src;
wire ir_write;
wire reg_write;
wire reg_src;
wire [1:0] reg_dest;
wire [1:0] alu_op;
wire [1:0] alu_src1;
wire [1:0] alu_src2;
wire imm_sel;
wire mem_read;
wire mem_write;
wire mem_addr_src;

// instantiate
control_unit uut (
.clk(clk),
.reset(reset),
.instruction(instruction),
.zero_flag(zero_flag),
.pc(pc),
.pc_write(pc_write),
.pc_src(pc_src),
.ir_write(ir_write),
.reg_write(reg_write),
.reg_src(reg_src),
.reg_dest(reg_dest),
.alu_op(alu_op),
.alu_src1(alu_src1),
.alu_src2(alu_src2),
.imm_sel(imm_sel),
.mem_read(mem_read),
.mem_write(mem_write),
.mem_addr_src(mem_addr_src)
);

// clock generation
always #5 clk = ~clk; // 10 ns period

// display current control signals
task print_state; begin
	$display("Time: %0t | State Outputs => PCW:%b PSRC:%b IRW:%b REGW:%b RSRC:%b RDEST:%b ALU_OP:%b ALU_S1:%b ALU_S2:%b IMM:%b MEMR:%b MEMW:%b MEM_A:%b",
	$time, pc_write, pc_src, ir_write, reg_write, reg_src, reg_dest, alu_op, alu_src1, alu_src2, imm_sel, mem_read, mem_write, mem_addr_src);
end
endtask

initial begin
	$display("start control unit tb");
	clk = 0;
	reset = 1;
	instruction = 8'b000_00000; // NOP
	zero_flag = 0;
	pc = 0;

	#10 reset = 0;

	// case 1: ADD R1, R2 (src1 = R1, src2 = R2)
	$display("case 1 begin, ADD R1, R2 (src1 = R1, src2 = R2)");
	instruction = {`OPCODE_ADD, 1'b0, 2'b01, 2'b10}; // opcode=000
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	#10; print_state(); // WRITEBK
	#10; print_state(); // FETCH

	// case 2: LOAD [addr] -> R0
	$display("case 2 begin, LOAD [addr] -> R0");
	instruction = {`OPCODE_LOAD, 5'b00100}; // opcode=011, addr = 0b00100
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // MEM
	#10; print_state(); // WRITEBK
	#10; print_state(); // FETCH

	// case 3: STORE R2 -> [addr]
	$display("case 3 begin, STORE R2 -> [addr]");
	instruction = {`OPCODE_STORE, 5'b00011}; // opcode=100
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // MEM
	#10; print_state(); // FETCH

	// case 4: JMP addr
	$display("case 4 begin, JMP addr");
	instruction = {`OPCODE_JMP, 5'b00010};
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	#10; print_state(); // FETCH

	// case 5: JZ addr when zero_flag = 1
	$display("case 5 begin, JZ addr when zero_flag = 1");
	instruction = {`OPCODE_JZ, 5'b10101};
	zero_flag = 1;
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	#10; print_state(); // FETCH
	
	// case 6: SUB R3, imm2 (src1 = R3, imm2 = 3)
	$display("case 6 begin, SUB R3, imm2 (src1 = R3, imm2 = 3)");
	instruction = {`OPCODE_SUB, 1'b1, 2'b11, 2'b11}; // opcode=000
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	#10; print_state(); // WRITEBK
	#10; print_state(); // FETCH

	// case 7: JZ addr when zero_flag = 0
	$display("case 7 begin, JZ addr when zero_flag = 0");
	instruction = {`OPCODE_JZ, 5'b10101};
	zero_flag = 0;
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	#10; print_state(); // FETCH
	
	// case 8: reset during ADD instruction
	$display("case 8 begin, reset during ADD instruction");
	instruction = {`OPCODE_ADD, 1'b0, 2'b01, 2'b10}; // opcode=000
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // EXECUTE
	reset = 1;
	#10; print_state(); // FETCH

	// case 9: HALT
	$display("case 9 begin, HALT");
	instruction = {`OPCODE_HALT, 5'b00000};
	print_state();		  // FETCH
	#10; print_state(); // DECODE
	#10; print_state(); // HALT
	#10; print_state(); // HALT

	$display("control unit tb finished");
	$finish;
end

endmodule