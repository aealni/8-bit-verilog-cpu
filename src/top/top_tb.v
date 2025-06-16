`timescale 1ns/1ps
module top_tb;

// clock generation
reg clk = 0;
always #5 clk = ~clk; // 10ns period

top uut (
	.clk(clk)
);

task print_ram;
integer i;
begin
	$write("RAM: ");
	for (i = 0; i < 32; i = i + 1) begin
		$write("A%0d=%8b ", i, uut.ram.mem[i]);	// print all ram
	end
	$write("\n");
end
endtask


task print_vars;
integer i;
begin
	$write("Register File: ");
	for (i = 0; i < 4; i = i + 1) begin
		$write("R%0d=%3d ", i, uut.regfile.regfile[i]);	// print registers
	end
	
	$write("PC: %2d ", uut.pc.pc_out);						// print pc
	$write("Reset: %0d ", uut.reset);						// print reset signal
	$write("Reg write: %0d ", uut.reg_write_en);			// print reg we
	$write("ALU imm2: %0d ", uut.alu.imm2);				// imm2
	$write("immsel: %0d ", uut.immsel);						// immsel
	$write("zero flag: %0d ", uut.zero_flag);				// zero flag
	$write("dest reg: %0d ", uut.reg_dest);				// dest reg
	$write("ALU out: %3d ", uut.alu_out_reg);				// alu out
	$write("reg data in: %3d ", uut.reg_data_in);		// reg data in
	$write("IR: %8b", uut.ir.instruction_out);			// print ir
	$write("\n");
end
endtask

initial begin
	$display("top tb begin"); // run for 35 clock cycles, to confirm halt
	#10;	// wait for reset to pass
	$display("pre execution");
	print_vars();
	print_ram();
	
	// #10 print_vars();	// tests by clock cycle
	// note time delays below can be changed to reflect one clock cycle (#10) or one instruction cycle
	
	#40;	// 1
	$write("executed 1  ");
	print_vars();
	#40;	// 2
	$write("executed 2  ");
	print_vars();
	#40;	// 3
	$write("executed 3  ");
	print_vars();
	#40;	// 4
	$write("executed 4  ");
	print_vars();
	#40;	// 5
	$write("executed 5  ");
	print_vars();
	#40;	// 6
	$write("executed 6  ");
	print_vars();
	#40;	// 7
	$write("executed 7  ");
	print_vars();
	#40;	// 8
	$write("executed 8  ");
	print_vars();
	#40;	// 9
	$write("executed 9  ");
	print_vars();
	#40;	// 10
	$write("executed 10 ");
	print_vars();
	#40;	// 11
	$write("executed 11 ");
	print_vars();
	#40;	// 12
	$write("executed 12 ");
	print_vars();
	#40;	// 13
	$write("executed 13 ");
	print_vars();
	#40;	// 14
	$write("executed 14 ");
	print_vars();
	#40;	// 15
	$write("executed 15 ");
	print_vars();
	#40;	// 16
	$write("executed 16 ");
	print_vars();
	#40;	// 17
	$write("executed 17 ");
	print_vars();
	#40;	// 18
	$write("executed 18 ");
	print_vars();
	#40;	// 19
	$write("executed 19 ");
	print_vars();
	#40;	// 20
	$write("executed 20 ");
	print_vars();
	#40;	// 21
	$write("executed 21 ");
	print_vars();
	#40;	// 22
	$write("executed 22 ");
	print_vars();
	#40;	// 23
	$write("executed 23 ");
	print_vars();
	#40;	// 24
	$write("executed 24 ");
	print_vars();
	#40;	// 25
	$write("executed 25 ");
	print_vars();
	#40;	// 26
	$write("executed 26 ");
	print_vars();
	#40;	// 27
	$write("executed 27 ");
	print_vars();
	#40;	// 28
	$write("executed 28 ");
	print_vars();
	#40;	// 29
	$write("executed 29 ");
	print_vars();
	#40;	// 30
	$write("executed 30 ");
	print_vars();
	#40;	// 31
	$write("executed 31 ");
	print_vars();
	#40;	// 32
	$write("executed 32 ");
	print_vars();
	#40;	// 33
	$write("halt 33     ");
	print_vars();
	#40;	// 34
	$write("halt 34     ");
	print_vars();
	#40;	// 35rd cycle
	$write("halt 35     ");
	print_vars();

	print_ram();
	$display("top tb end");
	$finish;
end

endmodule