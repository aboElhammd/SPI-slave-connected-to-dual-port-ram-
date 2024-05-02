module SPI_wraper_tested (wrapper_interface_tested.WR_TEST WR_test_if);

logic MOSI;
logic SS_n,clk,rst_n;
logic MISO;

/*-------------------------------------------------------
-- ASSIGNING VARIABELS TO INTERFACE
-------------------------------------------------------*/

assign MOSI  = WR_test_if.MOSI;
assign SS_n  = WR_test_if.SS_n;
assign clk   = WR_test_if.clk;
assign rst_n = WR_test_if.rst_n;
assign WR_test_if.MISO = MISO;

/*-----------------------------------------------------*/


wire [9:0]rx_data_din;
wire rx_valid,tx_valid;
wire [7:0]tx_data_dout;

slave s1 (MISO,MOSI,SS_n,clk,rst_n,rx_data_din,rx_valid,tx_data_dout,tx_valid);
Dual_port_RAM R1(clk,rst_n,rx_valid,rx_data_din,tx_data_dout,tx_valid);

endmodule


