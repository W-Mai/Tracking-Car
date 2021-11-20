module main(
	input wire mainCLK, // 24MHz
	
	input wire[3:0] sensorIn,	

	output reg[2:0] led,
	
	output wire A_PO,	
	output wire A_NO,	
	output wire B_PO,	
	output wire B_NO
);

reg[24:0] mainCLKCounter;
wire clk1M;
wire clk1K;
wire clk1S;

reg[7:0] motorDutyL;
reg[7:0] motorDutyR;
reg motorDirL = 1;
reg motorDirR = 1;

prescaler psc1M(
	.clk(mainCLK),
	.psc(24),
	.out_clk(clk1M)
);

prescaler psc1K(
	.clk(clk1M),
	.psc(1000),
	.out_clk(clk1K)
);	

prescaler psc1S(
	.clk(clk1K),
	.psc(1000),
	.out_clk(clk1S)
);

// 电机驱动
motorDriver driverRight(
	.clk(clk1M),

	.duty(motorDutyR),
	.dir(motorDirR),		
		
	.A_P(A_PO),		
	.A_N(A_NO)
);	

motorDriver driverLeft(
	.clk(clk1M),
		
	.duty(motorDutyL),
	.dir(!motorDirR),		
		
	.A_P(B_PO),		
	.A_N(B_NO)
);	

// 状态机
reg[3:0] carState;
reg[3:0] carStateNext;

parameter IDLE			= 4'h0; 
parameter GO_STRAINT 	= 4'h1;
parameter TURN_LEFT 	= 4'h2;
parameter TURN_LEFT_B 	= 4'h3;
parameter TURN_RIGHT	= 4'h4;
parameter TURN_RIGHT_B	= 4'h5;

always @(posedge mainCLK) begin
	
end

always @(posedge clk1M) begin
	led <= sensorIn[2:0];
	carState <= carStateNext;
end

always @(*) begin
	
		
	if(sensorIn[1:0] > 2'b00)
		carStateNext = TURN_RIGHT;	
	else		
		carStateNext = carStateNext;	
			
	if(sensorIn[3:2] > 2'b00)		
		carStateNext = TURN_LEFT;
	else		
		carStateNext = carStateNext;		
end	

always @(posedge clk1M) begin
	case(carState)
		IDLE: begin
			motorDutyL <= 0;
			motorDirL <= 1;			
			
			motorDutyR <= 0;
			motorDirR <= 1;
		end
		GO_STRAINT:	begin
			motorDutyL <= 200;
			motorDirL <= 1;			
			
			motorDutyR <= 200;
			motorDirR <= 1;
		end	
		TURN_LEFT: begin
			motorDutyL <= 140;
			motorDirL <= 1;			
			
			motorDutyR <= 200;
			motorDirR <= 1;
		end
		TURN_RIGHT: begin
			motorDutyL <= 200;
			motorDirL <= 1;			
			
			motorDutyR <= 140;
			motorDirR <= 1;
		end
		default: begin	
			motorDutyL <= 0;
			motorDirL <= 1;			
			
			motorDutyR <= 0;
			motorDirR <= 1;
		end
	endcase		
end

always @(posedge clk1K) begin
	
end

always @(posedge clk1S) begin

end

endmodule
