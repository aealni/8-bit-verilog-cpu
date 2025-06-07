`include "../common/defines.vh"
module ram(
	input					clk,
	input					read_en,
	input					write_en,
	input 		[4:0]	address,
	input 		[7:0]	write_data,
	output reg	[7:0]	read_data
);
//32 x 8 bit memory
reg [7:0] mem [0:31];


//load memory from external binary file
initial begin 
	$readmemb("../programs/prog.txt",mem); // I had to set the full path (C:/Users/.../programs/prog.txt) for successful simulation
end

//combinational read
always@(*) begin
	if (read_en)
		read_data = mem[address];
	else
		read_data = 8'd0;
end

// synchronous write
always@(posedge clk) begin
	if(write_en)
		mem[address] <= write_data;
end
endmodule