//顶层模块
module project(
		input 	 clk,
		input  	 [8:1]BUT,
		output 	 [7:0]led,
		output 	 [5:0] seg_sel,
		output 	 [7:0] seg_led
);

   wire sec_up, min_up,hour_up;                					// 时钟设置传递
	wire [23:0] clock_time;										// 时钟数值传递
	wire [3:0] seg_data;										//数码管传递
	wire rst_n,a_up,b_up,c_up,d_up,e_up,f_up,g_up;				// 按键传递
	wire clc,up,compute; 		    							//各个模块的一些控制量
	wire [1:0] A; 												// 状态控制量
	wire [1:0] C;  												// 状态传递量
	wire [3:0] X,Y;												//乘法器乘数
	wire [7:0] Z;												//乘法器结果
//按键消抖
debounce i0(
	.Out (rst_n),
	.Btn_In(BUT[1]),
	.CLK(clk)
);
key_debounce key1(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[2]),
	.key_flag(a_up)
);
key_debounce key2(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[3]),
	.key_flag(b_up)
);
key_debounce key3(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[4]),
	.key_flag(c_up)
);
key_debounce key4(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[5]),
	.key_flag(d_up)
);
key_debounce key5(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[6]),
	.key_flag(e_up)
);
key_debounce key6(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[7]),
	.key_flag(f_up)
);
key_debounce key7(
	.sys_clk(clk),
	.rst_n(rst_n),
	.key_in(BUT[8]),
	.key_flag(g_up)
);
//按键分配
keyset i5(
	.clk(clk),
	.rst_n(rst_n),
	.a_up(a_up),
	.b_up(b_up),
	.c_up(c_up),
	.d_up(d_up),
	.e_up(e_up),
	.f_up(f_up),
	.g_up(g_up),
	.o1(A),
	.hour_up(hour_up),
	.min_up(min_up),
	.sec_up(sec_up),
	.state(C),
	.X(X),
	.Y(Y),
	.clc(clc),
	.up(up),
	.compute(compute)

);
//状态机控制模块
controal i6(
	.clk(clk),
	.rst_n(rst_n),
	.i1(A),
	.o1(C)
);
//LED集成模块
led_crt i7(
	.clk(clk),
	.rst_n(rst_n),
	.crt(C),
	.led(led),
	.up(up)
);
//时钟模块
hour i8(
	.clk(clk),
	.rst_n(rst_n),
	.clock_time(clock_time),
	.sec_up(sec_up),
	.min_up(min_up),
	.hour_up(hour_up),
	.clc(clc),
	.up(up)
	);
//数码管显示模块
seg_decoder i9(
	.seg_data(seg_data),
	.seg_led(seg_led),
	.crt(C)
	);
//数码管片选与数值控制模块
seg_data i10(
	.clk(clk),
	.rst_n(rst_n),
	.crt(C),
	.clock_timer(clock_time),
	.seg_sel(seg_sel),
	.seg_data(seg_data),
	.Z(Z),
	.X(X),
	.Y(Y),
	.point(seg_led[7]),
	.compute(compute)
	
);
//四位乘法器模块
all_add_4 i11(
	.x(X),
	.y(Y),
	.z(Z)
);
endmodule


//全加器模块
module all_add(x,y,z,cin,cout);
	input x,y,cin;
	output z,cout;
	assign z=x^y^cin;
	assign cout=(x&y)|(x&cin)|(y&cin);
endmodule


//乘法器模块
module all_add_4(
	
	input 	[3:0] x,		//乘数
	input 	[3:0] y,		//被乘数
	output 	[7:0] z			//结果
	
);

    wire 		[3:0]p0,p1,p2,p3;        						//乘数的每一位与被乘数相与的寄存器
	wire		a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12;			//进位
	wire 		sum1,sum2,sum3,sum4,sum5,sum6;					//全加器结果
	
	assign 	p0 = x & {y[0],y[0],y[0],y[0]};
	assign 	p1 = x & {y[1],y[1],y[1],y[1]};
	assign 	p2 = x & {y[2],y[2],y[2],y[2]};
	assign 	p3 = x & {y[3],y[3],y[3],y[3]};
	
	assign 	z[0] = p0[0];
	
all_add i0(.x(p0[1]),.y(p1[0]),.z(z[1]),.cin(1'b0),.cout(a1)
	);
all_add i1(.x(p0[2]),.y(p1[1]),.z(sum1),.cin(a1),.cout(a2)
	);
all_add i2(.x(sum1),.y(p2[0]),.z(z[2]),.cin(1'b0),.cout(a3)
	);
all_add i3(.x(p0[3]),.y(p1[2]),.z(sum2),.cin(a2),.cout(a4)
);
all_add i4(.x(sum2),.y(p2[1]),.z(sum3),.cin(a3),.cout(a5)
);
all_add i5(.x(sum3),.y(p3[0]),.z(z[3]),.cin(1'b0),.cout(a6)
);
all_add i6(.x(p1[3]),.y(a4),.z(sum4),.cin(1'b0),.cout(a7)
);
all_add i7(.x(sum4),.y(p2[2]),.z(sum5),.cin(a5),.cout(a8)
);
all_add i8(.x(p3[1]),.y(sum5),.z(z[4]),.cin(a6),.cout(a9)
);
all_add i9(.x(a7),.y(p2[3]),.z(sum6),.cin(a8),.cout(a10)
);
all_add i10(.x(sum6),.y(p3[2]),.z(z[5]),.cin(a9),.cout(a11)
);
all_add i11(.x(a10),.y(p3[3]),.z(z[6]),.cin(a11),.cout(a12)
);

assign z[7]=a12;
endmodule


//状态机模块
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
	

//按键消抖
module debounce(
input Btn_In,
input CLK,
output Out
);

reg Delay0;
reg Delay1;
reg Delay2;
always @ (posedge CLK)
	begin
	
		Delay0 <= Btn_In;
		Delay1 <= Delay0;
		Delay2 <= Delay1;
	end
assign Out = Delay0 | Delay1 | Delay2;

endmodule


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

///另一个按键消抖
module key_debounce(
	input		 	sys_clk,            //50MHz系统时钟
	input 			rst_n,	 		 	//系统复位
	input 			key_in,     		//按键输入
	output reg 		key_flag	      	//LED输出
);

parameter 	CNT_MAX  = 1000000; 		//定义两个毫秒
reg [31:0] cnt;
always @(posedge sys_clk or negedge rst_n) 
begin
	if(!rst_n)
		cnt <= 0;
	else if(key_in == 1'b0)
		if(cnt <= 10*CNT_MAX )           //在20毫秒后cnt置零，开始重新计数；实现按住按键会以一秒输出五个上升沿的效果
			cnt <= cnt  + 1'b1;
		else
			cnt <= 0 ;
	else 
		cnt <= 0;
end


always@(posedge sys_clk or negedge rst_n)
begin
	if(!rst_n)
		key_flag <= 1'b0;
	else if(cnt == CNT_MAX - 1'b1)		//经过两个毫秒的消抖，输出一个时钟的key_flag
		key_flag <= 1'b1;
	else
		key_flag <= 1'b0;
end
endmodule	



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


//LED集成模块
module led_crt(
	input               clk  ,  //时钟信号
    input               rst_n,  //复位信号
	input [1:0]         crt,	//状态传递
	input up,					//时钟模块传递信号，实现暂停与开始显示不同的LED
    output reg [7:0]  led       //led灯
);
	reg [31:0] timer;
	reg [7:0] led_3;			//定义四个状态的LED
	reg [7:0] led_2;
	reg [7:0] led_1;
	parameter [7:0] led_0 = 8'b0111_1110;
	parameter CLK_FREQ = 50000000;
//计数器	
always @(posedge clk or negedge rst_n)
 begin
    if (~rst_n)
        timer <= 0;
	 else if(timer == CLK_FREQ/10) 
		timer <= 0;
    else
        timer <= timer + 1'b1;
end
//流水灯
always @(posedge clk or negedge rst_n) 
begin
    if (~rst_n)
        led_1 <= 8'b1110_0111;
    else if(timer == CLK_FREQ/10-1)
        led_1[7:0] <= {led_1[6:0],led_1[7]};
    else 
        led_1 <= led_1;

end
//LED闪烁
always @(posedge clk or negedge rst_n) 
begin
    if (~rst_n)
        led_3 <= 8'b1111_1111;
    else if(timer == CLK_FREQ/10-1)
		begin
			led_3[7:6] <= ~led_3[7:6];
			led_3[4:1] <= 4'b0000;
			led_3[5] <= 1;
			led_3[0] <= 1;
		end
    else
        led_3 <= led_3;

end
//时钟的LED分配
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		led_2 <= 0;
	else if(up)
		led_2 <= 8'b1101_0001;
	else 
		led_2 <= 8'b1100_1111;
end

//LED分配
always @(posedge clk or negedge rst_n) 
begin
    if (~rst_n)
        led <= 8'b1111_1110;
    else if(crt == 2'b00)
        led <= led_0;
	 else if(crt == 2'b01)
        led <= led_1;
	 else if(crt == 2'b10)
        led <= led_2;
	 else if(crt == 2'b11)
        led <= led_3;
    else 
        led <= led;

end
endmodule


//数值处理模块
//把时钟输出的数值分配位置传输到点亮数码管模块
//把乘法器所需显示的数值进行处理传送到点亮数码管模块

module seg_data(
		input clk,
		input rst_n,
		input [1:0] crt,					//输入状态
		input [23:0]clock_timer,			//输入时钟
		input [7:0] Z,						//输入乘法器的结果
		input [3:0] X,						//输入乘法器的两个乘数
		input [3:0] Y,
		input compute,						//输入乘法器结果显示控制信号
		output reg [5:0] seg_sel,			//输出片选信号
		output reg [3:0] seg_data,			//输出数码管显示数字
		output reg point					//输出数码管点的显示控制信号
);

	parameter SCAN_FREQ=50;
	parameter CLK_FREQ = 50000000;
	parameter SCAN_COUNT = CLK_FREQ/(SCAN_FREQ*6) - 1;
	reg[31:0] scan_timer;
	reg[3:0] scan_sel;
//片选的计数器
always@ (posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		scan_timer <= 32'd0;
		scan_sel <= 4'd0;
		
	end
	else if(scan_timer >= SCAN_COUNT)
	begin
		scan_timer <= 32'd0;
		if(scan_sel == 4'd5)
			scan_sel <= 4'd0;
		else
			scan_sel <= scan_sel+4'd1;
	end
		else
			scan_timer <= scan_timer+32'd1;
end
		

//片选，	
always@(posedge clk or negedge rst_n)
begin 

	if(rst_n == 1'b0)
		begin
			seg_sel <= 6'b111111;
			seg_data <= 0;
			
			
			
		end
	else if (crt == 2'b01) //流水灯状态
		begin
		point <= 1;
			case(scan_sel)
				4'd0:
					begin 
						seg_data <= 3;
						seg_sel <= 6'b11_1110;
						
					end
				4'd1:
					begin 
						seg_sel <= 6'b11_1101;
						seg_data <= 3;
						
					end
				4'd2:
					begin 
						seg_sel <= 6'b11_1011;
						seg_data <= 2;
						end
				4'd3:
					begin 
						seg_sel <= 6'b11_0111;
						seg_data <= 0;

					end
				4'd4:
					begin 
						seg_sel <= 6'b10_1111;
						seg_data <= 2;

					end
				4'd5:
					begin 
						seg_sel <= 6'b01_1111;
						seg_data <= 5;
						
					end
				default:
					begin
						seg_sel <= 6'b11_1111;
						seg_data <= 0;
					end
			endcase
	   end
	else if (crt == 2'b10)//时钟状态
		begin
		point <= 1;
			case(scan_sel)
				4'd0:
					begin 
						seg_data <= clock_timer[23:20];
						seg_sel <= 6'b11_1110;
					end
				4'd1:
					begin 
						seg_sel <= 6'b11_1101;
						seg_data <= clock_timer[19:16];
						point <= 0;		//在时钟状态，片选到第二个数码管，点亮点
					end
				4'd2:
					begin 
						seg_sel <= 6'b11_1011;
						seg_data <= clock_timer[15:12];
					end
				4'd3:
					begin 
						seg_sel <= 6'b11_0111;
						seg_data <= clock_timer[11:8];
						point <= 0;		//在时钟状态，片选到第四个数码管，点亮点
					end
				4'd4:
					begin 
						seg_sel <= 6'b10_1111;
						seg_data <= clock_timer[7:4];
						
						
					end
				4'd5:
					begin 
						seg_sel <= 6'b01_1111;
						seg_data <= clock_timer[3:0];
					end
				default:
					begin
						seg_sel <= 6'b11_1111;
						seg_data <= 0;
					end
			endcase
	   end
	else if (crt == 2'b11)//乘法器状态
		begin
		point <= 1;
			case(scan_sel)
				4'd0:
					begin 
						seg_data <= X;
						seg_sel <= 6'b11_1110;
					end
			//第二与第四颗数码管片选信号删除，不点亮这两个
				4'd2:
					begin 
						seg_sel <= 6'b11_1011;
						seg_data <= Y;
					end

				4'd4:
					begin
						if(compute) //判断是否点亮这颗数码管
							begin	
								seg_sel <= 6'b10_1111;
								seg_data <= Z[7:4];
							end
						else
								seg_sel <= 6'b11_1111;
								seg_data <= Z[7:4];
					end
				4'd5:
					begin 
						if(compute)  //判断是否点亮这颗数码管
							begin
								seg_sel <= 6'b01_1111;
								seg_data <= Z[3:0];
							end
						else
								seg_sel <= 6'b11_1111;
								seg_data <= Z[3:0];
					end
				default:
					begin
						seg_sel <= 6'b11_1111;
						seg_data <= 0;
					end
			endcase
	   end
	else                 //其他状态
		begin
		point <= 1;
			case(scan_sel)
				4'd0:
					begin 
						seg_data <= 0;
						seg_sel <= 6'b11_1110;
					end
				4'd1:
					begin 
						seg_sel <= 6'b11_1101;
						seg_data <= 0;
					end
				4'd2:
					begin 
						seg_sel <= 6'b11_1011;
						seg_data <= 0;
					end
				4'd3:
					begin 
						seg_sel <= 6'b11_0111;
						seg_data <= 0;
					end
				4'd4:
					begin 
						seg_sel <= 6'b10_1111;
						seg_data <= 0;
					end
				4'd5:
					begin 
						seg_sel <= 6'b01_1111;
						seg_data <= 0;
					end
				default:
					begin
						seg_sel <= 6'b11_1111;
						seg_data <= 0;
					end
			endcase
	   end
	
end
endmodule


//点亮数码管模块 //译码器模块
module seg_decoder(
	input [3:0]seg_data,
	output reg [6:0]seg_led,
	input [1:0] crt
	);
//数码管段选信号，低电平使能
always@(seg_data)
begin
	case (seg_data)
		//用case语句实现译码器功能
						    // gfe dcba		//---a---
		4'h0: seg_led = 7'b100_0000;		//|		|
		4'h1: seg_led = 7'b111_1001;		//f		b
		4'h2: seg_led = 7'b010_0100;		//|		|
		4'h3: seg_led = 7'b011_0000;		//---g---
		4'h4: seg_led = 7'b001_1001;		//|		|
		4'h5: seg_led = 7'b001_0010;		//e		c
		4'h6: seg_led = 7'b000_0010;		//|		|
		4'h7: seg_led = 7'b111_1000;		//---d---
		4'h8: seg_led = 7'b000_0000;
		4'h9: seg_led = 7'b001_0000;
		4'ha: seg_led = 7'b000_1000;
		4'hb: seg_led = 7'b000_0011;
		4'hc: seg_led = 7'b100_0110;
		4'hd: seg_led = 7'b010_0001;
		4'he: seg_led = 7'b000_0110;
		4'hf: seg_led = 7'b000_1110;
	endcase
end
endmodule


//激励文件
`timescale 1ns/1ns
module test;
	reg clk;
	reg [7:0]BUT;
	wire [7:0]led;
	wire [5:0]seg_sel;
	wire [7:0]seg_led;
	wire [3:0]seg_data;
	project u1(clk,BUT,led,seg_sel,seg_led,seg_data);
	
	
	initial
	begin
			clk = 1'b0;
			BUT = 8'b1111_1110;				//复位信号作用，进入第一状态；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b0111_1111;				//状态切换按键按下，进入显示学号与流水灯状态。    因为所用的是时间消抖，且有按下不松开持续触发功能，所以每次按键置零后需要全置1；
		#50 BUT = 8'b1111_1111;
		
		#600 BUT = 8'b0111_1111;			//进入时钟状态；
		#50 BUT = 8'b1111_1111;
		
		#50 BUT = 8'b1110_1111;				//时钟开关按键按下，开始计时；
		#50 BUT = 8'b1111_1111;
		
		#6000 BUT = 8'b1110_1111;			//时钟开关再次按下，暂停计时；
		#50 BUT = 8'b1111_1111;
		
		#50 BUT = 8'b1101_1111;			//时钟清零按键按下，计数时间清零；
		#50 BUT = 8'b1111_1111;
		
		#50 BUT = 8'b1111_0001;			//时间设置按键按下，时、分、秒全部加一；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_0001;				//再加一；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_0001;				//再加一；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_0001;				//再加一；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_0001;				//再加一；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_0001;				//再加一；
		#50 BUT = 8'b1111_1111;
		
		#50 BUT = 8'b1110_1111;				//时钟开关按键按下，以06：06：06开始计时；
		#50 BUT = 8'b1111_1111;
		
		#500 BUT = 8'b0111_1111;			//进入乘法器状态；
		#50 BUT = 8'b1111_1111;
		
		#50 BUT = 8'b1111_1101;			//对乘数与被乘数进行幅值；
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1011;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;
		#50 BUT = 8'b1111_1101;
		#50 BUT = 8'b1111_1111;				//此时乘数为11，显示b;被乘数为7，显示7；
		
		
		#50 BUT = 8'b1111_0111;			//显示计算结果，显示4b；
		#50 BUT = 8'b1111_1111;	
		
		#500 BUT = 8'b1110_1111;			//置零按键按下，所有数置零，同时结果显示消失
		
		
		#500 BUT = 8'b0111_1111;			//回到最初状态；
		#50 BUT = 8'b1111_1111;
		
		#6000 $stop;
	end
	
	initial
	begin
		$monitor ($time,"::seg_sel = %b" ,seg_sel,
						"::seg_data = %d", test.u1.i10.seg_data,
						"::state = %b",test.u1.i6.o1,
						"::g_up = %b",test .u1.key7.key_flag,
						"::a_up = %b",test .u1.key1.key_flag,
						"::but8 = %b",test .u1.BUT,
						"::BUT = %b",test .BUT);
	end
	always
	begin
	#1 clk = ~clk;
	end
endmodule
		
		
实验报告中仿真波形是使用上述激励文件，并进行下面修改得到的。		
//key_debounce		
parameter 	CNT_MAX  = 20; 	

//hour
parameter CLK_FREQ = 50;

//led_crt
parameter CLK_FREQ = 500;

//seg_data
parameter SCAN_FREQ=50;
parameter CLK_FREQ = 500;