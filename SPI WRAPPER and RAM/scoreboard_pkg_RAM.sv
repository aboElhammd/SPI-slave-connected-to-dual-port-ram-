package scoreboard_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import sequence_item_pkg::*;
	 class ram_scoreboard extends  uvm_scoreboard;
	 	`uvm_component_utils(ram_scoreboard);
	 	/*------------------------------------------------------------------------------
	 	--  new
	 	------------------------------------------------------------------------------*/
	 	function  new(string name= "scoreboard",uvm_component parent = null) ;
			super.new(name,parent);
		endfunction : new
	 	/*------------------------------------------------------------------------------
	 	--  declarations
	 	------------------------------------------------------------------------------*/
	 	uvm_analysis_export #(ram_sequence_item) sb_export;
	 	uvm_tlm_analysis_fifo #(ram_sequence_item) sb_fifo;
	 	ram_sequence_item sb_seq_item;
	 	parameter MEM_DEPTH=256;
		parameter MEM_WIDTH=8;
		logic [MEM_WIDTH-1:0] mem[logic[MEM_DEPTH-1:0]]; 
		logic[7:0]dout_ref;
		logic tx_valid_ref;
		logic [7:0] wr_addr, rd_addr;
		int error_count=0;
		int correct_count=0;
 	 	/*------------------------------------------------------------------------------
	 	--build_phase  
	 	------------------------------------------------------------------------------*/
	 	function void build_phase(uvm_phase phase);
	 		super.build_phase(phase);
	 		sb_export=new("sb_export",this);
	 		sb_fifo=new("sb_fifo",this);
	 	endfunction : build_phase
	 	/*------------------------------------------------------------------------------
	 	--connect phase  
	 	------------------------------------------------------------------------------*/
	 	function void connect_phase(uvm_phase phase );
	 		super.connect_phase(phase);
	 		sb_export.connect(sb_fifo.analysis_export);
	 	endfunction : connect_phase
	 	/*------------------------------------------------------------------------------
	 	--  run_phase
	 	------------------------------------------------------------------------------*/
	 	task run_phase(uvm_phase phase);
	 		//`uvm_info("run_phase","started",UVM_MEDIUM);
	 		super.run_phase(phase);
	 		forever begin
		 		//`uvm_info("scoreboard","before get",UVM_MEDIUM);
		 		sb_fifo.get(sb_seq_item);
		 		//`uvm_info("scoreboard","after get and before ref ",UVM_MEDIUM);
		 		golden_ref(sb_seq_item);
		 		//`uvm_info("scoreboard","after ref",UVM_MEDIUM);
		 		if(dout_ref != sb_seq_item.dout || tx_valid_ref != sb_seq_item.tx_valid) begin
		 			error_count++;
		 			`uvm_error("scoreboard",$sformatf("error : data is %s while reference out is dout = %0h and tx_valid = %0b @ time = %0t",sb_seq_item.convert2string() , dout_ref, tx_valid_ref , $time));
		 		end
		 		else begin
		 			correct_count++;
		 		end
	 		end
	 	endtask : run_phase
	 	/*------------------------------------------------------------------------------
	 	--golden_ref  
	 	------------------------------------------------------------------------------*/
	 	task golden_ref(ram_sequence_item seq_item_test);
	 		//`uvm_info("scoreboard","entering golden ref",UVM_MEDIUM);
			if (!seq_item_test.rst_n) begin
				dout_ref=0;
				tx_valid_ref=0;
				wr_addr=0;
				rd_addr=0;
			end
			else begin
				case (seq_item_test.din[MEM_WIDTH+1:8]) 
					2'b00:begin
						if(seq_item_test.rx_valid) 
							wr_addr=seq_item_test.din[MEM_WIDTH-1:0];
							tx_valid_ref=0;
						
					end
					2'b01:begin
						if(seq_item_test.rx_valid)  
							mem[wr_addr]=seq_item_test.din[MEM_WIDTH-1:0];
							tx_valid_ref=0;
						
					end
					2'b10:begin
						if(seq_item_test.rx_valid)  
							rd_addr=seq_item_test.din[MEM_WIDTH-1:0];
							tx_valid_ref=0;
						
					end
					2'b11:begin
						dout_ref=mem[rd_addr];
						tx_valid_ref=1;
					end
					endcase
			end	 		
	 	endtask : golden_ref
	 	/*------------------------------------------------------------------------------
	 	--report_phase  
	 	------------------------------------------------------------------------------*/
	 	function void report_phase(uvm_phase phase );
			super.report_phase(phase);
			`uvm_info("report phase",$sformatf("correct iterations = %0d", correct_count),UVM_MEDIUM);
			`uvm_info("report phase",$sformatf("wrong iterations = %0d", error_count),UVM_MEDIUM)
		endfunction : report_phase
	 endclass : ram_scoreboard
endpackage : scoreboard_pkg
