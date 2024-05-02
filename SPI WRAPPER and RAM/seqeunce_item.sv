package seqeunce_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;

	class seqeunce_item_2 extends uvm_sequence_item;
		`uvm_object_utils(seqeunce_item_2)
		rand logic rst_n;
		rand logic SS_n ;

		constraint c_2 {
		rst_n dist {0:=4 , 1:=96};
		SS_n dist {0:=95 , 1:=5};
		}


		function new(string name = "seqeunce_item_2");
			super.new(name);
		endfunction 
	endclass

	class seqeunce_item_1 extends uvm_sequence_item ;
		`uvm_object_utils(seqeunce_item_1)
		
		logic rst_n;
		logic SS_n ;
		logic MOSI;
		logic tx_valid;
		logic MISO;
		logic MISO_ref;
		logic rx_valid;
		logic [7:0] tx_data;
		logic [9:0] rx_data;
		rand bit [10:0] VAR_MOSI;
		logic write_address_available=0;
		logic read_address_available=0;
		logic [7:0] queue[$];
		logic [7:0] last_write_address;
		logic [1:0] last_operation=2'b11;
		logic [2:0] cs;
		bit write_addr;
		bit read_addr;
		int i;
		/*------------------------------------------------------------------------------
		-- CONSTRAINTS
		-------------------------------------------------------------------------------*/

		constraint MOSI_constrain {
			VAR_MOSI[10:8] dist {3'b000:=30,3'b001:=30,3'b110:=20,3'b111:=20} ; //SPI_3

		}
		constraint reading_from_trusted_places { //SPI_4
			if(VAR_MOSI[10:8]==3'b110 && queue.size() != 0){ VAR_MOSI[7:0] inside {queue}; }
			else if(queue.size()==0) {VAR_MOSI[10:8] !=3'b110 ; }
			
		}
		
		constraint next_instruction_consrtain { //SPI_4
			if(!read_address_available){
				VAR_MOSI[10:8]!=3'b111;
			}
			if(read_address_available){
				VAR_MOSI[10:8]!=3'b110;
			}
			if(!write_addr){
				VAR_MOSI[10:8]!=3'b001;
			}
		}
		function void succesful_operation();
			if( VAR_MOSI[10:8]==3'b000 && rst_n )begin
				write_address_available=1;
				write_addr=1;
				last_write_address=VAR_MOSI[7:0];
			end
			else 
				write_address_available=0;
			if(VAR_MOSI[10:8]===3'b001 && rst_n)begin
				queue.push_back(last_write_address);
			end
			if( VAR_MOSI[10:8]==3'b110  && rst_n )begin
				read_address_available=1;
			end
			else if(VAR_MOSI[10:8]==3'b111  && rst_n) 
				read_address_available=0;
			last_operation=VAR_MOSI[9:8];
			if(!rst_n) begin
				write_addr=0;
				read_address_available=0;
				last_write_address=0;
			end
		endfunction : succesful_operation
		function void clear_reg();
				write_addr=0;
				read_address_available=0;
				last_write_address=0;
		endfunction : clear_reg

		/*-------------------------------------------------------------------------------*/

		function new(string name = "seqeunce_item");
			super.new(name);
		endfunction 

		function string convert2string;
			return $sformatf("%s reset = %0b , SS_n = %0b , 10 bits MOSI = %0b  ", super.convert2string , rst_n ,
				SS_n , VAR_MOSI );
		endfunction 

		function string convert2string_stimulus ;
			return $sformatf("reset = %0b , SS_n = %0b , 10 bits MOSI = %0b  ", rst_n ,
				SS_n , VAR_MOSI);
		endfunction

	endclass 
endpackage