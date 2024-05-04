package agent_pkg;
	import uvm_pkg::*;
	import driver_pkg::*;
	import monitor_pkg::*;
	import sequencer_pkg::*;
	import sequence_item_pkg::*;
	import config_object_pkg::*;
	
	`include "uvm_macros.svh"
	class ram_agent extends  uvm_agent;
		`uvm_component_utils(ram_agent);
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		ram_driver driver;
		ram_monitor monitor;
		ram_sequencer sequencer;
		uvm_analysis_port #(ram_sequence_item) agt_port;
		ram_config_object obj;
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name= "agent",uvm_component parent = null) ;
			super.new(name,parent);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  build_phase
		------------------------------------------------------------------------------*/
		function void build_phase (uvm_phase phase); //getting conig object
			super.build_phase(phase);
			driver=ram_driver::type_id::create("driver",this);
			monitor=ram_monitor::type_id::create("monitor",this);
			sequencer=ram_sequencer::type_id::create("sequencer",this);
			agt_port=new("agt_port",this);
			if(!uvm_config_db#(ram_config_object)::get(this, "", "CFG",obj ))
				`uvm_error(" build phase","error in agent");
		endfunction : build_phase 
		/*------------------------------------------------------------------------------
		--  connect_phase
		------------------------------------------------------------------------------*/
		function void connect_phase(uvm_phase phase); //connecting interfaces is missing 
			super.connect_phase(phase);
			driver.seq_item_port.connect(sequencer.seq_item_export);
			monitor.mon_ap.connect(agt_port);
			driver.driver_vif=obj.object_vif;
			monitor.monitor_vif=obj.object_vif;
		endfunction : connect_phase
	endclass : ram_agent
endpackage : agent_pkg
