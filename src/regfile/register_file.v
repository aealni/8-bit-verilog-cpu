`include "../common/defines.vh"
module register_file(
input 			clk,
input 			write_enable,
input 	[1:0]	src1,				// src1 index
input 	[1:0]	src2,				// src2 index
input 	[1:0]	dest_reg,		// destination register index
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

// reset & sync writes
always @(posedge clk or posedge reset) begin
	if (reset) begin
		regfile[2'd0] <= 8'd0;
		regfile[2'd1] <= 8'd0;
		regfile[2'd2] <= 8'd0;
		regfile[2'd3] <= 8'd0;
	end else if (write_enable)
		regfile[dest_reg] <= write_data;
end

endmodule