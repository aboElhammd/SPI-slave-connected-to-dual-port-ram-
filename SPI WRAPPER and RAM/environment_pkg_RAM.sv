package environment_pkg;
	import uvm_pkg::*;
	import scoreboard_pkg::*;
	import agent_pkg::*;
	import coverage_pkg::*;
	
	`include "uvm_macros.svh"
	class ram_environment extends  uvm_env;
		`uvm_component_utils(ram_environment);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="environment" , uvm_component parent =null);
			super.new(name,parent);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		ram_agent agent;
		ram_scoreboard scoreboard;
		ram_coverage_collector coverage_collector;
		/*------------------------------------------------------------------------------
		-- build_phase  
		------------------------------------------------------------------------------*/
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agent=ram_agent::type_id::create("agent",this);
			scoreboard=ram_scoreboard::type_id::create("scoreboard",this);
			coverage_collector = ram_coverage_collector::type_id::create("coverage_collector",this);
		endfunction : build_phase
		/*------------------------------------------------------------------------------
		--  connect_phase
		------------------------------------------------------------------------------*/
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			agent.agt_port.connect(scoreboard.sb_export);
			agent.agt_port.connect(coverage_collector.cvg_export);
		endfunction : connect_phase
	endclass : ram_environment
endpackage : environment_pkg
