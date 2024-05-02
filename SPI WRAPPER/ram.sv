module ram (din,clk,rst_n,rx_valid,dout,tx_valid);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input clk,rst_n,rx_valid;
input [ADDR_SIZE+1:0]din; 
output reg [ADDR_SIZE-1:0]dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
reg [ADDR_SIZE-1:0]wr_addr,rd_addr;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		dout<=0;
		tx_valid<=0;
		wr_addr<=0;
		rd_addr<=0;
	end
	else begin
		case (din[ADDR_SIZE+1:8]) 
			2'b00:begin
				if(rx_valid)
					wr_addr<=din[ADDR_SIZE-1:0];
					tx_valid<=0;
			end
			2'b01:begin
				if(rx_valid)
					mem[wr_addr]<=din[ADDR_SIZE-1:0];
					tx_valid<=0;
			end
			2'b10:begin
				if(rx_valid)
					rd_addr<=din[ADDR_SIZE-1:0];
					tx_valid<=0;
			end
			2'b11:begin
				dout<=mem[rd_addr];
				tx_valid<=1;
			end
			endcase
	end
end

endmodule

