module sign_extra_unit (
    input                   enable_i                ,
    input   [15:0]          AHBH_product_i          ,
    input   [15:0]          AHBL_product_i          ,
    input   [15:0]          ALBH_product_i          ,
    input   [15:0]          ALBL_product_i          ,
    input   [15:0]          EVA_generator_i         ,
    input   [15:0]          EVB_generator_i         ,

    output   [31:0]         extra_AHBH_product_o    ,
    output   [31:0]         extra_AHBL_product_o    ,
    output   [31:0]         extra_ALBH_product_o    ,
    output   [31:0]         extra_ALBL_product_o    ,
    output   [31:0]         extra_EVA_generator_o   ,
    output   [31:0]         extra_EVB_generator_o   

);

    //  Decalare reg of outputs
    reg   [31:0]         extra_AHBH_product    ;
    reg   [31:0]         extra_AHBL_product    ;
    reg   [31:0]         extra_ALBH_product    ;
    reg   [31:0]         extra_ALBL_product    ;
    reg   [31:0]         extra_EVA_generator   ;
    reg   [31:0]         extra_EVB_generator   ;

    assign  extra_AHBH_product_o    =   extra_AHBH_product  ;
    assign  extra_AHBL_product_o    =   extra_AHBL_product  ;
    assign  extra_ALBH_product_o    =   extra_ALBH_product  ;
    assign  extra_ALBL_product_o    =   extra_ALBL_product  ;
    assign  extra_EVA_generator_o   =   extra_EVA_generator ;
    assign  extra_EVB_generator_o   =   extra_EVB_generator ;

    //  Extra to 32 bit, if sign is 1, insert 1 bits in front of it. 
    //  Else if sign bit is 0, insert 0 bits in front of it
    always @(*) begin
        if (enable_i) begin
            extra_AHBH_product  =   AHBH_product_i  << 16                       ;

            if (AHBL_product_i[15]) begin
                //extra_AHBL_product  =   {8'b1111_1111, (AHBL_product_i << 8)}   ;
                extra_AHBL_product[31:24]   =   8'b1111_1111    ;
                extra_AHBL_product[23:0]    =   AHBL_product_i << 8 ;
            end
            else begin
                extra_AHBL_product[31:24]   =   8'b0000_0000    ;
                extra_AHBL_product[23:0]    =   AHBL_product_i << 8 ;
            end

            if (ALBH_product_i[15]) begin
                extra_ALBH_product[31:24]   =   8'b1111_1111    ;
                extra_ALBH_product[23:0]    =   ALBH_product_i << 8 ;
            end
            else begin
                extra_ALBH_product[31:24]   =   8'b0000_0000    ;
                extra_ALBH_product[23:0]    =   ALBH_product_i << 8 ;
            end
            
            if (ALBL_product_i[15]) begin
                extra_ALBL_product[31:16]   =   16'b1111_1111_1111_1111  ;
                extra_ALBL_product[15:0]    =   ALBL_product_i              ;
            end
            else begin
                extra_ALBL_product[31:16]   =   16'b0000_0000_0000_0000  ;
                extra_ALBL_product[15:0]    =   ALBL_product_i              ;
            end

            if (EVA_generator_i[15]) begin
                extra_EVA_generator[31:24]  =   8'b1111_1111    ;
                extra_EVA_generator[23:0]   =   EVA_generator_i << 8    ;
            end
            else begin
                extra_EVA_generator[31:24]  =   8'b0000_0000    ;
                extra_EVA_generator[23:0]   =   EVA_generator_i << 8    ;
            end

            if (EVB_generator_i[15]) begin
                extra_EVB_generator[31:24]  =   8'b1111_1111    ;
                extra_EVB_generator[23:0]   =   EVB_generator_i << 8    ;
            end
            else begin
                extra_EVB_generator[31:24]  =   8'b0000_0000    ;
                extra_EVB_generator[23:0]   =   EVB_generator_i << 8    ;
            end
        end

        else begin
            extra_AHBH_product      =   0   ;
            extra_AHBL_product      =   0   ;
            extra_ALBH_product      =   0   ;
            extra_ALBL_product      =   0   ;
            extra_EVA_generator     =   0   ;
            extra_EVB_generator     =   0   ;
        end
    end

endmodule