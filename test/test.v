module test ();
	wire [7:0] a;
	wire [10:0]	x	;
	assign a = 21;
	assign x = {a,3'b101};
	initial begin
		$display("%d", a);
	end


endmodule
