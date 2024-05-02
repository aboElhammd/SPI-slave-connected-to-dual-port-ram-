package Driver;

import seqeunce_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class Driver extends uvm_driver #(seqeunce_item_1);
	`uvm_component_utils(Driver)

	seqeunce_item_1 seq_item;
	virtual wrapper_interface_tested test_vif;
	virtual wrapper_interface_ref    ref_vif;

	function new (string name = "Driver" , uvm_component parent = null);
		super.new(name,parent);
	endfunction 

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item = seqeunce_item_1 :: type_id :: create ("seq_item");
			seq_item_port.get_next_item(seq_item);
			test_vif.rst_n = seq_item.rst_n;
			test_vif.SS_n  = seq_item.SS_n;
			test_vif.MOSI  = seq_item.MOSI;

			ref_vif.rst_n = seq_item.rst_n;
			ref_vif.SS_n  = seq_item.SS_n;
			ref_vif.MOSI  = seq_item.MOSI;
			@(negedge test_vif.clk)
			seq_item_port.item_done();
			`uvm_info("run_phase" , seq_item.convert2string_stimulus() , UVM_HIGH)
		end
	endtask 
endclass 
endpackage 

