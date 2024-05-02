package config_obj;

import uvm_pkg::*;
`include "uvm_macros.svh"

class config_obj extends uvm_object;
	`uvm_object_utils(config_obj)

	virtual wrapper_interface_tested tested_vif;
	virtual wrapper_interface_ref    reference_vif;

	function new (string name = "config_obj");
		super.new(name);
	endfunction 

endclass 
endpackage 

