package scoreboard;

import seqeunce_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	seqeunce_item_1 seq_item;
	uvm_analysis_export # (seqeunce_item_1) sb_port;
	uvm_tlm_analysis_fifo # (seqeunce_item_1) sb_fifo;
	

	int error_count = 0;
	int correct_count = 0;

	function new(string name = "scoreboard" , uvm_component parent = null);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_port = new("sb_port" , this);
		sb_fifo = new("sb_fifo" , this);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_port.connect(sb_fifo.analysis_export);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sb_fifo.get(seq_item);
			if(seq_item.MISO != seq_item.MISO_ref) begin
				//`uvm_error("run_phase" , $sformatf("comparsion failed , Transaction received by the DUT:%S while the refrence out= %0b" , seq_item.convert2string , dataout_ref))
				error_count++;
			end
			else begin 
				correct_count++;
				`uvm_info("run_phase" , $sformatf("correct out= %0b" , seq_item.convert2string) , UVM_HIGH)
			end 
		end 
	endtask 


	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("report_phase" , $sformatf("total successfull transaction =%0d" , correct_count),UVM_MEDIUM )
		`uvm_info("report_phase" , $sformatf("total unsuccessfull transaction =%0d" , error_count),UVM_MEDIUM )
	endfunction 

endclass 
endpackage 