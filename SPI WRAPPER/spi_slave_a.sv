typedef enum  {IDLE , CHK_CMD , WRITE , READ_ADD , READ_DATA} states_e;

module spi_slave_2(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
input MOSI,clk,rst_n,SS_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg [9:0] rx_data;
reg [9:0] bus;
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter READ_DATA=3'b010;
parameter READ_ADD=3'b011;
parameter WRITE=3'b100;
(* fsm_encoding = "gray" *)
logic [2:0] cs,ns;
reg addr_available;
reg [3:0] counter;
reg [4:0]counter_2;

// state memory logic 
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cs<=IDLE;
	end
	else  begin
		cs<=ns;
	end
end
//next state logic
always @(* ) begin
	case(cs)
		IDLE : begin
			if(SS_n || !rst_n) 
				ns=IDLE;
			else 
				ns=CHK_CMD;	
		end
		CHK_CMD : begin
			if(SS_n) 
				ns=IDLE;
			else begin
				if(!MOSI)
					ns=WRITE;
				else if(addr_available)
					ns=READ_DATA;
				else 
					ns=READ_ADD;
			end
		end
		WRITE:begin
			if(!SS_n)
				ns=WRITE ;
			else begin
				ns=IDLE;	
			end
		end
		READ_ADD:begin
			if(!SS_n )
				ns=READ_ADD ;
			else begin
				ns=IDLE;	
			end
		end
		READ_DATA:begin
			if( !SS_n )
				ns=READ_DATA;
			else
				ns=IDLE;
		end
		default: ns=IDLE;
	endcase
end
//output logic 
always @(posedge clk ) begin
	if(!rst_n)begin
		addr_available<=0;
		rx_data<=0;
		rx_valid<=0;
		counter<=0;
		counter_2<=0;
		MISO<=0;
	end
	case(cs)
		IDLE:begin
			rx_valid<=0;
			counter<=0;
			rx_data<=0;
			counter_2<=0;

		end
		WRITE:begin
			if(counter >9 ) begin
				rx_valid<=1;
				counter<=counter+1;
			end
			else if(counter == 9 ) begin
				rx_valid<=1;
				rx_data<={bus,MOSI};
				counter<=counter+1;
			end
			else begin
		//		rx_valid<=0;
				bus<={bus,MOSI};
				counter<=counter+1;
			end
		end
		READ_ADD:begin
			
			if(counter > 9 ) begin
				rx_valid<=1;
				counter<=counter+1;
			end
			else if(counter == 9 ) begin
				rx_valid<=1;
				rx_data<={bus,MOSI};
				counter<=counter+1;
				addr_available<=1;
			end
			else begin
				rx_valid<=0;
				bus<={bus,MOSI};
				counter<=counter+1;
			end
		end
		READ_DATA:begin
		//	addr_available<=0;
			if(tx_valid&& counter_2<7) begin
				counter_2<=counter_2+1;
				MISO<=tx_data[7-counter_2];
				addr_available<=0;
			end
			else if(tx_valid)
				MISO<=tx_data[0];
			else if(counter == 9 ) begin
			//	rx_valid<=1;
				rx_data<={bus,MOSI};
				counter<=counter+1;
			end
			else begin
				rx_valid<=0;
				bus<={bus,MOSI};
				counter<=counter+1;
			end
		end
	endcase
end
endmodule


