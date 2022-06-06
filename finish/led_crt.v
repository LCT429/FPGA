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