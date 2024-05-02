module spi_wrapper_ref(wrapper_interface_ref.WR_REF WR_ref_if);

logic MOSI,clk,rst_n,SS_n;
logic MISO;

/*-------------------------------------------------------
-- ASSIGNING VARIABELS TO INTERFACE
-------------------------------------------------------*/

assign MOSI  = WR_ref_if.MOSI;
assign SS_n  = WR_ref_if.SS_n;
assign clk   = WR_ref_if.clk;
assign rst_n = WR_ref_if.rst_n;
assign WR_ref_if.MISO_ref = MISO;

/*-----------------------------------------------------*/

wire [9:0] rx_data;
wire rx_valid,tx_valid;
wire [7:0]tx_data;
spi_slave_2 slave(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
ram memory(rx_data,clk,rst_n,rx_valid,tx_data,tx_valid);

endmodule
