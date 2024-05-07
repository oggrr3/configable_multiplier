`timescale 1ns/1ps

module configurable_multiplication_tb ();
    // reg   [15:0]      multiplicand_i          ;
    // reg   [15:0]      multiplier_i            ;
    // reg               clk_i                   ;
    // reg               reset_ni                ;
    // reg               enable_i                ;
    // reg   [1:0]       cm_i                    ;   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit
    
    // reg     [3:0]   test ; 

    // wire   [31:0]      product16x16_o         ;
    // wire              data_valid_o            ;

    // wire    [15:0]    product_31_16 ;
    // wire    [15:0]    product_15_0  ;
    
    //test for soc
    reg         clk_i   ;
    reg [31:0]  slv_reg0;
    reg [31:0]  slv_reg1;
    reg [31:0]  slv_reg2;
    reg [31:0]  slv_reg3;
    
    wire [31:0]	control;
	wire [31:0]	data_in;
	wire [31:0]	data_out;
	wire 	     done;
	
    assign control =   1;//slv_reg0    ;
    assign data_in =   slv_reg1    ;

//    assign  product_31_16 =   product16x16_o[31:16]   ;
//    assign  product_15_0  =   product16x16_o[15:0]    ;
    // dut
//    configurable_multiplication dut (
//    .multiplicand_i (multiplicand_i )          ,
//    .multiplier_i   (multiplier_i   )           ,
//    .clk_i          (clk_i          )         ,
//    .reset_ni       (reset_ni       )         ,
//    .enable_i       (enable_i       )         ,
//    .cm_i           (cm_i           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

//    .product16x16_o (product16x16_o )         ,
//    .data_valid_o   (data_valid_o   )
//    );

    // dut
    configurable_multiplication dut (
        .multiplicand_i (slv_reg1[31:16] )          ,
        .multiplier_i   (slv_reg1[15:0]   )           ,
        .clk_i          (clk_i          )         ,
        .reset_ni       (slv_reg0[0]       )         ,
        .enable_i       (slv_reg0[1]       )         ,
        .cm_i           (slv_reg0[3:2]           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

        .product16x16_o (data_out )         ,
        .data_valid_o   (done   )
   );

    // configurable_multiplication     multiplication  (
    //     .multiplicand_i (slv_reg1[31:16]   )         ,
    //     .multiplier_i   (slv_reg1[15:0]     )         ,
    //     .clk_i          (clk_i          )         ,
    //     .reset_ni       (slv_reg0[0]       )         ,
    //     .enable_i       (slv_reg0[1]       )         ,
    //     .cm_i           (slv_reg0[3:2]           )         ,   //  Choose mode : single 8 bit or two parallel 8 bit or single 16 bit 

    //     .product16x16_o (data_out   )         ,
    //     .data_valid_o   (done     )
    // );

    // always @( posedge clk_i )
	// begin
	//   if ( reset_ni == 1'b0 )
	//     begin
	//       slv_reg2     <=  0   ;
	//       slv_reg3     <=  0   ;
	//     end 
	//   else
	//     begin    
    //         slv_reg2     <=  data_out   ;
	//        slv_reg3[0]     <=  done   ;
	//     end
	// end

    always #5   clk_i = ~clk_i      ;

    initial begin
        //clk_i       =   0;
        //reset_ni    =   0;
        //enable_i    =   0;
        //cm_i        =   2'b10;
        //multiplicand_i  =   16'b1011_1001_0100_1001 ;
        //multiplier_i    =   16'b0101_0101_1001_0001 ;
        
        //#5;
        //reset_ni = 1;
        //#3;
        //enable_i = 1;
        //#10;
        //@(posedge clk_i);
        //enable_i = 0;
        //$display("AHBH = %b, AHBL = %b", product16x16_o[31:16], product16x16_o[15:0]);
        //@(posedge data_valid_o);    // wait for done
        //#50;
        
        // reset_ni    =   0;
        // cm_i    =   2'b00;
        // multiplicand_i  =   16'b1001_1011_0110_1101 ;
        // multiplier_i    =   16'b1101_0001_1001_1001 ;
        // #5;
        // reset_ni    =   1;
        // wait(data_valid_o);
        // $display("AHBH = %b, AHBL = %b", product16x16_o[31:16], product16x16_o[15:0]);
        // #20;

        // reset_ni    =   0;
        // cm_i    =   2'b10;
        // multiplicand_i  =   16'b1001_1011_0110_1101 ;
        // multiplier_i    =   16'b1101_0001_1001_1001 ;
        // #5;
        // reset_ni    =   1;
        // wait(data_valid_o);
        // $display("AHBH = %b, AHBL = %b", product16x16_o[31:16], product16x16_o[15:0]);
        // #20;

        //------------Starting test for soc
        clk_i       =   0;
        slv_reg0    =   8'h00;           // reset
        slv_reg1    =   (-3398<<16) + 7159;    // multiplicand and multiplier
        #5;

        slv_reg0    = 8'h0b;    // mode 16-bit, enable, reset off;
        @(posedge clk_i);
        slv_reg0 = 8'h09;    // mode 16-bit, disenable, reset off;
        @(posedge done);
        #50;
        //--------test2------------
        slv_reg1    =   (-938<<16) + 6859;    // multiplicand and multiplier
        slv_reg0    = 8'h07;    // pararllel 8-bit, enable, reset off;
        repeat(2) @(negedge clk_i);
        slv_reg0 = 8'h05;    // pararllel 8-bit, disenable, reset off;
        @(posedge done);
        #50;

        //--------test3------------
        slv_reg1    =   (5398<<16) + -11159;    // multiplicand and multiplier
        slv_reg0    = 8'h03;    // single 8-bit, enable, reset off;
        repeat(2) @(negedge clk_i);
        slv_reg0 = 8'h01;    // single 8-bit, disenable, reset off;
        @(posedge done);
        #50;

        slv_reg1    =   (13398<<16) + -2345;    // multiplicand and multiplier
        slv_reg0    = 8'h0b;    // single 16-bit, enable, reset off;
        //repeat(2) @(negedge clk_i);
        //slv_reg0 = 8'h01;    // single 8-bit, disenable, reset off;
        @(posedge done);
        #1000;
        $stop;
    end
endmodule