package Test;

import environment_pkg::*;
import Sequence::*;
import config_obj::*;
import Enviroment::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class Test extends uvm_test;
	`uvm_component_utils(Test)

	virtual wrapper_interface_tested test_vif;
	virtual wrapper_interface_ref    ref_vif;
	virtual ram_interface            ram_vif;

	Enviroment env;
	ram_environment env_ram;

	config_obj config_obj_tested;
	config_obj config_obj_ref;
	config_obj config_obj_RAM;

	sequence_reset rst_seq;
	main_sequence main_seq;
	main_sequence_2 main_seq_2;


	function new (string name = "Test" , uvm_component parent = null);
		super.new(name,parent);
	endfunction 

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		config_obj_tested = config_obj :: type_id :: create ("config_obj_tested",this);
		config_obj_ref    = config_obj :: type_id :: create ("config_obj_ref"   ,this);
		config_obj_RAM    = config_obj :: type_id :: create ("config_obj_RAM"   ,this);

		config_obj_tested.active = UVM_ACTIVE;
		config_obj_RAM.active    = UVM_PASSIVE;

		env = Enviroment :: type_id :: create("env",this);
		env_ram = ram_environment :: type_id :: create ("env_ram" , this);

		rst_seq = sequence_reset :: type_id :: create ("rst_seq");
		main_seq = main_sequence :: type_id :: create ("main_seq");
		main_seq_2 = main_sequence_2 :: type_id :: create ("main_seq_2");


		if (! uvm_config_db # (virtual wrapper_interface_tested ) :: get(this , "" , "WR_test_if" , config_obj_tested.tested_vif))
		`uvm_error("build_phase" , "Test - Unable to get the virtual interface of the tested wrapper from uvm_config_db")

		if (! uvm_config_db # (virtual wrapper_interface_ref )   :: get(this , "" , "WR_ref_if" , config_obj_ref.reference_vif))
		`uvm_error("build_phase" , "Test - Unable to get the virtual interface of the reference wrapper from uvm_config_db")

		if (! uvm_config_db # (virtual ram_interface )           :: get(this , "" , "RAM_if"    , config_obj_RAM.ram_vif))
		`uvm_error("build_phase" , "Test - Unable to get the virtual interface of the RAM from uvm_config_db")

		uvm_config_db # (config_obj) :: set(this , "*" , "ALL_CAN_TAKE_TEST" , config_obj_tested);
		uvm_config_db # (config_obj) :: set(this , "*" , "ALL_CAN_TAKE_REF"  , config_obj_ref);
		uvm_config_db # (config_obj) :: set(this , "*" , "ALL_CAN_TAKE_RAM"  , config_obj_RAM);

		
	endfunction 

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
	/*-------------------------------------------
		/////// Reset sequence ///////
	---------------------------------------------*/
		`uvm_info("run_phase" , "reset Asserted" , UVM_LOW)
		rst_seq.start(env.ag.sqr);
		`uvm_info("run_phase" , "reset Deasserted" , UVM_LOW)

	/*-------------------------------------------
		/////// Main sequence ///////
	---------------------------------------------*/

		`uvm_info("run_phase" , "main_sequence started" , UVM_LOW)
		main_seq.start(env.ag.sqr);
		`uvm_info("run_phase" , "main_sequence ended" , UVM_LOW)

	/*-------------------------------------------
		/////// Main sequence 2 ///////
	---------------------------------------------*/

		`uvm_info("run_phase" , "main_sequence_2 started" , UVM_LOW)
		main_seq_2.start(env.ag.sqr);
		`uvm_info("run_phase" , "main_sequence_2 ended" , UVM_LOW)
		

		phase.drop_objection(this);
	endtask 
endclass 
endpackage 

