package Sequence ;
	import uvm_pkg::*;
`include "uvm_macros.svh"
import seqeunce_item::*;

class sequence_reset extends uvm_sequence #(seqeunce_item_1);
	`uvm_object_utils(sequence_reset)

	seqeunce_item_1 seq_item;

	function new(string name = "sequence_reset");
		super.new(name);
	endfunction 

	task body;
		seq_item = seqeunce_item_1 :: type_id :: create ("seq_item");
		start_item(seq_item);
		seq_item.rst_n = 0;
	//	seq_item.rst_n = 1;
	//	seq_item.SS_n  = 1;
		finish_item(seq_item);
	endtask 
endclass


 
class main_sequence extends uvm_sequence #(seqeunce_item_1);
	`uvm_object_utils(main_sequence)

	seqeunce_item_1 seq_item;
	seqeunce_item_2 seq_item_2;

	bit [10:0] VAR_MOSI;

	function new(string name = "main_sequence");
		super.new(name);
	endfunction 

	//////////////////////// TASK FOR ASSIGNING VAR_MOSI IN MOSI /////////////////
	//if vary reset =1 then rst and ss_n may chenge during sending bits otherwise they are stable 
	//sampling for testing rest is used to set correct timing for coverage so that we test the current state with the new value of rst and ss_n 
	//and we can make sure that we tested reset and ss_n from all states.
	task body;
		seq_item_2 = seqeunce_item_2 :: type_id :: create ("seq_item_2");
		seq_item   = seqeunce_item_1 :: type_id :: create ("seq_item");
		seq_item.rst_n=1;
		repeat(2000) begin
			assert(seq_item.randomize());
			seq_item.succesful_operation();
		//	seq_item.post_randomize_user();
			VAR_MOSI=seq_item.VAR_MOSI;
			start_item(seq_item);
			seq_item.SS_n = 0;
			finish_item(seq_item);
			for(int i=10;i>=0;i--) begin
				start_item(seq_item);
				// assert(seq_item_2.randomize);
				seq_item.MOSI=VAR_MOSI[i];
				finish_item(seq_item);
			end
			if(VAR_MOSI[10:8]==3'b111) begin
			for(int i=0;i<10;i++)//to read from mosi
				#4;
			end
			else 
				#8; // to give the data to memory .
			start_item(seq_item);
				seq_item.SS_n = 1;
			finish_item(seq_item);
		end
	endtask
endclass

class main_sequence_2 extends uvm_sequence #(seqeunce_item_1);
	`uvm_object_utils(main_sequence_2)

	seqeunce_item_1 seq_item;
	seqeunce_item_2 seq_item_2;

	bit [10:0] VAR_MOSI;

	function new(string name = "main_sequence_2");
		super.new(name);
	endfunction 

	//////////////////////// TASK FOR ASSIGNING VAR_MOSI IN MOSI /////////////////
	//if vary reset =1 then rst and ss_n may chenge during sending bits otherwise they are stable 
	//sampling for testing rest is used to set correct timing for coverage so that we test the current state with the new value of rst and ss_n 
	//and we can make sure that we tested reset and ss_n from all states.


	task body;
		seq_item_2 = seqeunce_item_2 :: type_id :: create ("seq_item_2");
		seq_item   = seqeunce_item_1 :: type_id :: create ("seq_item");
		seq_item.rst_n=1;
		repeat(1000) begin
			assert(seq_item.randomize());
		//	seq_item.post_randomize_user();
			VAR_MOSI=seq_item.VAR_MOSI;
			start_item(seq_item);
			seq_item.SS_n = 0;
			finish_item(seq_item);
			for(int i=10;i>=0;i--) begin
				start_item(seq_item);
				assert(seq_item_2.randomize);
				seq_item.MOSI=VAR_MOSI[i];
				seq_item.rst_n=seq_item_2.rst_n;
				seq_item.SS_n=seq_item_2.SS_n;
				finish_item(seq_item);
				if(!seq_item_2.rst_n || seq_item_2.SS_n) begin
					break ;
				end
			end
			if(!seq_item_2.rst_n || seq_item_2.SS_n) begin
					start_item(seq_item);
						seq_item.SS_n = 1;
					finish_item(seq_item);
					if(!seq_item_2.rst_n) seq_item.clear_reg();
					#2;
					continue ;
			end
			else begin
				seq_item.succesful_operation();
			end
			if(VAR_MOSI[10:8]==3'b111) begin
			for(int i=0;i<10;i++)//to read from mosi
				#4;
			end
			else 
				#8; // to give the data to memory .
			start_item(seq_item);
				seq_item.SS_n = 1;
			finish_item(seq_item);
		end
	endtask
endclass

endpackage


