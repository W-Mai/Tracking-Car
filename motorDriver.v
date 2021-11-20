module motorDriver( 
	input wire clk,

	input wire[7:0] duty,
	input wire dir,

		
	output reg A_P,		
	output reg A_N
);

reg[7:0] div_cycles;
assign activated = div_cycles < duty;

initial begin
	div_cycles = 0;
end

always @(posedge clk) begin
	div_cycles <= div_cycles + 1;

	A_P <= dir ? activated : 0;
	A_N <= dir ? 0 : activated;
end

endmodule
