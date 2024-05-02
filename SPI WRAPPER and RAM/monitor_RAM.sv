package monitor_pkg;
	import uvm_pkg::*;
	import sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class ram_monitor extends  uvm_monitor;
		`uvm_component_utils(ram_monitor);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name= "monitor",uvm_component parent = null) ;
			super.new(name,parent);
		endfunction : new
		/*------------------------------------------------------------------------------
		--declarations  
		------------------------------------------------------------------------------*/
		ram_sequence_item monitor_seq_item;
		virtual ram_interface monitor_vif;
		uvm_analysis_port #(ram_sequence_item) mon_ap;
		/*------------------------------------------------------------------------------
		--  build_phase 
		------------------------------------------------------------------------------*/
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap=new("mon_ap",this);
		endfunction : build_phase
		/*------------------------------------------------------------------------------
		-- run_phase   
		------------------------------------------------------------------------------*/
		task run_phase(uvm_phase phase );
			super.run_phase(phase);
			forever begin
				monitor_seq_item=ram_sequence_item::type_id::create("monitor_seq_item");
				@(negedge monitor_vif.clk) 
				monitor_seq_item.rst_n=monitor_vif.rst_n;
				monitor_seq_item.din=monitor_vif.din;
				monitor_seq_item.rx_valid=monitor_vif.rx_valid;
				monitor_seq_item.tx_valid=monitor_vif.tx_valid;
				monitor_seq_item.dout=monitor_vif.dout;
				if(monitor_vif.din[9:8]==2'b00)
					monitor_seq_item.test_write=monitor_vif.din[7:0];
				if(monitor_vif.din[9:8]==2'b10)
					monitor_seq_item.test_read =monitor_vif.din[7:0];
				if (monitor_vif.din[9:8]==2'b11 && !monitor_vif.tx_valid )begin
					@(posedge monitor_vif.clk)
					#1;
					monitor_seq_item.tx_valid=monitor_vif.tx_valid;
					monitor_seq_item.dout=monitor_vif.dout;
				end 
				else if(monitor_vif.din[9:8] !== 2'b11 && monitor_vif.tx_valid) begin
					@(posedge monitor_vif.clk)
					#1;
					monitor_seq_item.tx_valid=monitor_vif.tx_valid;
				end

				mon_ap.write(monitor_seq_item);
				 `uvm_info("monitor run phase",$sformatf("monitoring at time %0t data is %s", $time(), monitor_seq_item.convert2string()),UVM_HIGH);
			end
		endtask: run_phase
	endclass : ram_monitor
endpackage : monitor_pkg
