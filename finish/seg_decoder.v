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