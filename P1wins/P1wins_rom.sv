module P1wins_rom (
	input logic clock,
	input logic [17:0] address,
	output logic [0:0] q
);

logic [0:0] memory [0:172799] /* synthesis ram_init_file = "./P1wins/P1wins.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
