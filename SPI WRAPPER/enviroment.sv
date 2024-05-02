package Enviroment;

import Agent::*;
import coverage::*;
import scoreboard::*;

import uvm_pkg::*;

`include "uvm_macros.svh"

class Enviroment extends uvm_env;
	`uvm_component_utils(Enviroment)

	Agent ag;
	scoreboard sb;
	coverage cov;


	function new (string name = "Enviroment" , uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		sb  = scoreboard :: type_id :: create ("sb", this);
		ag  = Agent      :: type_id :: create ("ag", this);
		cov = coverage   :: type_id :: create ("cov",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ag.agent_port.connect(sb.sb_port);
		ag.agent_port.connect(cov.cov_port);
	endfunction 
	
endclass 
endpackage 

