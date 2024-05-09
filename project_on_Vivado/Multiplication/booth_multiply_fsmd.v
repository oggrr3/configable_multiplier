module booth_multiply_fsmd  #(parameter DATA_SIZE = 8 )
(
    input                           clk_i                   ,
    input                           reset_ni                ,
    input                           enable_i                ,
    input   [7 : 0]                 multiplicand_i          ,
    input   [7 : 0]                 multiplier_i            ,
    output                          data_valid_o            ,
    output  [15 : 0]                product_o
);
    // Declare state
    localparam   START                   =   2'b00           ;
    localparam   HANDLE_ACC              =   2'b01           ;
    localparam   ARITHMETIC_RIGHT_SHIFT  =   2'b10           ;
    localparam   FINISH                  =   2'b11           ;

    reg [1:0]   current_state               ;
    reg [1:0]   next_state                  ;

    // Decalare variale
    reg     [7:0]       acc                             ;
    reg     [7:0]       q                               ;
    reg                 q_1                             ;   //  LSB of multiplier before right shift
    reg     [7:0]       old_acc                         ;
    reg     [7:0]       old_q                           ;
    reg     [7:0]       count                           ;  
    reg                 handle_acc_done                 ;

    // Decalare ouput net and connect them
    reg                 data_valid                      ;
    reg     [15:0]      product                         ;

    assign              data_valid_o    =   data_valid  ;
    assign              product_o       =   product     ;

    // Current_state
    always @(posedge clk_i, negedge reset_ni) begin

        if(!reset_ni) 
            current_state   <=  START       ;
        else 
            current_state   <=  next_state  ;    

    end

    // Next_state
    always @(*) begin
        case (current_state)
            START   :
                if(enable_i)
                    next_state  =   HANDLE_ACC  ;
                else
                    next_state  =   START   ; 

            HANDLE_ACC  :
                if (handle_acc_done)
                    next_state  =   ARITHMETIC_RIGHT_SHIFT  ;
                else
                    next_state  =   HANDLE_ACC  ;

            ARITHMETIC_RIGHT_SHIFT  :
                if (count == 0)
                    next_state  =   FINISH  ;
                else
                    next_state  =   HANDLE_ACC  ;

            FINISH  :
                if (~enable_i)
                    next_state  =   START       ;
                else
                    next_state  =   FINISH  ;

            default: 
                next_state  =   START       ;
        endcase
    end

    //Output
    always @(*) begin
        case (current_state)
            START   :   begin
                acc     =   0                   ;
                q       =   multiplier_i        ;
                q_1     =   0                   ;
                //count   =   8                   ;
                product     =   0               ;
                data_valid  =   0               ;
                handle_acc_done =   0           ;
            end

            HANDLE_ACC  :   begin
                if ( {q[0], q_1} == 2'b01 ) begin
                    acc     =   acc + multiplicand_i    ;
                    handle_acc_done =   1           ;
                end

                else if ( {q[0], q_1} == 2'b10 ) begin
                    acc     =   acc - multiplicand_i    ;
                    handle_acc_done =   1               ;
                end

                else begin
                    handle_acc_done =   1   ;
                end

            end

            ARITHMETIC_RIGHT_SHIFT  : begin
                {acc, q, q_1}   =   {acc[7], acc, q}    ;
                //count   =   count - 1   ;
            end

            FINISH  : begin
                product =   {acc,q} ;
                data_valid  =   1   ;
            end

        endcase
    end

    // COunt
    always @(posedge clk_i, negedge reset_ni) begin
        if(!reset_ni) 
            count   <=  0       ;
        case (current_state)
            START   :   begin
                count   <=   8                   ;
            end

            ARITHMETIC_RIGHT_SHIFT  : begin
                count   <=   count - 1   ;
            end

        endcase
    end 

    end

endmodule