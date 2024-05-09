module ripple_carry_adder   #(parameter DATA_SIZE = 8) 
(
    input   [DATA_SIZE - 1 : 0]       a_i         ,
    input   [DATA_SIZE - 1 : 0]       b_i         ,
    output  [DATA_SIZE     : 0]       sum_o       
);

    //  Decaler net
    wire    [DATA_SIZE : 0]    temp_carry                   ;

    assign  temp_carry[0]       =   0                       ;
    assign  sum_o[DATA_SIZE]    =   temp_carry[DATA_SIZE]   ;

    genvar  index   ;

    generate
        for (index = 0; index < DATA_SIZE ; index = index + 1 ) begin   :   GEN_FULLADDER
            fulladder   fulladder_i (
                .a_i        (a_i[index]             )       ,
                .b_i        (b_i[index]             )       ,
                .carry_i    (temp_carry[index]      )       ,
                .sum_o      (sum_o[index]           )       ,
                .carry_o    (temp_carry[index + 1]  ) 
            );
        end
    endgenerate
    
endmodule