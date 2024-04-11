module wallace_tree_multiplier_top (
    input   [7:0]       multiplier_i        ,
    input   [7:0]       multiplicand_i      ,
    output  [15:0]      product_o           
);

    // Decalare net
    wire      [7  : 0]       m0         ;
    wire      [8  : 0]       m1         ;
    wire      [9  : 0]       m2         ;
    wire      [10 : 0]       m3         ;
    wire      [11 : 0]       m4         ;
    wire      [12 : 0]       m5         ;
    wire      [13 : 0]       m6         ;
    wire      [14 : 0]       m7         ;
    wire      [14 : 0]       sum        ;
    wire      [15 : 0]       carry      ;
    wire      [16 : 0]       product_tem    ;

    assign  product_o   =   m0 + m1 + m2 + m3 + m4 + m5 + m6 + m7;

    //assign  product_o   =   product_tem[15:0]   ;

    // Struct
    partial_product_generator   partial_product_generator1
    (
        .multiplier_i   (multiplier_i   )                    ,
        .multiplicand_i (multiplicand_i )                    ,
        .m0_o           (m0             )                    ,
        .m1_o           (m1             )                    ,
        .m2_o           (m2             )                    ,
        .m3_o           (m3             )                    ,
        .m4_o           (m4             )                    ,
        .m5_o           (m5             )                    ,
        .m6_o           (m6             )                    ,
        .m7_o           (m7             )                    
    );

    // compression_wallace_tree    compression_wallace_tree1
    // (
    //     .m0_i           (m0             )                    ,
    //     .m1_i           (m1             )                    ,
    //     .m2_i           (m2             )                    ,
    //     .m3_i           (m3             )                    ,
    //     .m4_i           (m4             )                    ,
    //     .m5_i           (m5             )                    ,
    //     .m6_i           (m6             )                    ,
    //     .m7_i           (m7             )                    ,
    //     .sum_o          (sum            )                    ,
    //     .carry_o        (carry          )
    // );
    
    // ripple_carry_adder  #(16)      ripple_carry_adder1
    // (
    //     .a_i    ({1'b0, sum}    )         ,
    //     .b_i    (carry          )         ,
    //     .sum_o  (product_tem    )       
    // );

endmodule