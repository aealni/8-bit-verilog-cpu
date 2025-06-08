`timescale 1ns/1ps
module pc_tb;
//I/O
reg			clk;
reg			reset;
reg			pc_write;
reg	[7:0]	next_pc;
wire	[7:0]	pc_out;

//instantiate uut
pc uut(
	.clk(clk),
	.reset(reset),
	.pc_write(pc_write),
	.next_pc(next_pc),
	.pc_out(pc_out)
);

task rst(); begin
	reset = 1;
	#10;
	reset = 0;
end
endtask

always #5 clk = ~clk; // 10ns clock

initial begin
	//init
	clk = 0;
	reset = 0;
	pc_write = 0;
	next_pc = 8'd0;
	
	
	$display("PC tb begin");
	// case 1: test reset
	rst();
	if (pc_out !== 8'd0)
		$error("incorrect pc out after reset 1");
	
	// case 2: write to pc (pc+1)
	rst();
	pc_write = 1;
	next_pc = 8'd1;
	#10
	if (pc_out !== 8'd1)
		$error("incorrect pc out after write 2");
		
	// case 3: attempt to write to pc without write enable
	rst();
	pc_write = 0;
	next_pc = 8'd2;
	#10
	if (pc_out == 8'd2)
		$error("pc out written to without write enable 3");
	
	// case 4: pc write jump
	rst();
	pc_write = 1;
	next_pc = 8'd255;
	#10
	if (pc_out !== 8'd255)
		$error("incorrect pc out after jump write 4");
	
	$display("PC tb end");
	$finish;
end

endmodule
