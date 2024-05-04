import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;
module top ();
bit clk;
initial begin
	forever begin
	#2 clk=~clk;	
	end
end
ram_interface ram_if(clk);
Dual_port_RAM DUT( ram_if.clk, ram_if.rst_n, ram_if.rx_valid, ram_if.din, ram_if.dout, ram_if.tx_valid);
initial begin
	uvm_config_db#(virtual ram_interface)::set(null, "uvm_test_top", "v_if_1",ram_if);
	run_test("ram_test");
end
endmodule : top
