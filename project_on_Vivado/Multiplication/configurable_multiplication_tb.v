//`timescale 1ns/1ps

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

     wire    [15:0]    product_31_16 ;
     wire    [15:0]    product_15_0  ;

    assign  product_31_16 =   product16x16_o[31:16]   ;
    assign  product_15_0  =   product16x16_o[15:0]    ;
     //dut
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
        clk_i       =   0;
        reset_ni    =   1;
        enable_i    =   1;
        cm_i        =   2'b00;
        multiplicand_i  =   16'b1000_0000_1000_1101 ;
        multiplier_i    =   16'b0000_0001_0000_0100 ;
        #5;
        reset_ni    =   1   ;
        #10;
        enable_i    =   1   ;
        #500;
        $stop;
    end
endmodule