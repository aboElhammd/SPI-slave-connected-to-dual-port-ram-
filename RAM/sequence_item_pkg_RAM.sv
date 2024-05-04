package sequence_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class ram_sequence_item extends  uvm_sequence_item;
		`uvm_object_utils(ram_sequence_item);
		/*------------------------------------------------------------------------------
		--  new
		------------------------------------------------------------------------------*/
		function  new(string name ="sequence_item");
			super.new(name);
		endfunction : new
		/*------------------------------------------------------------------------------
		--  conver2string
		------------------------------------------------------------------------------*/
		function string convert2string();
			return $sformatf("%s din=%0h , rst_n=%0b , rx_valid=%0b,dout=%0h , tx_valid=%0b ",super.convert2string, din , rst_n, rx_valid, dout , tx_valid);
		endfunction : convert2string
		/*------------------------------------------------------------------------------
		--  parameters
		------------------------------------------------------------------------------*/
		parameter MEM_DEPTH=256;
		parameter MEM_WIDTH=8;
		/*------------------------------------------------------------------------------
		--variables  
		------------------------------------------------------------------------------*/
		rand logic [9:0] din;
		rand logic rst_n,rx_valid;
		logic tx_valid;
		logic [7:0] dout;
		logic [MEM_WIDTH-1:0] queue[$];
		logic [1:0] last_operation=2'b11;
		bit success,read_data_available,write_data_available;
		logic [7:0] test_write,test_read,last_address;
		/*------------------------------------------------------------------------------
		--constrains   
		------------------------------------------------------------------------------*/
		constraint reset    { rst_n    dist {1 := 98     , 0 := 2 };} // RAM_1
		constraint RX_valid { rx_valid dist {1 := 80     , 0 := 20};} // RAM_2
		constraint Din        { din[9:8] dist {[0:1] :/ 60 , [2:3] :/ 30};} // RAM_3
		constraint writing_constrains {  if(last_operation==2'b00 ) din[9:8]==2'b01;
										 
										 if(last_operation==2'b00) rx_valid==1;
							 		  } //RAM_3
		constraint reading_constrains  { if (din[9:8] == 2) { din[7:0] inside {queue};}
							 			 if (read_data_available){din[9:8]!=2'b10};
									     if (!read_data_available){din[9:8]!=2'b11}; 
									     if(!write_data_available) {din[9:8] !=2'b01}; //moved from writing constrains
										} // RAM_3
		/*------------------------------------------------------------------------------
		--functions   
		------------------------------------------------------------------------------*/
		function void post_randomize();
			if  (din[9:8] == 2'b01 &&rst_n&&rx_valid)begin 
				test_write = last_address;
				queue.push_back(last_address);
			end
			if( din[9:8] == 2'b10 && rst_n&&rx_valid)
				test_read=din[7:0];
			if(din[9:8]==2'b00 && rx_valid && rst_n ) begin
				write_data_available=1;
				last_address=din[7:0];
			end
			// if the operation is valid assign it in last operation	
			if(rst_n&&rx_valid)
				last_operation=din[9:8];
			if(rst_n && din[9:8]==2'b11)
				last_operation=2'b11;
			//setting variable to make sure that we have one read address operation followed by read data 
			if(last_operation==2'b11)
				read_data_available=0;
			else if(last_operation==2'b10)
				read_data_available=1;
			if(!rst_n)begin
				last_address=0;
			end
		endfunction : post_randomize

	endclass : ram_sequence_item
endpackage : sequence_item_pkg
