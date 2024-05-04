package test_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_pkg::*;
	import environment_pkg::*;
	import sequence_item_pkg::*;
	import config_object_pkg::*;
	class ram_test extends  uvm_test;
		`uvm_component_utils(ram_test);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="test",uvm_component parent =null);
			super.new(name,parent);
		endfunction : new
		/*------------------------------------------------------------------------------
		-- declarations  
		------------------------------------------------------------------------------*/
		reset_sequence seq_1;
		many_writes_sequence seq_2;
		//write_read_sequence seq_3;
		ram_environment env;
		ram_config_object obj;
		virtual ram_interface test_vif;
		/*------------------------------------------------------------------------------
		--build_phase   
		------------------------------------------------------------------------------*/
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			seq_1=reset_sequence::type_id::create("seq_1");
			seq_2=many_writes_sequence::type_id::create("seq_2");
			//seq_3=write_read_sequence::type_id::create("seq_3");
			obj=ram_config_object::type_id::create("obj");
			env=ram_environment::type_id::create("env",this);
			if(! uvm_config_db#(virtual ram_interface)::get(this, "", "v_if_1",obj.object_vif ))
				`uvm_error("test build phase","cannot get virual interface");
			uvm_config_db#(ram_config_object)::set(this, "*", "CFG", obj);
		endfunction : build_phase
		/*------------------------------------------------------------------------------
		--run_phase   
		------------------------------------------------------------------------------*/
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
				`uvm_info("run phase _1 ","before any seq",UVM_MEDIUM);
				seq_1.start(env.agent.sequencer);
				`uvm_info("run phase _1","after reset sequence",UVM_MEDIUM);
				seq_2.start(env.agent.sequencer);
				`uvm_info("run phase _1 ","after first sequence",UVM_MEDIUM);
			//	seq_3.start(env.agent.sequencer);
			//	`uvm_info("run phase _1 ","after second sequence",UVM_MEDIUM);
			phase.drop_objection(this);
		endtask : run_phase

	endclass : ram_test
endpackage : test_pkg
