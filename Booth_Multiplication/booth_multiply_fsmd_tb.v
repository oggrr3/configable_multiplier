module booth_multiply_fsmd_tb ();
    reg                           clk_i                   ;
    reg                           reset_ni                ;
    reg                           enable_i                ;
    reg   [7 : 0]                 multiplicand_i          ;
    reg   [7 : 0]                 multiplier_i            ;
    wire                          data_valid_o            ;
    wire  [15 : 0]                product_o               ;

    reg     [7:0]       acc                             ;
    reg     [7:0]       q                               ;
    reg                 q_1                             ;   //  LSB of multiplier before right shift
    reg     [7:0]       count                           ; 
    reg     [7:0]       next_acc                             ;
    reg     [7:0]       next_q                               ;
    reg                 next_q_1                             ; 

    // dut
    booth_multiply_fsmd dut (
        .clk_i              (clk_i          )     ,
        .reset_ni           (reset_ni       )     ,
        .enable_i           (enable_i       )     ,
        .multiplicand_i     (multiplicand_i )     ,
        .multiplier_i       (multiplier_i   )     ,
        .data_valid_o       (data_valid_o   )     ,
        .product_o          (product_o      )
    );

    always  #5  clk_i   =   ~clk_i  ;

    initial begin

        acc =   8'b0000_0000;
        q  = 8'b0000_0001;
        q_1 =   0;

        clk_i   =   0   ;
        reset_ni    =   0   ;
        enable_i    =   0   ;
        multiplicand_i  =   8'b0111_1001   ;
        multiplier_i    =   8'b1001_1101   ;
        #5;
        $display("{acc,q,q_1} = %0b  at time = %0t", {acc,q,q_1}, $time)  ;
        reset_ni    =   1   ;
        #3;
        enable_i    =   1   ;
        //{acc, q, q_1}   =  {acc[7], acc, q}    ;
        acc =   acc - multiplicand_i    ;
        $display("{acc,q,q_1} = %0b  at time = %0t", {acc,q,q_1}, $time)  ;
        #5;
        //enable_i =  0;
        {acc, q, q_1}   =  {acc[7], acc, q}    ;
        $display("{acc,q,q_1} = %0b  at time = %0t", {acc,q,q_1}, $time)  ;

        repeat(5) begin
        #5;
        {acc, q, q_1}   =  {acc[7], acc, q}    ;
        $display("{acc,q,q_1} = %0b = 0%b  at time = %0t", {acc[7],acc,q}, {acc, q, q_1}, $time)  ;
        end


    end
endmodule