package Agent;
typedef enum bit {UVM_PASSIVE = 0 ,UVM_ACTIVE = 1} uvm_active_passive_enum;
import Driver::*;
import Sequencer::*;
import monitor::*;
import config_obj::*;
import seqeunce_item::*;



import uvm_pkg::*;
`include "uvm_macros.svh"

class Agent extends uvm_agent;
`uvm_component_utils(Agent)


Sequencer sqr;
Driver driver;
monitor mon;
config_obj config_obj_test;
config_obj config_obj_ref;
seqeunce_item_1 seq_item;
uvm_analysis_port #(seqeunce_item_1) agent_port;

function new(string name = "Agent" , uvm_component parent  = null);
	super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	config_obj_test = config_obj :: type_id :: create ("config_obj_test" , this);
	config_obj_ref = config_obj :: type_id :: create ("config_obj_ref" , this);
	agent_port = new("agent_port" , this);

	if(!uvm_config_db #(config_obj) :: get (this , "" , "ALL_CAN_TAKE_TEST" , config_obj_test))
	`uvm_fatal("build phase" , "failed to build in Agent")
	if(!uvm_config_db #(config_obj) :: get (this , "" , "ALL_CAN_TAKE_REF" , config_obj_ref))
	`uvm_fatal("build phase" , "failed to build in Agent")

	if (config_obj_test.active == UVM_ACTIVE) begin
		sqr    = Sequencer  :: type_id :: create ("sqr"    , this);
		driver = Driver     :: type_id :: create ("driver" , this);
		mon    = monitor    :: type_id :: create ("mon"    , this);
	end 
	else begin
		mon    = monitor :: type_id :: create ("mon" , this);
	end

endfunction 

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	mon.mon_port.connect(agent_port);

	if (config_obj_test.active == UVM_ACTIVE) begin

		driver.test_vif = config_obj_test.tested_vif;
		driver.ref_vif  = config_obj_ref.reference_vif;
		
		driver.seq_item_port.connect(sqr.seq_item_export);

		mon.test_vif = config_obj_test.tested_vif;
		mon.ref_vif  = config_obj_ref.reference_vif;
	end 
	else begin
		mon.test_vif = config_obj_test.tested_vif;
		mon.ref_vif  = config_obj_ref.reference_vif;
	end

	
endfunction 


endclass 
endpackage 