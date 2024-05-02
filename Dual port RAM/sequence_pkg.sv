package sequence_pkg;
	import uvm_pkg::*;
	import sequence_item_pkg::*;
	`include "uvm_macros.svh" 
	class reset_sequence extends  uvm_sequence #(ram_sequence_item) ;

		`uvm_object_utils(reset_sequence);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="reset_sequence");
			super.new(name);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		ram_sequence_item seq_item;
		/*------------------------------------------------------------------------------
		--  body_task
		------------------------------------------------------------------------------*/
		task body();
			seq_item=ram_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n=0;
			finish_item(seq_item);
		endtask : body
	endclass : reset_sequence
	/*------------------------------------------------------------------------------
	-- in this sequence each 00 is followed by 01 to write many times 
	------------------------------------------------------------------------------*/
	class many_writes_sequence extends  uvm_sequence#(ram_sequence_item);
		`uvm_object_utils(many_writes_sequence);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="many_writes_sequence");
			super.new(name);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  declarations
		------------------------------------------------------------------------------*/
		ram_sequence_item seq_item;
		/*------------------------------------------------------------------------------
		--  body_task
		------------------------------------------------------------------------------*/
		task body();
			seq_item=ram_sequence_item::type_id::create("seq_item");
			repeat (2000) begin
				start_item(seq_item);
				assert(seq_item.randomize());
			//	seq_item.post_randomize_user();
				finish_item(seq_item);
			end
			seq_item.writing_constrains.constraint_mode(0);
			repeat (2000) begin
				start_item(seq_item);
				assert(seq_item.randomize());
			//	seq_item.post_randomize_user();
				finish_item(seq_item);
			end
		endtask : body
	endclass : many_writes_sequence
	/*------------------------------------------------------------------------------
	-- in this sequence we write and read   
// 	------------------------------------------------------------------------------*/
// 	class write_read_sequence extends  uvm_sequence #(ram_sequence_item);
// 		`uvm_object_utils(write_read_sequence);
// 		/*------------------------------------------------------------------------------
// 		--  new
// 		------------------------------------------------------------------------------*/
// 		function  new(string name ="write_read_sequence");
// 			super.new(name);
// 		endfunction : new
// 		/*------------------------------------------------------------------------------
// 		--  declarations
// 		------------------------------------------------------------------------------*/
// 		ram_sequence_item seq_item;
// 		/*------------------------------------------------------------------------------
// 		--  body_task
// 		------------------------------------------------------------------------------*/
// 		task body();
// 			seq_item=ram_sequence_item::type_id::create("seq_item");
// 			seq_item.writing_constrains.constraint_mode(0);
// 			repeat (1000) begin
// 				start_item(seq_item);
// 				assert(seq_item.randomize());
// 				seq_item.post_randomize_user();
// 				finish_item(seq_item);
// 			end
// 		endtask : body
// 	endclass : write_read_sequence
 endpackage : sequence_pkg
