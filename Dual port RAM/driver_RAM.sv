package driver_pkg;
	import uvm_pkg::*;
	import sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class ram_driver extends  uvm_driver #(ram_sequence_item);
		`uvm_component_utils(ram_driver);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name= "driver",uvm_component parent = null) ;
			super.new(name,parent);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		virtual ram_interface driver_vif;
		ram_sequence_item driver_seq_item;
		/*------------------------------------------------------------------------------
		--  run_phase
		------------------------------------------------------------------------------*/
		task run_phase(uvm_phase phase );
			super.run_phase(phase);
			forever begin
				driver_seq_item=ram_sequence_item::type_id::create("driver_seq_item");
				seq_item_port.get_next_item(driver_seq_item);
					`uvm_info("driver run phase",$sformatf("driving at time %0t and data is %s", $time(), driver_seq_item.convert2string()),UVM_HIGH);
					driver_vif.rst_n=driver_seq_item.rst_n;
					driver_vif.din=driver_seq_item.din;
					driver_vif.rx_valid=driver_seq_item.rx_valid;
					@(negedge  driver_vif.clk);
					`uvm_info("driver run phase",$sformatf("data equals %s", driver_seq_item.convert2string()),UVM_HIGH);
				seq_item_port.item_done();
			end
		endtask : run_phase
	endclass : ram_driver
endpackage : driver_pkg
