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
