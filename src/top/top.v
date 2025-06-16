`include "../common/defines.vh"
module top(
	input clk
);

// control signals
wire pc_write, ir_write, reg_write_en, immsel, mem_read, mem_write;
wire pc_src, reg_src, mem_addr_src; // mux inputs (immsel not included b/c alu module contains mux logic)
wire [1:0] alu_src1, alu_src2, alu_op, reg_dest;

// internal connections
wire [7:0] alu_out, ram_out, reg_data1, reg_data2, instruction_out;
wire [4:0] pc_out;
// reg_data_in, pc_next, and mem_addr are mux controlled by reg_src, pc_src, and mem_addr_src, respectively.
wire zero_flag; // control unit input

reg [7:0] alu_out_reg; // store alu_out b/c signals are cleared after every state (from execute to writebk)
reg [7:0] ram_out_reg; // store ram_out

reg reset = 1'b0; // only high for once cycle at the start of program execution
reg reset_counter = 1'b0; // lets reset = 1 for one clock cycle

// module instantiation
// PC
wire [4:0] pc_next = (pc_src == 0) ? pc_out + 5'd1 :
							(pc_src == 1) ? instruction_out[4:0] : 5'b0; // default to 0

pc pc(
	.clk(clk),
	.reset(reset),
	.pc_write(pc_write),
	.next_pc(pc_next),
	.pc_out(pc_out)
);

// IR
instruction_register ir(
	.clk(clk),
	.reset(reset),
	.load_ir(ir_write),
	.instruction_in(ram_out),
	.instruction_out(instruction_out)
);

// RAM
wire [4:0] mem_addr = (mem_addr_src == `MEM_ADDR_PC) ? pc_out :
							 (mem_addr_src == `MEM_ADDR_IR) ? instruction_out[4:0] : 5'b0;
ram ram(
	.clk(clk),
	.read_en(mem_read),
	.write_en(mem_write),
	.address(mem_addr),
	.write_data(reg_data1),
	.read_data(ram_out)
);

// ALU
alu alu(
	.src1(reg_data1),
	.src2(reg_data2),
	.imm2(instruction_out[1:0]),
	.imm_sel(immsel),
	.alu_op(alu_op),
	.result(alu_out),
	.zero_flag(zero_flag)
);

// Regfile
wire [7:0] reg_data_in = (reg_src == `REG_SRC_ALU) ? alu_out_reg :
								 (reg_src == `REG_SRC_RAM) ? ram_out_reg : 8'b0;
register_file regfile(
	.clk(clk),
	.reset(reset),
	.write_enable(reg_write_en),
	.src1(alu_src1),
	.src2(alu_src2),
	.dest_reg(reg_dest),
	.write_data(reg_data_in),
	.src1_data(reg_data1),
	.src2_data(reg_data2)
);

// Control Unit
control_unit cu(
	.clk(clk),
	.reset(reset),
	.instruction(instruction_out),
	.zero_flag(zero_flag),
	.pc(pc_out),
	.pc_write(pc_write),
	.pc_src(pc_src),
	.ir_write(ir_write),
	.reg_write(reg_write_en),
	.reg_src(reg_src),
	.reg_dest(reg_dest),
	.alu_op(alu_op),
	.alu_src1(alu_src1),
	.alu_src2(alu_src2),
	.imm_sel(immsel),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_addr_src(mem_addr_src)
);



// one cycle reset pulse logic
always @(posedge clk) begin
	if (reset == 0 && reset_counter == 0) begin
		reset <= 1;
		reset_counter <= 1;
		alu_out_reg <= 0;
		ram_out_reg <= 0;
	end else begin
		alu_out_reg <= alu_out;
		ram_out_reg <= ram_out;
		reset <= 0;
	end
end

endmodule