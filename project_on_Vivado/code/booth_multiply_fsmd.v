module booth_multiply_fsmd  #(parameter DATA_SIZE = 8 )
(
    input                           clk_i                   ,
    input                           reset_ni                ,
    input                           enable_i                ,
    input   [7 : 0]                 multiplicand_i          ,
    input   [7 : 0]                 multiplier_i            ,
    output                          data_valid_o            ,
    output  [1:0]                   current_state_o           ,   
    output  [7:0]                   count_debug           ,  
    output  [7:0]                   acc_debug           ,  
    output  [7:0]                   q_debug           ,  
    output  [15 : 0]                product_o
);
    // Declare state
    localparam      START                   =   2'b00           ;
    localparam      HANDLE_ACC              =   2'b01           ;
    localparam      ARITHMETIC_RIGHT_SHIFT  =   2'b10           ;
    localparam      FINISH                  =   2'b11           ;

    reg [1:0]   current_state               ;
    reg [1:0]   next_state                  ;

    // Decalare variale
    reg     [7:0]       acc                             ;
    reg     [7:0]       q                               ;
    reg                 q_1                             ;   //  LSB of multiplier before right shift
    reg     [7:0]       old_acc                         ;
    reg     [7:0]       old_q                           ;
    reg                 old_q_1                         ;
    reg     [7:0]       old_count                       ;
    reg     [15:0]      old_product                         ;
    reg     [7:0]       count                           ;  
    reg                 handle_acc_done                 ;

    // Decalare ouput net and connect them
    reg                 data_valid                      ;
    reg     [15:0]      product                         ;

    assign              data_valid_o    =   data_valid  ;
    assign              product_o       =   product     ;
   assign current_state_o           = current_state;      
    assign count_debug = count;
    assign acc_debug = acc;
    assign q_debug = q;
    // Current_state
    always @(posedge clk_i, negedge reset_ni) begin

        if(!reset_ni) begin
            current_state   <=  START       ;
        end
        else begin
            current_state   <=  next_state  ;    
        end
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
                    next_state  =   ARITHMETIC_RIGHT_SHIFT  ;
            
            ARITHMETIC_RIGHT_SHIFT  :
                if (count == 0)
                    next_state  =   FINISH  ;
                else
                    next_state  =   HANDLE_ACC  ;

            FINISH  :
                    next_state  =   START       ;
//                     next_state  =   FINISH       ;
                    
            default: 
                next_state  =   START       ;
        endcase
    end

//     //Output
//     always @(*) begin
//         case (current_state)
//             START   :   begin
//                 acc     =   0                   ;
//                 q       =   multiplier_i        ;
//                 q_1     =   0                   ;
//                 // count   =   8                   ;
//                 product     =   old_product     ;
//                 data_valid  =   0               ;
//                 handle_acc_done =   0           ;
//             end

//             HANDLE_ACC  :   begin
//                 if ( {q[0], q_1} == 2'b01 ) begin
//                     acc     =   acc + multiplicand_i    ;
//                 end

//                 else if ( {q[0], q_1} == 2'b10 ) begin
//                     acc     =   acc - multiplicand_i    ;
//                 end

//                 else begin
//                     acc             =   old_acc ;
//                 end
//                 q       =   old_q   ;
//                 q_1     =   old_q_1 ;
// //                count   =   old_count       ;
//                 // count   =   count       ;
//                 product =   old_product     ;
//                 data_valid  =   0   ;
//                 handle_acc_done =   1   ;
//             end

//             ARITHMETIC_RIGHT_SHIFT  : begin
//                 {acc, q, q_1}   =   {old_acc[7], old_acc, q}    ;
//                 // count   =   count - 1   ;
//                 product =   old_product ;
//                 data_valid  =   0   ;
//                 handle_acc_done =   0   ;
//             end

//             FINISH  : begin
//                 product     =   {acc,q}     ;
//                 data_valid  =   1           ;
//                 acc         =   old_acc     ;
//                 q           =   old_q       ;
//                 q_1         =   old_q_1     ;
//                 // count       =   0           ;
//                 handle_acc_done =   0       ;
//             end

//             default : begin
//                 acc     =   0                   ;
//                 q       =   0                   ;
//                 q_1     =   0                   ;
//                 // count   =   0                   ;
//                 product     =   0               ;
//                 data_valid  =   0               ;
//                 handle_acc_done =   0           ;
//             end
//         endcase
//     end

    // // internal signal to hold data in combinational logic above
    // always @(posedge clk_i, negedge reset_ni) begin
    //     if (~reset_ni) begin
    //         old_acc             <=   0                   ;
    //         old_q               <=   0                   ;
    //         old_q_1             <=   0                   ;
    //         old_count           <=  0                   ;
    //         old_product         <=  0                   ;
    //     end
    //     else begin
    //         old_acc             <=   acc                    ;
    //         old_q               <=   q                      ;
    //         old_q_1             <=   q_1                    ;
    //         old_count           <=   count                  ;
    //         old_product         <=   product                ;
    //     end
    // end

    always @(posedge clk_i or negedge reset_ni) begin : proc_count
        if(~reset_ni) begin
            count <= 0;
            acc <= 0;
            q <= 0;
            product <= 0;
            data_valid <= 0;
        end else begin
            if (current_state == START) begin
                data_valid  <=   0           ;
                count <= 7;
                q       <=   multiplier_i        ;
            end
            else if (current_state == HANDLE_ACC) begin
                if ( {q[0], q_1} == 2'b01 ) begin
                    acc     <=   acc + multiplicand_i    ;
                end

                else if ( {q[0], q_1} == 2'b10 ) begin
                    acc     <=   acc - multiplicand_i    ;
                end
                else acc <= acc;
            end
            else if (current_state == ARITHMETIC_RIGHT_SHIFT) begin
                 count   <=   count - 1   ;
                {acc, q, q_1}   <=   {acc[7], acc, q}    ;
            end
            else if (current_state == FINISH) begin
                count <= 0;
                product     <=   {acc,q}     ;
                data_valid  <=   1           ;
            end
            // else begin
            //     acc     <=   0                   ;
            //     q       <=   0                   ;
            //     q_1     <=   0                   ;
            //     count   <=   0                   ;
            //     product     <=   0               ;
            //     data_valid  <=   0               ;
            // end
        end
    end

endmodule