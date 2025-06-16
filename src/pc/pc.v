`include "../common/defines.vh"

module pc(
input	 			clk,
input	 			reset,		// reset pc to 0
input				pc_write,	// pc write enable
input		[4:0]	next_pc,
output	[4:0] pc_out
);

// 5 bit pc
reg [4:0] pc_reg;

// sync update
always @(posedge clk or posedge reset)begin
	if(reset)
		pc_reg <= 5'd0;
	else if (pc_write)
		pc_reg <= next_pc;
end

assign pc_out = pc_reg;

endmodule