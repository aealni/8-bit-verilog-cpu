`include "../common/defines.vh"

module pc(
input	 			clk,
input	 			reset,
input				pc_write,
input		[7:0]	next_pc,
output	[7:0] pc_out
);

// 8 bit pc
reg [7:0] pc_reg;

// sync update
always @(posedge clk or posedge reset)begin
	if(reset)
		pc_reg <= 8'd0;
	else if (pc_write)
		pc_reg <= next_pc;
end

assign pc_out = pc_reg;

endmodule