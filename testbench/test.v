module test ();
    reg  signed [9:0] b = 10'b11_0101_0101;
    wire  [9:0] a_signed;
    wire        [9:0] a_unsigned; 


     assign   a_signed   = b >>> 2;
    assign    a_unsigned = b >>  2;

    always @(*) begin
    $display("#signed   %b", a_signed);
    $display("#unsigned %b", a_unsigned);
    $display("#2's of %b is %b ",a_signed, (~a_signed)+1 );
    end
    
endmodule