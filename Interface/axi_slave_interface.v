module axi_slave_interface (
    input   axi_clk_i   ,
    input   axi_reset_ni    ,
    input   s_axis_valid
    input   [31:0]   s_axis_data_i    ,
    output           s_axis_ready_o
);

    always @(posedge axi_clk_i, negedge axi_reset_ni) begin
        if () begin
            
        end
    end


endmodule