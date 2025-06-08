`include "../common/defines.vh"
module register_file(
input 			clk,
input 			write_enable,
input 	[1:0]	src1,				// src1 index
input 	[1:0]	src2,				// src2 index
input 	[1:0]	reg_write,		// write register index
input 	[7:0]	write_data,		//	data to write 
input				reset,			// reset signal
output	[7:0] src1_data,		// src1 output
output	[7:0] src2_data		// src2 output
);

// 4 x 8 register array
reg [7:0] regfile [0:3];

// async reads
assign src1_data = regfile[src1];
assign src2_data = regfile[src2];

// sync writes & reset
always @(posedge clk) begin
	if (reset) begin
		regfile[0] <= 8'd0;
		regfile[1] <= 8'd0;
		regfile[2] <= 8'd0;
		regfile[3] <= 8'd0;
	end else if (write_enable)
		regfile[reg_write] <= write_data;
end

endmodule