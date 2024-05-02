interface ram_interface (input clk);
	logic [9:0]din;
	logic rst_n,rx_valid;
	logic tx_valid;
	logic [7:0]dout;
endinterface : ram_interface
