//全加器模块
module all_add(x,y,z,cin,cout);
	input x,y,cin;
	output z,cout;
	assign z=x^y^cin;
	assign cout=(x&y)|(x&cin)|(y&cin);
endmodule
