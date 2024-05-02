module assertions (clk,rst_n,SS_n,rx_valid,tx_valid,rx_data, tx_data,cs  ,MISO);
	input clk ,rst_n, SS_n , rx_valid ,tx_valid,MISO; 
	input [9:0] rx_data;
	input [7:0] tx_data;
	input [2:0] cs;

	property checking_tx_valid_with_rx_data;
		@(posedge clk) disable iff(!rst_n || SS_n )(rx_data[9:8]==2'b11 ) |-> ##1 tx_valid;
	endproperty
	property checking_rx_valid_with_rx_data;
		@(posedge clk) disable iff(!rst_n || SS_n )(rx_data[9:8]!=2'b11 ) |-> rx_valid;
	endproperty
	property checking_ss_n;
		@(posedge clk)disable iff(!rst_n ) $rose(SS_n) |=> cs==3'b000;
	endproperty
	property tx_valid_still_high;
		@(posedge clk)disable iff(!rst_n || SS_n)  $rose(tx_valid) |=> $stable(tx_valid)[->7]; //
	endproperty
	property tx_data_still_high;
		@(posedge clk)disable iff(!rst_n || SS_n)  $rose(tx_valid) |=> $stable(tx_data)[->7]; //
	endproperty
		property reset_property;
		@(posedge clk)  $fell(rst_n) |=> !MISO; //
	endproperty
	

	checking_rx_valid_with_rx_data_label:assert property (checking_tx_valid_with_rx_data);
	checking_tx_valid_with_rx_data_label:assert property (checking_tx_valid_with_rx_data);
	checking_ss_n_label:assert property (checking_ss_n);
	tx_valid_still_high_label:assert property(tx_valid_still_high);
	tx_data_still_high_label:assert property(tx_data_still_high);
	reset_property_label:assert property (reset_property);
	
	checking_rx_valid_with_rx_data_label_cover:cover property (checking_tx_valid_with_rx_data);
	checking_tx_valid_with_rx_data_label_cover:cover property (checking_tx_valid_with_rx_data) ;
	checking_ss_n_label_cover:cover property (checking_ss_n) ;
	tx_valid_still_high_label_cover:cover property(tx_valid_still_high);
	tx_data_still_high_label_cover:cover property(tx_data_still_high);
	cover_property_label:cover property (reset_property);
endmodule : assertions
