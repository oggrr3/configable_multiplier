module partial_product_generator    //#(parameter DATA_SIZE = 8)
(
    input       [7  : 0]       multiplier_i            ,
    input       [7  : 0]       multiplicand_i          ,
    output      [7  : 0]       m0_o                    ,
    output      [8  : 0]       m1_o                    ,
    output      [9  : 0]       m2_o                    ,
    output      [10 : 0]       m3_o                    ,
    output      [11 : 0]       m4_o                    ,
    output      [12 : 0]       m5_o                    ,
    output      [13 : 0]       m6_o                    ,
    output      [14 : 0]       m7_o                    
);

    assign  m0_o  = (multiplicand_i[0]) ? (multiplier_i     ) : 0   ;
    assign  m1_o  = (multiplicand_i[1]) ? (multiplier_i << 1) : 0   ;
    assign  m2_o  = (multiplicand_i[2]) ? (multiplier_i << 2) : 0   ;
    assign  m3_o  = (multiplicand_i[3]) ? (multiplier_i << 3) : 0   ;
    assign  m4_o  = (multiplicand_i[4]) ? (multiplier_i << 4) : 0   ;
    assign  m5_o  = (multiplicand_i[5]) ? (multiplier_i << 5) : 0   ;
    assign  m6_o  = (multiplicand_i[6]) ? (multiplier_i << 6) : 0   ;
    assign  m7_o  = (multiplicand_i[7]) ? (multiplier_i << 7) : 0   ;
    
endmodule
