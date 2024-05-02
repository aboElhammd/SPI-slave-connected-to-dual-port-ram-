import uvm_pkg::*;
import Test::*;
`include "uvm_macros.svh"
module top;
bit clk;

initial begin
	clk = 0;
	forever #2 clk = ~clk;
end

wrapper_interface_tested WR_test_if(clk);
wrapper_interface_ref    WR_ref_if (clk);
ram_interface            RAM_if    (clk);


SPI_wraper_tested WRAPPER_TESTED (WR_test_if);
spi_wrapper_ref   WRAPPER_REF    (WR_ref_if);
assertions ass_inst(WR_test_if.clk,WR_test_if.rst_n,WR_test_if.SS_n,WR_test_if.rx_valid,WR_test_if.tx_valid,WR_test_if.rx_data, WR_test_if.tx_data,WR_test_if.cs , WR_test_if.MISO );
/*----------------------------------------------------
-- ASSIGNING RAM SIGNALS
----------------------------------------------------*/
assign RAM_if.rx_valid = WRAPPER_TESTED.R1.rx_valid;
assign RAM_if.din      = WRAPPER_TESTED.R1.din;
assign RAM_if.dout     = WRAPPER_TESTED.R1.dout;
assign RAM_if.tx_valid = WRAPPER_TESTED.R1.tx_valid;
assign RAM_if.rst_n    = WRAPPER_TESTED.R1.rst_n;
/*--------------------------------------------------*/

/*----------------------------------------------------
-- ADD SIGNALS FOR COVERAGE AND ASSERTIONS
----------------------------------------------------*/
assign WR_test_if.rx_valid = WRAPPER_TESTED.s1.rx_valid;
assign WR_test_if.tx_valid = WRAPPER_TESTED.s1.tx_valid;
assign WR_test_if.tx_data=WRAPPER_TESTED.s1.tx_data;
assign WR_test_if.rx_data=WRAPPER_TESTED.s1.rx_data;
assign WR_test_if.cs       = WRAPPER_TESTED.s1.cs;
/*--------------------------------------------------*/

initial begin
	uvm_config_db # (virtual wrapper_interface_tested) :: set(null , "uvm_test_top" , "WR_test_if" , WR_test_if);
	uvm_config_db # (virtual wrapper_interface_ref)    :: set(null , "uvm_test_top" , "WR_ref_if"  , WR_ref_if );
	uvm_config_db # (virtual ram_interface)            :: set(null , "uvm_test_top" , "RAM_if"     , RAM_if    );
	run_test("Test");
end
endmodule 

