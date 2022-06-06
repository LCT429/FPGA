//按键控制模块，将各个按键在不同状态下与各个模块连接

module keyset(
			input 		clk,
			input 		rst_n,
			input 		a_up,b_up,c_up,d_up,e_up,f_up,g_up,			//按键输入，输入的是一个时钟下的上升沿
			input 		[1:0]state,									//状态输入
			output reg  [1:0] o1,								//状态机控制量的输出
			output reg  [3:0] X,									//乘法器的乘数
			output reg  [3:0] Y,									//乘法器的被乘数
			output reg  compute,									//乘法器显示结果按键
			output reg  clc,up,hour_up,min_up,sec_up				//时钟模块的按键输出；
																//clc 清零；	up 暂停与开始；		hour_up,min_up,sec_up  分别为时、分、秒的增加			
);

always @(posedge clk or negedge rst_n)
 begin
    if (~rst_n)								//复位情况下全部置为0；
				begin
					o1 		<= 0;
					clc		<= 0;
					X 		<= 0;
					Y 		<= 0;
					compute <= 0;
					up 		<= 0;
					hour_up <= 0;
					min_up  <= 0;
					sec_up  <= 0;					
				end
	 else if (g_up)							//状态切换按键
				begin
					o1 <= o1 + 1'b1;
				end
	 else if (state == 2'b10)				//时钟状态的按键定义
				begin
					hour_up <= a_up;		
					min_up  <= b_up;
					sec_up  <= c_up;
					clc 	<= e_up;
						if(d_up)
							up <= ~up;					
						else
							up <= up;	
									
				end
	 else if (state == 2'b11)				//乘法器状态按键定义
			begin
			if (d_up)
					begin
						X		<= 0;
						Y 		<= 0;
						compute <= 0;
					end
			else if(a_up) 
					begin
						X <= X + 1'b1;
						Y <= Y;
					end
			else if(b_up) 
					begin
						Y <= Y + 1'b1;
						X <= X;
					end
			else if(c_up)
						compute <= ~compute;
					
			else
					begin
						X <= X;
						Y <= Y;
					end
			end
    else
				begin
					o1 		 <= o1;
				    hour_up  <= hour_up;
					min_up   <= min_up;
					sec_up   <= sec_up;
					X 		 <= X;
					Y        <= Y;
					compute  <= compute;
				end
       
end
endmodule