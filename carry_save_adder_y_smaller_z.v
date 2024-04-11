// we assume that DATA_SIZE_y < DATA_SIZE_z, => carry out has DATA_SIZE_Z bit

module carry_save_adder_y_smaller_z   #(parameter  DATA_SIZE_x    =   8,
                                        parameter   DATA_SIZE_y   =   9,
                                        parameter   DATA_SIZE_z   =   10)
(
    input   [DATA_SIZE_x - 1 : 0]   x_i       ,
    input   [DATA_SIZE_y - 1 : 0]   y_i       ,
    input   [DATA_SIZE_z - 1 : 0]   z_i       ,
    output  [DATA_SIZE_z - 1 : 0]   u_o       ,                     //  sum:    U(i) = parity (xi, yi, zi)
    output  [DATA_SIZE_z - 1 : 0]   v_o                             //  carry:  V(i + 1) = majority (xi, yi, zi), V0 = 0.
);
            
    assign  v_o[0]  =   0                   ;                       //  carry out [0] always is 0

    genvar  i   ;
    generate                                                        //  Handle from bit 0 to bit DATA_SIZE_x - 1
        for (i = 0; i < DATA_SIZE_x; i = i + 1) begin : GEN_FULLADDER
            fulladder fulladder_i (
                .a_i        (x_i[i] )       ,
                .b_i        (y_i[i] )       ,
                .carry_i    (z_i[i] )       ,
                .sum_o      (u_o[i] )       ,
                .carry_o    (v_o[i + 1] ) 
            );
        end
    endgenerate

    genvar  j   ;
    generate                                                        //  Handle from bit DATA_SIZE_x to bit DATA_SIZE_y - 1
        for (j = DATA_SIZE_x ;   j < DATA_SIZE_y ;  j = j + 1 ) begin
            assign  u_o[j]      =    y_i[j] ^ z_i[j]            ;
            assign  v_o[j+1]    =    y_i[j] & z_i[j]            ;  
        end
    endgenerate

    genvar  k   ;
    generate                                                        //  Handle from bit DATA_SIZE_y to bit DATA_SIZE_z - 2
        for (k = DATA_SIZE_y ;   k < (DATA_SIZE_z - 1) ;  k = k + 1 )   begin
            assign  u_o[k]      =    z_i[k]            ;
            assign  v_o[k+1]    =    z_i[k]            ;  
        end
    endgenerate

    assign  u_o[DATA_SIZE_z - 1]    =   z_i[DATA_SIZE_z - 1]    ;   //  Handle DATA_SIZE_z - 1 bit

endmodule