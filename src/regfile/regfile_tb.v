`timescale 1ns/1ps
module regfile_tb;

// I/O
reg clk;
reg write_enable;
reg [1:0] src1;
reg [1:0] src2;
reg [1:0] reg_write;
reg [7:0] write_data;
reg		 reset;

wire [7:0] src1_data;
wire [7:0] src2_data;

register_file uut (
	.clk(clk),
   .write_enable(write_enable),
   .src1(src1),
   .src2(src2),
	.reg_write(reg_write),
   .write_data(write_data),
   .reset(reset),
   .src1_data(src1_data),
   .src2_data(src2_data)
);

//reset task
task rst(); begin
	reset = 1;
	#10
	reset = 0;
	end
endtask

// clk generation
always #5 clk = ~clk; // 10ns period

// testing
initial begin
	// init 
	clk = 0;
	write_enable = 0;
	src1 = 2'd0;
	src2 = 2'd1;
	reg_write = 2'd0;
	write_data = 8'd0;
	reset = 0;
	
	rst();
	
	$display("Starting regfile tb");
	
	// case 1: test initial vals
	if (src1_data !== 8'd0 || src2_data !== 8'd0)
		$error("Incorrect reset 1");
		
	// case 2: write to reg 0
	rst();
	write_enable = 1;
	reg_write = 2'd0;
	write_data = 8'd255;
	#10
	if (src1_data !== 8'd255)
		$error("Incorrect write 2");
		
	// case 3: write to reg 1
	rst();
	write_enable = 1;
	reg_write = 2'd1;
	write_data = 8'd255;
	#10
	if (src2_data !== 8'd255)
		$error("Incorrect write 3");
		
	// case 4: write to reg 2
	rst();
	src1 = 2'd2;
	write_enable = 1;
	reg_write = 2'd2;
	write_data = 8'd255;
	#10
	if (src1_data !== 8'd255)
		$error("Incorrect write 4");
		
	// case 5: write to reg 3
	rst();
	src2 = 2'd3;
	write_enable = 1;
	reg_write = 2'd3;
	write_data = 8'd255;
	#10
	if (src2_data !== 8'd255)
		$error("Incorrect write 5");
	
	// case 6: attempt write with we = 0
	rst();
	write_enable = 0;
	src1 = 2'd0;
	src2 = 2'd1;
	reg_write = 2'd0;
	write_data = 8'd255;
	#10;
	if (src1_data == 8'd255)
		$error("Write without permission 6");
	
	
	$display("Register 0: %d, Register 1: %d, Register 2: %d, Register 3: %d", 
             uut.regfile[0], uut.regfile[1], uut.regfile[2], uut.regfile[3]);
	$display("Regfile tb end");
	$finish;
end
endmodule