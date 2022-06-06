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