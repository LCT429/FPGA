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