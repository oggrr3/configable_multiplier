module carry_save_tb ();
    /// for test let remote after finish
    reg [3:0] temp1;
    reg [1:0] temp2;
    wire [3:0] result;
    //------------------------------------------
    reg   [8 : 0]   x_i       ;
    reg   [8 : 0]   y_i       ;
    reg   [8 : 0]   z_i       ;
    wire  [8 : 0]   u_o       ;                     //  sum:    U(i) = parity (xi, yi, zi)
    wire  [9 : 0]   v_o       ; 

    wire   [10 : 0]  product     ;
    assign  product =   u_o + v_o   ;
    assign result = temp1 >>> temp2;//testtttt------------
    // dut
    carry_save_adder_y_equal_z #(9,9)      dut
    (
        .x_i    (x_i       )   ,
        .y_i    (y_i       )   ,
        .z_i    (z_i       )   ,
        .u_o    (u_o       )   ,                           //  U(i)     = parity (xi, yi, zi)
        .v_o    (v_o       )         
    );


    initial begin
        temp1 = 4'b1101;
        temp2 = 2'b01;
        //----------------------
        x_i =   101 ;
        y_i = 99    ;
        z_i = 23    ;
        #5;
        $display("Input a = %d, b = %d, c = %d, \t Product P = %d", x_i, y_i, z_i, product);
        #10;

        x_i = 0      ;
        y_i = 0    ;
        z_i = 0    ;
        #5;
        $display("Input a = %d, b = %d, c = %d, \t Product P = %d", x_i, y_i, z_i, product);
        #10;

        x_i = 255;
        y_i = 511    ;
        z_i = 102    ;
        #5;
        $display("Input a = %d, b = %d, c = %d, \t Product P = %d", x_i, y_i, z_i, product);
        #10;

        x_i = 255;
        y_i = 255    ;
        z_i = 255    ;
        #5;
        $display("Input a = %d, b = %d, c = %d, \t Product P = %d", x_i, y_i, z_i, product);
        #10;


        $display("Input a = %b, b = %b, c = %b, ", temp1, temp1 >> 2, temp1 >>> 2);
        $stop;

    end



endmodule