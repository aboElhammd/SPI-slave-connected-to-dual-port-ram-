module slave(MISO,MOSI,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;

input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0]tx_data;

output  reg MISO ,rx_valid;
output reg [9:0] rx_data;

reg read_ad_flag;//if 1 the check command will go to the read adress if Zero the heya aret l adress yeb2a hya hatkteb now
reg [3:0] counter_tx;
reg [3:0]counter_rx=4'b1001;
reg [9:0] bus_rx;
reg[1:0]MOSI_var;
states_e cs,ns;
//new variables 
reg first_time;

//next state logic
always @(*) begin //ask sensityvityy listttttt????????? //edit incomplete sensitivity list.
	case(cs)
		IDLE: if (SS_n==0)  begin 
		        ns=CHK_CMD;
			  end 

			  else if (SS_n==1)begin
			     ns=IDLE;
			  end

		CHK_CMD:  if(SS_n==1) begin
					ns=IDLE;

				end
				else if (SS_n==0&&MOSI==0) begin//mosi her the first bit to checkk
				     ns =WRITE;
			     end
			     else if ( SS_n==0&&MOSI==1) begin
		       	if(read_ad_flag) begin
		       	    	ns=READ_ADD;
		       	end 
		       	else  begin
		       	    	ns=READ_DATA;
		       	end
			       end

		WRITE: 
			if (SS_n==0) begin//askkkkkkk
		          ns=WRITE;
			end
			else begin
			     ns=IDLE;
		     end

		READ_ADD:
			if(SS_n==1)begin
				ns=IDLE;
			end
			else  begin//kont hatet tx w shiltha fl condition	
				ns=READ_ADD; 	       	   
		     end

	     READ_DATA: if (SS_n==0 ) begin//kont hatet tx fl condotion
	    	        ns=READ_DATA;
	               end
	              else begin
	              	ns=IDLE;
	              end

	     default: ns=IDLE;

      endcase
 end




 //state memory
 always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		cs=IDLE;
	end
	else begin
		cs<=ns;
	end
end 


//output logic
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		read_ad_flag<=1;
		rx_data<=0;
		rx_valid<=0;
		MISO<=0;
	end
	case (cs)
		IDLE: begin
			 rx_data<=10'b00000_00000;//ask
			 counter_tx<=4'b0111;
			 counter_rx<=4'b1001;
			 rx_valid<=0;
			 first_time<=1;
		end
      	WRITE: begin
      		//part added because of assertions
      		`ifdef ASSERTIONS
		      	if(counter_rx==4'b1001||counter_rx==4'b1000&&first_time)
		      		MOSI_var[9-counter_rx]=MOSI;
	      	`endif
	  		////////////////////////////////////////////////////////////////////////////////////////////////////////////end of part needed for assertion.
			if (counter_rx==0 && first_time) begin//from serial to parralel /f insted of zero for nonvlocking edit 
	     		rx_valid<=1;
	     		rx_data<={bus_rx,MOSI};  ///edited :: mising bit in rx_data.
	     		first_time<=0;
	          end
	      	else begin  
			   	bus_rx<= {bus_rx,MOSI}; //edited to use shift register
			    	counter_rx<=counter_rx-1;
		   	end
   		end
		READ_ADD: begin
			//added part for assertions
			`ifdef ASSERTIONS  
				if(counter_rx==4'b1001||counter_rx==4'b1000&&first_time) 
					MOSI_var[9-counter_rx]=MOSI;
			`endif 
			//////////////////////////////////////////////end of added part 
			if (counter_rx==0&&first_time) begin//from serial to parralel 
	     		rx_valid<=1;
	     		rx_data<={bus_rx,MOSI};  ///edited :: mising bit in rx_data.
	     
	     		read_ad_flag<=0;
	     		first_time=0;
	          end
	     	else begin  
		   		bus_rx<= {bus_rx,MOSI}; //edited to use shift register
		    		counter_rx<=counter_rx-1;
		   	end
		end

		READ_DATA: begin 
			//added part for assertions 
			`ifdef ASSERTIONS; 
				if(counter_rx==4'b1001||counter_rx==4'b1000&&first_time) 
					MOSI_var[9-counter_rx]=MOSI;
			`endif 
			///////////////////////////////////////////////////////////////////////////////// 
			if (tx_valid==1) begin
			  	if(counter_tx<8) begin 
					   MISO<=tx_data[counter_tx];
					   counter_tx<=counter_tx-1;
				end	
				read_ad_flag=1;//added line
			end
			else  begin
			//	MISO=0;
				//added part to make rx_data has a value 
				if (counter_rx==0) begin//from serial to parralel /f insted of zero for nonvlocking edit 
	     		rx_data<={bus_rx,MOSI};  ///edited :: mising bit in rx_data.
	     		counter_rx<=4'b1001;
	        		end
	      		else begin  
		   			bus_rx<= {bus_rx,MOSI}; //edited to use shift register
		    			counter_rx<=counter_rx-1;
		  		end
			///////////////////////////////////////////////
			end

		end
    endcase    
end//end of always block
`ifdef ASSERTIONS
	property checking_rx_data;
		@(posedge clk) disable iff(!rst_n || SS_n ) ( $fell(SS_n) ) |-> ##[12:14] (rx_data[9:8]==MOSI_var) ;   //
	endproperty
	property checking_rx_valid_with_rx_data;
		@(posedge clk) disable iff(!rst_n || SS_n ) (rx_data[9:8]!=2'b11 && rx_data[7:0] != 8'b0000_0000 && cs!= IDLE && cs!=CHK_CMD  && !$stable(rx_data)) |-> rx_valid;
	endproperty
	property checking_tx_valid_with_rx_data;
		@(posedge clk) disable iff(!rst_n || SS_n )(rx_data[9:8]==2'b11 ) |-> ##1 tx_valid;
	endproperty
	property checking_ss_n;
		@(posedge clk)disable iff(!rst_n ) $rose(SS_n) |=> cs==IDLE;
	endproperty
	property tx_valid_still_high;
		@(posedge clk)disable iff(!rst_n || SS_n)  $rose(tx_valid) |=> $stable(tx_valid)[->7]; //
	endproperty
	property tx_data_still_high;
		@(posedge clk)disable iff(!rst_n || SS_n)  $rose(tx_valid) |=> $stable(tx_data)[->7]; //
	endproperty
	always_comb begin : proc_
		if(!rst_n)
			assert final (cs==IDLE);
	end
	checking_rx_data_label:assert property (checking_rx_data) ;
	checking_rx_valid_with_rx_data_label:assert property(checking_rx_valid_with_rx_data) ;
	checking_tx_valid_with_rx_data_label:assert property (checking_tx_valid_with_rx_data);
	checking_ss_n_label:assert property (checking_ss_n);
	tx_valid_still_high_label:assert property(tx_valid_still_high);
	tx_data_still_high_label:assert property(tx_data_still_high);

	checking_rx_data_label_cover:cover property (checking_rx_data) ;
	checking_rx_valid_with_rx_data_label_cover:cover property(checking_rx_valid_with_rx_data) ;
	checking_tx_valid_with_rx_data_label_cover:cover property (checking_tx_valid_with_rx_data) ;
	checking_ss_n_label_cover:cover property (checking_ss_n) ;
	tx_valid_still_high_label_cover:cover property(tx_valid_still_high);
	tx_data_still_high_label_cover:cover property(tx_data_still_high);
`endif
endmodule




