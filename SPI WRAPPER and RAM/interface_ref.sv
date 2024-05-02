interface wrapper_interface_ref (clk);
	input clk;
	logic MOSI ;
	logic SS_n ;
	logic rst_n;
	logic MISO_ref;

	modport WR_REF (input clk, MOSI , SS_n , rst_n , output MISO_ref);
endinterface : wrapper_interface_ref
