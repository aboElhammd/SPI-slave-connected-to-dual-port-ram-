package Sequencer;
	import uvm_pkg::*;
 `include "uvm_macros.svh"
 import seqeunce_item::*;

class Sequencer extends uvm_sequencer #(seqeunce_item_1);
	`uvm_component_utils(Sequencer)

	function new (string name = "Sequencer" , uvm_component parent = null);
		super.new(name,parent);
	endfunction 
	
endclass 
endpackage

