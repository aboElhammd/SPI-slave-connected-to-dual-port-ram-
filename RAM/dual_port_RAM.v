module Dual_port_RAM(clk,rst_n,rx_valid,din,dout,tx_valid);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input [9:0]din;
input clk,rst_n,rx_valid;
output reg tx_valid;

output reg [7:0]dout;

reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
//reg[ADDR_SIZE-1:0] temp_adr;
reg[ADDR_SIZE-1:0] wr_ptr,rd_ptr ; ///added 
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		dout<=8'b0000_0000;
		tx_valid<=0;
		wr_ptr<=0;
		rd_ptr<=0;
	end
	else begin
		
    if(rx_valid==1)begin
        if(din[9]==0)begin

              if(din[8]==0)begin
              		 wr_ptr<=din[7:0];//keda ha write address fel memory
              		 tx_valid<=0;
               end
               else begin
                   mem[wr_ptr]<=din[7:0];// hna hy write data fel address
                   tx_valid<=0;
                end
        end
        if(din[9]==1)begin
            if (din[8]==0) begin
                  rd_ptr<= din[7:0];
                  tx_valid<=0;
        	end
        end
    end
	///end in here and put the last possiblity alone 
    if(din[9:8]==2'b11)begin
             dout[7:0]<= mem[rd_ptr];
             tx_valid<=1;
             
    end
    //added part to make tx_valid=0
    else 
    	tx_valid<=0;
            
end		
end
endmodule




