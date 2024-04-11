module compression_wallace_tree #(parameter DATA_SIZE = 16)
(
    input      [7  : 0]       m0_i                    ,
    input      [8  : 0]       m1_i                    ,
    input      [9  : 0]       m2_i                    ,
    input      [10 : 0]       m3_i                    ,
    input      [11 : 0]       m4_i                    ,
    input      [12 : 0]       m5_i                    ,
    input      [13 : 0]       m6_i                    ,
    input      [14 : 0]       m7_i                    ,
    output     [14 : 0]       sum_o                   ,
    output     [15 : 0]       carry_o
);

    wire       [9  : 0]       sum1_1                  ;
    wire       [9  : 0]       carry1_1                ;
    wire       [12 : 0]       sum1_2                  ;
    wire       [12 : 0]       carry1_2                ;
    wire       [12 : 0]       sum2_1                  ;
    wire       [12 : 0]       carry2_1                ;
    wire       [14 : 0]       sum2_2                  ;
    wire       [14 : 0]       carry2_2                ;
    wire       [14 : 0]       sum3_1                  ;
    wire       [14 : 0]       carry3_1                ;


    // Class 1
    carry_save_adder_y_smaller_z    #(8, 9, 10)    class1_1    (
        .x_i    (m0_i       )   ,
        .y_i    (m1_i       )   ,
        .z_i    (m2_i       )   ,
        .u_o    (sum1_1     )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry1_1   )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );

    carry_save_adder_y_smaller_z    #(11, 12, 13)    class1_2    (
        .x_i    (m3_i       )   ,
        .y_i    (m4_i       )   ,
        .z_i    (m5_i       )   ,
        .u_o    (sum1_2     )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry1_2   )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );
    
    // Class 2
    carry_save_adder_y_smaller_z    #(10, 10, 13)    class2_1    (
        .x_i    (sum1_1     )   ,
        .y_i    (carry1_1   )   ,
        .z_i    (sum1_2     )   ,
        .u_o    (sum2_1     )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry2_1   )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );

    carry_save_adder_y_smaller_z    #(13, 14, 15)    class2_2    (
        .x_i    (carry1_2   )   ,
        .y_i    (m6_i       )   ,
        .z_i    (m7_i       )   ,
        .u_o    (sum2_2     )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry2_2   )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );

    // Class 3
    carry_save_adder_y_smaller_z    #(13, 13, 15)    class3_1    (
        .x_i    (sum2_1     )   ,
        .y_i    (carry2_1   )   ,
        .z_i    (sum2_2     )   ,
        .u_o    (sum3_1     )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry3_1   )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );

    // Class 4
    carry_save_adder_y_equal_z      #(15, 15)        class4_1    (
        .x_i    (sum3_1     )   ,
        .y_i    (carry3_1   )   ,
        .z_i    (carry2_2   )   ,
        .u_o    (sum_o      )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (carry_o    )                               //  V(i + 1) = majority (xi, yi, zi), V0 = 0.
    );

endmodule