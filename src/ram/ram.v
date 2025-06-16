`include "../common/defines.vh"
module ram(
	input					clk,
	input					read_en,	// read enable
	input					write_en,	// write enable
	input 		[`ADDR_WIDTH-1:0]	address,	// in/out address
	input 		[`WORD_SIZE-1:0]	write_data,	// data in
	output reg	[`WORD_SIZE-1:0]	read_data	// data out
);
//32 x 8 bit memory
reg [`WORD_SIZE-1:0] mem [0:`RAM_DEPTH-1];


//load memory from external binary file, change path to load different program
initial begin 
	$readmemb("../programs/prog.txt",mem); // I had to set the full path (C:/Users/.../programs/prog.txt) for successful simulation
end

//combinational read
always@(*) begin
	if (read_en)
		read_data = mem[address];
	else
		read_data = `WORD_SIZE'd0;
end

// synchronous write
always@(posedge clk) begin
	if(write_en)
		mem[address] <= write_data;
end
endmodule