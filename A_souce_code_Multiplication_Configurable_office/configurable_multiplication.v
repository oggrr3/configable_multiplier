module configurable_multiplication (
    input   [15:0]      multiplicand_i          ,
    input   [15:0]      multiplier_i            ,
    input               clk_i                   ,
    input               reset_ni                ,
    input               enable_i                ,
    input   [1:0]       cm_i                    ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

    output   [31:0]      product16x16_o          ,
    output              data_valid_o    
);
    
    //  Decalare variable
    wire     [7:0]       AH                      ;   //  multiplicand = {AH, AL}
    wire     [7:0]       AL                      ;   //  multipler    = {BH, BL}
    wire     [7:0]       BH                      ;
    wire     [7:0]       BL                      ;

    wire     [15:0]      AHBH_product            ;
    wire     [15:0]      AHBL_product            ;
    wire     [15:0]      ALBH_product            ;
    wire     [15:0]      ALBL_product            ;

    wire                AHBH_data_valid         ;
    wire                AHBL_data_valid         ;
    wire                ALBH_data_valid         ;
    wire                ALBL_data_valid         ;

    wire   [31:0]         extra_AHBH_product_o    ;
    wire   [31:0]         extra_AHBL_product_o    ;
    wire   [31:0]         extra_ALBH_product_o    ;
    wire   [31:0]         extra_ALBL_product_o    ;
    wire   [31:0]         extra_EVA_generator_o   ;
    wire   [31:0]         extra_EVB_generator_o   ;

    reg     [15:0]      EVA_generator           ;
    reg     [15:0]      EVB_generator           ;

    //  Decalare net of output and connect them
    reg   [31:0]      product16x16          ;
    reg               data_valid            ;

    assign      product16x16_o      =   product16x16        ;
    assign      data_valid_o        =   data_valid          ;
    assign      enable_to_SEU   =   AHBH_data_valid & AHBL_data_valid & ALBH_data_valid & ALBL_data_valid   ;

    assign      AH  =   multiplicand_i[15:8]    ;
    assign      AL  =   multiplicand_i[7:0]     ;
    assign      BH  =   multiplier_i[15:8]      ;
    assign      BL  =   multiplier_i[7:0]       ;

    assign      AHBH_enable =   (cm_i == 2'b01 || cm_i == 2'b10  ) ? enable_i : 0    ;
    assign      AHBL_enable =   (cm_i == 2'b10                   ) ? enable_i : 0    ;
    assign      ALBH_enable =   (cm_i == 2'b10                   ) ? enable_i : 0    ;
    assign      ALBL_enable =   enable_i    ;

    //  Instance
    booth_multiply_fsmd     AHBH    (
        .clk_i              (clk_i          )     ,
        .reset_ni           (reset_ni       )     ,
        .enable_i           (AHBH_enable    )     ,
        .multiplicand_i     (AH             )     ,
        .multiplier_i       (BH             )     ,
        .data_valid_o       (AHBH_data_valid)     ,
        .product_o          (AHBH_product   )
    );

    booth_multiply_fsmd     AHBL    (
        .clk_i              (clk_i          )     ,
        .reset_ni           (reset_ni       )     ,
        .enable_i           (AHBL_enable    )     ,
        .multiplicand_i     (AH             )     ,
        .multiplier_i       (BL             )     ,
        .data_valid_o       (AHBL_data_valid)     ,
        .product_o          (AHBL_product   )
    );

    booth_multiply_fsmd     ALBH    (
        .clk_i              (clk_i          )     ,
        .reset_ni           (reset_ni       )     ,
        .enable_i           (ALBH_enable    )     ,
        .multiplicand_i     (AL             )     ,
        .multiplier_i       (BH             )     ,
        .data_valid_o       (ALBH_data_valid)     ,
        .product_o          (ALBH_product   )
    );

    booth_multiply_fsmd     ALBL    (
        .clk_i              (clk_i          )     ,
        .reset_ni           (reset_ni       )     ,
        .enable_i           (ALBL_enable    )     ,
        .multiplicand_i     (AL             )     ,
        .multiplier_i       (BL             )     ,
        .data_valid_o       (ALBL_data_valid)     ,
        .product_o          (ALBL_product   )
    );

    sign_extra_unit         SEU     (
        .enable_i                (enable_to_SEU ),
        .AHBH_product_i          (AHBH_product  ),
        .AHBL_product_i          (AHBL_product  ),
        .ALBH_product_i          (ALBH_product  ),
        .ALBL_product_i          (ALBL_product  ),
        .EVA_generator_i         (EVA_generator ),
        .EVB_generator_i         (EVB_generator ),

        .extra_AHBH_product_o    (extra_AHBH_product_o),
        .extra_AHBL_product_o    (extra_AHBL_product_o),
        .extra_ALBH_product_o    (extra_ALBH_product_o),
        .extra_ALBL_product_o    (extra_ALBL_product_o),
        .extra_EVA_generator_o   (extra_EVA_generator_o),
        .extra_EVB_generator_o   (extra_EVB_generator_o)
    );

    // EV generator
    always @(*) begin

        if (cm_i == 2'b10)
            case ( {multiplicand_i[7], multiplier_i[7]} )
            2'b11   :   begin
                EVA_generator   =   {multiplicand_i[15:8], 1'b0, multiplicand_i[6:0]}   ;
                EVB_generator   =   {multiplier_i[15:8], 1'b0, multiplier_i[6:0]}       ;
            end

            2'b10   :   begin
                EVA_generator   =   0               ;
                EVB_generator   =   multiplier_i    ;
            end

            2'b01   :   begin
                EVA_generator   =   multiplicand_i  ;
                EVB_generator   =   0               ;
            end

            2'b00   :   begin
                EVA_generator   =   0               ;
                EVB_generator   =   0               ;
            end
            endcase
        else begin
            EVA_generator   =   0               ;
            EVB_generator   =   0               ;
        end

        // Generate enable signals
        case (cm_i)
            2'b00        :  begin
                if (ALBL_product[15]) begin
                            product16x16[31:16]   =   16'b1111_1111_1111_1111  ;
                            product16x16[15:0]    =   ALBL_product              ;
                        end
                        else begin
                            product16x16[31:16]   =   16'b0000_0000_0000_0000  ;
                            product16x16[15:0]    =   ALBL_product              ;
                        end
                data_valid      =   ALBL_data_valid     ;
            end

            2'b01   : begin
                product16x16[31:16]    =   AHBH_product ;
                product16x16[15:0]     =   ALBL_product ;
                data_valid             =   AHBH_data_valid & ALBL_data_valid    ;
            end

            2'b10   : begin
                product16x16    =   extra_AHBH_product_o + extra_AHBL_product_o + extra_ALBH_product_o + extra_ALBL_product_o +
                                    extra_EVA_generator_o + extra_EVB_generator_o   ;
                data_valid      =   AHBH_data_valid & AHBL_data_valid & ALBH_data_valid & ALBL_data_valid   ;

            end

            default :   begin
                product16x16    =   0     ;
                data_valid      =   0     ;
            end
        endcase

    end
endmodule