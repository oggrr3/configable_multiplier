module configurable_multiplication_tb ();
    reg   [15:0]      multiplicand_i          ;
    reg   [15:0]      multiplier_i            ;
    reg               clk_i                   ;
    reg               reset_ni                ;
    reg               enable_i                ;
    reg   [1:0]       cm_i                    ;   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit
    
    reg     [3:0]   test ; 

    wire   [31:0]      product16x16_o         ;
    wire              data_valid_o            ;

    // dut
    configurable_multiplication dut (
    .multiplicand_i (multiplicand_i )          ,
    .multiplier_i   (multiplier_i   )           ,
    .clk_i          (clk_i          )         ,
    .reset_ni       (reset_ni       )         ,
    .enable_i       (enable_i       )         ,
    .cm_i           (cm_i           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

    .product16x16_o (product16x16_o )         ,
    .data_valid_o   (data_valid_o   )
    );

    always #5   clk_i = ~clk_i      ;

    initial begin
        clk_i   =   0;
        reset_ni    =   0;
        enable_i    =   0;
        cm_i    =   2'b01;
        multiplicand_i  =   16'b1001_1011_0100_1011 ;
        multiplier_i    =   16'b1101_0001_1011_1001 ;
        
        test = 4'b1010;
        #5;
        reset_ni = 1;
        #3;
        enable_i = 1;
        //$display("test = %0b, test mo rong = %0b", test,{ 4, {test}} );
        //#200;
        wait(data_valid_o);
        $display("AHBH = %d, AHBL = %d", product16x16_o[31:16], product16x16_o[15:0]);
        #20;
        
        $stop;
    end
endmodule