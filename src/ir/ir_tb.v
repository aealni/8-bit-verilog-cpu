`timescale 1ns/1ps
module ir_tb;

reg 			clk;
reg 			reset;
reg 			load_ir;
reg	[7:0] instruction_in;
wire	[7:0] instruction_out;

// instantiate uut
instruction_register uut (
	.clk(clk),
	.reset(reset),
	.load_ir(load_ir),
	.instruction_in(instruction_in),
	.instruction_out(instruction_out)
);

// clock gen
always #5 clk = ~clk; // 10ns period 

task rst(); begin
	reset = 1;
	#10
	reset = 0;
end
endtask

// testing
initial begin
	// init 
	clk = 0;
	reset = 0;
	load_ir = 0;
	instruction_in = 8'd0;
	
	$display("start IR tb");
	
	// case 1: test reset
	rst();
	if (instruction_out !== 8'd0)
		$error("incorrect reset 1");
		
	// case 2: load instruction
	rst();
	load_ir = 1;
	instruction_in = 8'h01;
	#10;
	if (instruction_out !== 8'h01)
		$error("incorrect load 2");
	
	// case 3: try to load without load enable
	rst();
	load_ir = 0;
	instruction_in = 8'h03;
	#10;
	if (instruction_out == 8'h03)
		$error("load without enable permission 3");
	
	// case 4: load different instruction
	rst();
	load_ir = 1;
	instruction_in = 8'hFF;
	#10;
	if (instruction_out !== 8'hFF)
		$error("incorrect load 4");
	
	$display("IR tb done");
	$finish;
end
endmodule