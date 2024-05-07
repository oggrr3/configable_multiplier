module multiplication_top (
    input               axi_clk_i           ,
    input               axi_reset_ni        ,

    // Slave AXI-Stream interface of DMA to DUT
    input               s_axis_valid_i      ,   
    input   [31:0]      s_axis_data_i       ,
    output              s_axis_ready_o      ,

    // Master AXI-Stream interface of DUT to DMA
    output              axi_valid_o         ,
    output  [31:0]      axi_data_o          ,
    input               axi_ready_i         ,

    // DUT
    input               clk_i                   ,   //  clk for DUT
    input               reset_ni                ,
    input               enable_i                ,
    input   [1:0]       cm_i                        //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

);

    reg             s_axis_ready        ;

    // DUT
    reg   [15:0]      multiplicand            ;
    reg   [15:0]      multiplier              ;
    reg               clk                     ;
    reg               reset_n                 ;
    reg               enable                  ;
    reg   [1:0]       cm                      ;   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

    wire   [31:0]      product16x16            ;
    wire               data_valid              ;

    // Connect ouput from DUT to Master AXI-Stream  
    assign  axi_valid_o     =   data_valid      ;
    assign  axi_data_o      =   product16x16    ;   
    

    //  DUT
    configurable_multiplication     multiplication  (
        .multiplicand_i (multiplicand   )         ,
        .multiplier_i   (multiplier     )         ,
        .clk_i          (clk_i          )         ,
        .reset_ni       (reset_ni       )         ,
        .enable_i       (enable_i       )         ,
        .cm_i           (cm_i           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

        .product16x16_o (product16x16   )         ,
        .data_valid_o   (data_valid     )
    );

    always @(posedge axi_clk_i, negedge axi_reset_ni) begin
        if (!axi_reset_ni) begin
            s_axis_ready    <=  0   ;
        end
        else begin
            //-----------Slave------------------
            if (s_axis_valid_i) begin
                s_axis_ready    <=  1   ;
            end
            else begin                          
                s_axis_ready    <=  0   ;
            end 

            if (s_axis_valid_i & s_axis_ready) begin
                multiplicand    =   s_axis_data_i[31:16]    ;
                multiplier       =   s_axis_data_i[15:0]     ;
            end
            
        end
    end

endmodule