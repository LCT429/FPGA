//时钟控制模块，包括按键设置时间、输出时间数值


module hour(
	input clk,
	input rst_n,
	input clc,								//时钟清零按键
	input up,								//时钟控制按键，用于暂停与开始
	input sec_up,        					//秒增加按键
	input min_up,							//分增加按键
	input hour_up,							//时增加按键
	output reg [23:0]clock_time             //定义时间输出

);

	reg [0:0] sec_min,min_hour;                            //分钟和小时进位信号
	reg [31:0] timer;
	parameter CLK_FREQ = 50000000;
	
//一秒的计数器
always @(posedge clk or negedge rst_n)
 begin
    if (~rst_n)
        timer <= 0;
	else if((timer == CLK_FREQ-1) || sec_up || clc)
		  timer <= 0;
    else
        timer <= timer + 1'b1;
 end 

 

//sec
always @(posedge clk or negedge rst_n ) 
begin
	if(~rst_n)
			begin
					clock_time[3:0]      <= 0;						//复位置零
					clock_time[7:4]      <= 0;
					sec_min    <= 0;
			end
	else if (clc)
				begin
					clock_time[3:0]      <= 0;						//清零信号置零
					clock_time[7:4]      <= 0;
					sec_min    <= 0;
			end
	else if(((timer == CLK_FREQ-1) && up) || sec_up )                //在该时刻与开关按键按下时 或者 按键按下秒的设置按键 秒的低位加一
		  begin
					clock_time[3:0]      <= clock_time[3:0] + 1'b1;
					clock_time[7:4]      <= clock_time[7:4];
					sec_min    <= 0;
						
		  end			
	else if (clock_time[3:0] == 10)									//如果秒的个位满十执行下面语句
			begin
					clock_time[7:4]      <= clock_time[7:4] + 1'b1;	//十位加一，个位清零
					clock_time[3:0]      <=0;
					sec_min    <= 0;
			end
						         	 
	else  if(clock_time[7:4] >=6 && clock_time[3:0] >= 0)			//如果秒的十位大于等于6，个位大于等于0时，
		   begin													//产生一个分钟进位信号，同时清零秒的各位
					clock_time[3:0]      <= 0;
					clock_time[7:4]      <= 0;
					sec_min    <= 1'b1;
		   end
    else 
			begin
					clock_time[3:0]      <= clock_time[3:0];
					clock_time[7:4]      <= clock_time[7:4];
					sec_min    <= 0;
			end
end

//min
always @(posedge clk or negedge rst_n ) 
begin
	if(~rst_n)
			begin
					clock_time[11:8]      <= 0;
					clock_time[15:12]      <= 0;
					min_hour   <= 0;
			end
	else if(clc)
	begin
					clock_time[11:8]      <= 0;
					clock_time[15:12]      <= 0;
					min_hour   <= 0;
			end
	
	else if(sec_min || min_up)												//分钟进位信号为一时，或者分的设置按键按下时加一
		  begin
					clock_time[11:8]    <= clock_time[11:8] + 1'b1;
					clock_time[15:12]    <= clock_time[15:12];
					min_hour <= 0;
						
		  end			
	else if (clock_time[11:8] == 10)
			begin
					clock_time[15:12]    <= clock_time[15:12] + 1'b1;
					clock_time[11:8]    <=0;
					min_hour <= 0;
			end
						         	 
	else  if(clock_time[15:12] >=6 && clock_time[11:8] >= 0)
		   begin
					clock_time[11:8]    <= 0;
					clock_time[15:12]    <= 0;
					min_hour <= 1'b1;
		  end
    else 
			begin
					clock_time[11:8]    <= clock_time[11:8];
					clock_time[15:12]    <= clock_time[15:12];
					min_hour <= 0;
			end
end
//HOUR
always @(posedge clk or negedge rst_n ) 
begin
	if(~rst_n)
			begin
					clock_time[23:20] <= 0;
					clock_time[19:16] <= 0;
			end
	else if(clc)
	begin
					clock_time[23:20] <= 0;
					clock_time[19:16] <= 0;
			end
	
	else if(min_hour || hour_up)												//小时进位信号为一时，或者小时的设置按键按下时加一
		  begin
					clock_time[19:16] <= clock_time[19:16] + 1'b1;
					clock_time[23:20] <= clock_time[23:20];
						
		  end			
	else if (clock_time[19:16] == 10)
			begin
					clock_time[23:20] <= clock_time[23:20] + 1'b1;
					clock_time[19:16] <=0;
			end
						         	 
	else  if(clock_time[23:20] >=2 && clock_time[19:16] >= 4)
		   begin
					clock_time[23:20] <= 0;
					clock_time[19:16] <= 0;
		  end
    else 
			begin
					clock_time[23:20] <= clock_time[23:20];
					clock_time[19:16] <= clock_time[19:16];
			end
end

endmodule