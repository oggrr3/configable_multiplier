module wallace_tree_multiplier_top_tb ();
    
    reg    [7:0]       multiplier_i        ;
    reg    [7:0]       multiplicand_i      ;
    wire   [15:0]      product_o           ;

    // dut
    wallace_tree_multiplier_top     dut
    (
        .multiplier_i   (multiplier_i   )     ,
        .multiplicand_i (multiplicand_i )     ,
        .product_o      (product_o      )  
    );

    initial begin
        multiplier_i    =   255   ;
        multiplicand_i  =   10  ;
        $display("Ket qua :%d", product_o)     ;
        #5;

        multiplier_i    =   63   ;
        multiplicand_i  =   101  ;
        $display("Ket qua :%d", product_o)     ;
        #5;

        multiplier_i    =   155   ;
        multiplicand_i  =   255  ;
        $display("Ket qua :%d", product_o)     ;
        #5;
        multiplier_i    =   255   ;
        multiplicand_i  =   255    ;
        $display("Ket qua :%d", product_o)     ;
        #5;

        $stop;
    end
endmodule