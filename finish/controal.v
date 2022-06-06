module controal(
		input clk,
		input rst_n,
		input [1:0] i1,      			//状态控制按键输入
		output reg[1:0]o1				//状态量输出
);
parameter [4:0]    IDLE  = 5'b00001,    //定义了四个状态
				   s1    = 5'b00010,
				   s2    = 5'b00100,
				   s3    = 5'b01000;		 
reg [4:0] state,next;
always @ (posedge clk or negedge rst_n)
begin
		if
			(~rst_n) state <= IDLE;
		else 
			state <= next;
end

always @(state or i1)
begin
		next = 5'bx;
		o1 = 2'b00;
		      case(state)
					IDLE:								//初始状态
						begin
							if(i1==2'b01) 
								next = s1;
							else 
								next = IDLE;
						   o1 <= 2'b00;
						end
					s1:									//学号展示状态
						begin
							if(i1==2'b10) 
									next = s2;
							else 
									next = s1;
					       o1 <= 2'b01;
						end
					s2:									//时钟状态
						begin
					
							if(i1==2'b11) 
									next = s3;
							else 
									next = s2;
							 o1 <= 2'b10;
								
						end
					s3:									//乘法器状态
						begin
							if (i1==2'b00) 
								next = IDLE;
							else 
								next = s3;							
							o1 <= 2'b11;							
						end
				endcase
end
endmodule
					