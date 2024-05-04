package config_object_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class ram_config_object extends uvm_object;
		`uvm_object_utils(ram_config_object);
		virtual ram_interface object_vif;
		function  new(string name="config_object");
			super.new(name);
		endfunction : new
	endclass : ram_config_object
endpackage : config_object_pkg
