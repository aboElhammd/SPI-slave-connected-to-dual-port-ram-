package monitor;

import seqeunce_item::*;
typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;
import uvm_pkg::*;
`include "uvm_macros.svh"

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)

// states_e cs_mon;
int i;
int cs;
virtual wrapper_interface_tested test_vif;
virtual wrapper_interface_ref    ref_vif;
logic [10:0] VAR_MOSI;
seqeunce_item_1 seq_item;
uvm_analysis_port #(seqeunce_item_1) mon_port;

function new(string name = "monitor" , uvm_component parent = null);
	super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	mon_port = new("mon_port" , this);
endfunction 

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		seq_item = seqeunce_item_1 :: type_id :: create ("seq_item");
		@(negedge test_vif.clk)
		seq_item.rst_n = test_vif.rst_n;
		seq_item.SS_n  = test_vif.SS_n;
		seq_item.MOSI  = test_vif.MOSI;
		seq_item.MISO  = test_vif.MISO;
		seq_item.MISO_ref = ref_vif.MISO_ref;
		/*----------------------------------------------------
		-- ADD SIGNALS FOR COVERAGE
		----------------------------------------------------*/
		seq_item.tx_valid = test_vif.tx_valid;
		seq_item.rx_valid = test_vif.rx_valid;
		seq_item.cs       = test_vif.cs;
		cs=seq_item.cs;
		if( seq_item.cs == 3'b001 ) begin
				i=0;
				VAR_MOSI=0;
		end
		else if(i<=10 ) begin 
				VAR_MOSI[10-i]=test_vif.MOSI;
				i++;
				if( i ==11 && VAR_MOSI[10:9]!=2'b11) begin
					seq_item.VAR_MOSI=VAR_MOSI;
					seq_item.i=i;
				end
		end
		else if(VAR_MOSI[10:9]==2'b11&&i==11) begin // this is done to make sure that when we have read data operation tx_valid is equal to 11
			seq_item.VAR_MOSI=VAR_MOSI;
			seq_item.i=i;
			i++;
		end			
		/*--------------------------------------------------*/
		mon_port.write(seq_item);
		`uvm_info("run_phase" , seq_item.convert2string() , UVM_HIGH);
	end
endtask
endclass 
endpackage 