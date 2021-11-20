module prescaler( 
    input wire clk,
	input wire[15:0] psc,
		
	output reg out_clk
);	

reg[7:0] counter;

initial begin
	out_clk = 0;
	counter = 0;
end

always @(posedge clk) begin
//	if(clk) begin
		if(counter == (psc >> 1) - 1) begin
			out_clk <= ~out_clk;			
			counter <= 0;
		end
		else begin
			out_clk <= out_clk;	
			counter <= counter + 1;		
		end
//	end
end

endmodule
