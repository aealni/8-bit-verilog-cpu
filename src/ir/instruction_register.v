`include "../common/defines.vh"
module instruction_register(
	input 				clk,
	input					reset,	// clear IR
	input					load_ir,				// load enable
	input			[7:0]	instruction_in,	// instruction to be loaded
	output reg	[7:0]	instruction_out	// instruction held in IR
);

always @(posedge clk or posedge reset) begin
	if (reset)
		instruction_out <= 8'd0;
	else if (load_ir)
		instruction_out <= instruction_in;
end
endmodule