typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;

interface wrapper_interface_tested (clk);
	input clk;
	logic MOSI;
	logic SS_n;
	logic rst_n;
	logic MISO;
	logic rx_valid ;
	logic tx_valid ;
	logic [2:0] cs;
	logic [9:0] rx_data;
	logic [7:0] tx_data;
	modport WR_TEST (input clk, MOSI , SS_n , rst_n , output MISO);
endinterface : wrapper_interface_tested
