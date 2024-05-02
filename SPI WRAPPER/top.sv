import uvm_pkg::*;
import Test::*;
typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;
`include "uvm_macros.svh"
module top;
bit clk;

initial begin
	clk = 0;
	forever #1 clk = ~clk;
end

wrapper_interface_tested WR_test_if(clk);
wrapper_interface_ref    WR_ref_if (clk);


SPI_wraper_tested WRAPPER_TESTED (WR_test_if);
spi_wrapper_ref   WRAPPER_REF    (WR_ref_if);

/*----------------------------------------------------
-- ADD SIGNALS FOR COVERAGE
----------------------------------------------------*/
assign WR_test_if.rx_valid = WRAPPER_TESTED.s1.rx_valid;
assign WR_test_if.tx_valid = WRAPPER_TESTED.s1.tx_valid;
assign WR_test_if.cs       = WRAPPER_TESTED.s1.cs;
/*--------------------------------------------------*/

initial begin
	uvm_config_db # (virtual wrapper_interface_tested) :: set(null , "uvm_test_top" , "WR_test_if" , WR_test_if);
	uvm_config_db # (virtual wrapper_interface_ref)    :: set(null , "uvm_test_top" , "WR_ref_if"  , WR_ref_if );
	run_test("Test");
end
endmodule 

