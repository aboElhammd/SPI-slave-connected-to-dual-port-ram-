package config_obj;

import uvm_pkg::*;
`include "uvm_macros.svh"

class config_obj extends uvm_object;
	`uvm_object_utils(config_obj)

	uvm_active_passive_enum active;
	virtual wrapper_interface_tested tested_vif;
	virtual wrapper_interface_ref    reference_vif;
	virtual ram_interface            ram_vif;
	function new (string name = "config_obj");
		super.new(name);
	endfunction 

endclass 
endpackage 

