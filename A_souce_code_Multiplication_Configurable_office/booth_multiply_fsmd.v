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
    wire     [7:0]       old_acc                         ;
    wire     [7:0]       old_q                           ;
    wire                 old_q_1                         ;
    //reg     [7:0]       old_count                       ;
    reg     [7:0]       count                           ;  
    wire                handle_acc_done                 ;

    // Decalare ouput net and connect them
    wire                 data_valid                      ;
    wire     [15:0]      product                         ;

    assign              data_valid_o    =   data_valid  ;
    assign              product_o       =   (multiplicand_i == 8'b1000_0000) ? ( (~product) + 1 ) : product     ;

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
                if (enable_i)
                    next_state  =   START       ;
                else
                    next_state  =   FINISH  ;
                    
            default: 
                next_state  =   START       ;
        endcase
    end

    //Output
    always @(posedge clk_i, negedge reset_ni) begin
        if (~reset_ni) begin
            acc     <=   0;
            q       <=   0;
            q_1     <=   0;
        end
        else begin
            case (current_state)
                START   :   begin
                    
                    acc     <=   0                   ;
                    q       <=   multiplier_i        ;
                    q_1     <=   0                   ;

                end
    
                HANDLE_ACC  :   begin
                    if ( {q[0], q_1} == 2'b01 ) begin
                        acc     <=   acc + multiplicand_i    ;
                    end
    
                    else if ( {q[0], q_1} == 2'b10 ) begin
                        acc     <=   acc - multiplicand_i    ;
                    end
    
                    else begin
                        acc             <=   old_acc ;
                    end
                    q       <=   old_q   ;
                    q_1     <=   old_q_1 ;

                end
    
                ARITHMETIC_RIGHT_SHIFT  : begin

                    {acc, q, q_1}   <=   {old_acc[7], old_acc, q}    ;

                end
    
                FINISH  : begin
                    acc         <=   old_acc     ;
                    q           <=   old_q       ;
                    q_1         <=   old_q_1     ;
                end
    
               
            endcase
        end
    end

    assign product         = (current_state == FINISH) ? {acc,q} : 0;
    assign handle_acc_done = (current_state == HANDLE_ACC) ? 1:0;
    assign data_valid      = (current_state == FINISH) ? 1:0 ;

    always @(posedge clk_i, negedge reset_ni) begin
        if (~reset_ni) begin
            count           <=  0                   ;
        end
        else begin
            case (current_state)
                START   :   begin   
                    count   <=   7                   ; 
                end
                ARITHMETIC_RIGHT_SHIFT  : begin
                    count   <=   count - 1   ;
                end
            endcase
        end
    end
    
    assign old_acc             =   acc                    ;
    assign old_q               =   q                      ;
    assign old_q_1             =   q_1                    ;
endmodule