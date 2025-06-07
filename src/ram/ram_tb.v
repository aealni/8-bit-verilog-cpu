`timescale 1ns/1ps
`include "../common/defines.vh"
module ram_tb;

// tb signals
reg clk;
reg read_en;
reg write_en;
reg [4:0] address;
reg [7:0] write_data;
wire [7:0] read_data;

// instantiate ram
ram uut (
	.clk(clk),
   .read_en(read_en),
   .write_en(write_en),
   .address(address),
   .write_data(write_data),
   .read_data(read_data)
);

// clock generation
always #5 clk = ~clk; // 10ns period

// this file tested with initial load mem[0] and mem[1] = 8'd0
initial begin
	$display("Starting RAM Test");
	clk = 0;
	read_en = 0;
	write_en = 0;
	address = 5'd0;
	write_data = 8'd0;
	#10;
	
	// case 1: read address 0
	read_en = 1;
	write_en = 0;
	address = 5'd0;
	write_data = 8'd0;
	#10;
	if (read_data !== 8'b00000000)
		$error("Incorrect read 1");
		$display(read_data);
	
	// case 2: write to address 0
	read_en = 0;
	write_en = 1;
	address = 5'd0;
	write_data = 8'b11111111;
	#10;
	
	// case 3: write to address 1
	read_en = 0;
	write_en = 1;
	address = 5'b00001;
	write_data = 8'b11111111;
	#10;
	
	// case 4: read from address 0
	read_en = 1;
	write_en = 0;
	address = 5'b00000;
	write_data = 8'd0;
	#10;
	if (read_data !== 8'b11111111)
		$error("Incorrect read 4");
	
	// case 5: read from address 1
	read_en = 1;
	write_en = 0;
	address = 5'b00001;
	write_data = 8'd0;
	#10;
	if (read_data !== 8'b11111111)
		$error("Incorrect read 4");
	
	// case 6: both enables off
	read_en = 0;
	write_en = 0;
	address = 5'd0;
	write_data = 8'd0;
	#10;
	if (read_data !== 8'b00000000)
		$error("Incorrect read 5");
	
	$display("RAM Test End");
	$stop;
end

endmodule
