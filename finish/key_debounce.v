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