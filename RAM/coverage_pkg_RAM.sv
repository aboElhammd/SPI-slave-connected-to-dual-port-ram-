package coverage_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_pkg::*;
	class ram_coverage_collector extends  uvm_component;
		`uvm_component_utils(ram_coverage_collector);
		
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		uvm_analysis_port #(ram_sequence_item) cvg_export;
		uvm_tlm_analysis_fifo #(ram_sequence_item) cvg_fifo;
		ram_sequence_item seq_item; 
		covergroup cvr_gp;
			reset:coverpoint    seq_item.rst_n    { bins ZERO_rst = {0}; bins ONE_rst = {1};} // RAM_1
			RX_valid:coverpoint seq_item.rx_valid { bins ZERO_rx = {0}; bins ONE_rx = {1};}   // RAM_2
			TX_valid:coverpoint seq_item.tx_valid { bins ZERO_tx = {0}; bins ONE_tx = {1};}	 // RAM_4
			Din:coverpoint      seq_item.din      { wildcard bins ZERO_din = {10'b00_????_????}; // RAM_3
										   wildcard bins ONE_din = {10'b01_????_????};
										   wildcard bins TWO_din = {10'b10_????_????};
										   wildcard bins THREE_din = {10'b11_????_????};
										 }
			Dout:coverpoint     seq_item.dout     { wildcard bins all_values = {8'b????_????};} // RAM_5
			Address_write:coverpoint seq_item.test_write     { bins all_range_of_addr = {[0:8'b1111_1111]};} // RAM_6
			Address_read:coverpoint seq_item.test_read     { bins all_range_of_addr = {[0:8'b1111_1111]};} // RAM_6
			////////////////////////////////////////////////////////////////////////////////////////
			rx_valid_with_din:cross Din,RX_valid;    // to see and check the effect of rx_valid in all operations . // RAM_3  RAM_2
			reading_with_tx_valid:cross TX_valid,Din{ // number of succesful reading operations // RAM_4 , RAM_3
													 ignore_bins ignored_zero_din=binsof(Din.ZERO_din);
													 ignore_bins ignored_one_din=binsof(Din.ONE_din);
													 ignore_bins ignored_two_din=binsof(Din.TWO_din);
													 ignore_bins ignored_low_tx=binsof(TX_valid.ZERO_tx);
													}
			rst_rx_din_11:cross RX_valid,Din,reset{ //make sure that reading operation and rx valid doesnot affect the output when we reset 
													// and to know how many succesful and unsucceful reading operations and compare number of succeful with the cross above
													// RAM_2 , RAM_3 , RAM_1
													ignore_bins ignored_zero_din=binsof(Din.ZERO_din);
													ignore_bins ignored_one_din=binsof(Din.ONE_din);
													ignore_bins ignored_two_din=binsof(Din.TWO_din);			
												}
			dout_with_tx_valid:cross TX_valid,Dout; //to check that tx_valid is always high when dout changes (if there is no reset ) // RAM_4
		endgroup
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="coverage_collector",uvm_component parent= null);
			super.new(name, parent);
			cvr_gp=new;
		endfunction : new
		/*------------------------------------------------------------------------------
		--build phase   
		------------------------------------------------------------------------------*/
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cvg_fifo=new("cvg_fifo",this);
			cvg_export=new("cvg_export",this);
		endfunction : build_phase
		/*------------------------------------------------------------------------------
		--  connect_phase 
		------------------------------------------------------------------------------*/
		function void connect_phase(uvm_phase phase );
			super.connect_phase(phase);
			cvg_export.connect(cvg_fifo.analysis_export);
		endfunction : connect_phase
		/*------------------------------------------------------------------------------
		-- run phase   
		------------------------------------------------------------------------------*/
		task run_phase(uvm_phase phase );
			super.run_phase(phase);
			forever begin
			cvg_fifo.get(seq_item);
			cvr_gp.sample();
		end
		endtask : run_phase
	endclass : ram_coverage_collector
endpackage : coverage_pkg
