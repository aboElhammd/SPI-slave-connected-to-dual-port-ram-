package coverage;
	typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;
import seqeunce_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class coverage extends uvm_component;
	`uvm_component_utils(coverage)

seqeunce_item_1 seq_item;
uvm_analysis_export #(seqeunce_item_1) cov_port;
uvm_tlm_analysis_fifo #(seqeunce_item_1) cov_fifo;

		covergroup cvr_gp;

		VAR_MOSI_label:coverpoint seq_item.VAR_MOSI { //SPI_3
			wildcard bins write_addr_mosi = {11'b000_????_????};
			wildcard bins write_data_mosi = {11'b001_????_????};
			wildcard bins read_addr_mosi  = {11'b110_????_????};
			wildcard bins read_data_mosi  = {11'b111_????_????};	
		}

		rx_valid_label:coverpoint seq_item.rx_valid {//SPI_3
			bins zero_rx_valid = {0};
			bins one_rx_valid  = {1};
		}

		tx_valid_label:coverpoint seq_item.tx_valid {//SPI_3
			bins zero_tx_valid = {0};
			bins one_tx_valid  = {1};
		}

		

		CROSS_VAR_MOSI_WITH_rx_valid:cross VAR_MOSI_label , rx_valid_label { //SPI_3
			ignore_bins ignore_read_data        = binsof(VAR_MOSI_label.read_data_mosi);
			ignore_bins ignore_zero_of_rx_valid = binsof(rx_valid_label.zero_rx_valid);
		}
		 
		CROSS_VAR_MOSI_WITH_tx_valid:cross VAR_MOSI_label , tx_valid_label {  //SPI_3
			ignore_bins ignore_write_addr       = binsof(VAR_MOSI_label.write_addr_mosi);
			ignore_bins ignore_write_data       = binsof(VAR_MOSI_label.write_data_mosi);
			ignore_bins ignore_read_addr        = binsof(VAR_MOSI_label.read_addr_mosi);
			ignore_bins ignore_zero_of_tx_valid = binsof(tx_valid_label.zero_tx_valid);
		}


		endgroup
		covergroup cvr_gp_2;
			states_label:coverpoint seq_item.cs { //SPI_4
				bins idle      = {0};
				bins chk_cmd   = {1};
				bins read_addr = {2};
				bins read_data = {3};
				bins write     = {4};
			}
			SS_n_label:coverpoint seq_item.SS_n {//SPI_2
				bins zero_SS_n = {0};
				bins one_SS_n  = {1};
			}

			rst_n_label:coverpoint seq_item.rst_n { //SPI_1
				bins zero_rst_n = {0};
				bins one_rst_n  = {1};	
			}
			transitions_label:coverpoint seq_item.cs {//SPI_4
				bins transition_read_addr = (IDLE=>CHK_CMD=>READ_ADD[*10:15]=>IDLE);
				bins transition_read_data = (IDLE=>CHK_CMD=>READ_DATA[*10:15]=>IDLE);
				bins transition_write     = (IDLE=>CHK_CMD=>WRITE[*10:15]=>IDLE);
			} 
			
		endgroup : cvr_gp_2

function new(string name = "coverage" , uvm_component parent = null);
	super.new(name,parent);
	cvr_gp = new;
	cvr_gp_2 = new;
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	cov_port = new("cov_port" , this);
	cov_fifo = new("cov_fifo" , this);
endfunction 

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase); 
	cov_port.connect(cov_fifo.analysis_export);
endfunction 

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		cov_fifo.get(seq_item);
		if(seq_item.i==11)
			cvr_gp.sample();
		cvr_gp_2.sample();
	end
endtask 
endclass 
endpackage
