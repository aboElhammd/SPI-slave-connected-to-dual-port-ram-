package agent_pkg;
	typedef enum bit {UVM_PASSIVE = 0 ,UVM_ACTIVE = 1} uvm_active_passive_enum;
	import uvm_pkg::*;
	import driver_pkg::*;
	import monitor_pkg::*;
	import sequencer_pkg::*;
	import sequence_item_pkg::*;
	import  config_obj::*;
	
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
		config_obj obj;
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
			obj = config_obj :: type_id :: create ("obj" , this);
			agt_port=new("agt_port",this);

			if(!uvm_config_db#(config_obj)::get(this, "", "ALL_CAN_TAKE_RAM",obj ))
			`uvm_error(" build phase","error in agent");

			if(obj.active == UVM_ACTIVE) begin
				driver=ram_driver::type_id::create("driver",this);
				monitor=ram_monitor::type_id::create("monitor",this);
				sequencer=ram_sequencer::type_id::create("sequencer",this);
			end 
			else begin 
				monitor=ram_monitor::type_id::create("monitor",this);
			end
		endfunction : build_phase 
		/*------------------------------------------------------------------------------
		--  connect_phase
		------------------------------------------------------------------------------*/
		function void connect_phase(uvm_phase phase); //connecting interfaces is missing 
			super.connect_phase(phase);
			monitor.mon_ap.connect(agt_port);
			
			if(obj.active == UVM_ACTIVE) begin
				driver.seq_item_port.connect(sequencer.seq_item_export);
				
				driver.driver_vif=obj.ram_vif;
				monitor.monitor_vif=obj.ram_vif;
			end 
			else begin
				monitor.monitor_vif=obj.ram_vif;
			end
		endfunction : connect_phase
	endclass : ram_agent
endpackage : agent_pkg
