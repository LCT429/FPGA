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