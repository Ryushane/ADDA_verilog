`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: Kevin Zhang
// Module Name: test_verify_mod
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ASYN_FIFO#(
	parameter       FIFO_WIDTH = 14,
	parameter       FIFO_DEPTH = 64,
	parameter  		ALMST = 5
)
(
	input               				wr_clk, // input clk
	input								rd_clk, // output clk
	input              					rst,
	
	input								wr_en,
	input [FIFO_WIDTH-1:0] 				wr_data,	
	input								rd_en,
	output reg[FIFO_WIDTH-1:0] 			rd_data,

	output 								fifo_full,
	output								fifo_almst_full,
	output                              fifo_empty,
	output 								fifo_almst_empty,
	output 								fifo_above_half
);
	reg[FIFO_WIDTH-1:0] ram[FIFO_DEPTH-1:0];

	//FIFO当前深度
	always @ (posedge clk_a) begin
		if(rst)
			fifo_count <= 0;
		else if(wr_en == 1)
			fifo_count <= fifo_count + 1;
		else
			fifo_count <= fifo_count;
	end


	always @ (posedge clk_b) begin
		if(rst)
			fifo_count <= 0;
		else if(rd_en == 1)
			fifo_count <= fifo_count - 1;
		else
			fifo_count <= fifo_count;
	end

	assign fifo_full  = (fifo_count == FIFO_DEPTH-1) ? 1'b1 : 1'b0;
	assign fifo_empty = (fifo_count == 0) ? 1'b1 : 1'b0;
	assign fifo_almst_empty = (fifo_count < (ALMST)) ? 1'b1 : 1'b0;
	assign fifo_almst_full = (fifo_count > (FIFO_DEPTH-ALMST)) ? 1'b1 : 1'b0;
	assign fifo_above_half = (fifo_count > (FIFO_DEPTH>>1)) ? 1'b1 : 1'b0;
	//写指针
	reg[$clog2(FIFO_DEPTH)-1:0] wr_ptr;
	always @(posedge clk_a) begin
		if(rst) begin
			wr_ptr <= 0;
			ram[rd_ptr] <=  {(FIFO_WIDTH-1){1'b 0}}; 
		end
		else begin
			if(wr_en)begin
				ram[wr_ptr] <= wr_data;
				if(wr_ptr == FIFO_DEPTH - 1)
					wr_ptr <= 0;
				else 
					wr_ptr <= wr_ptr + 1;
			end
		end
	end
	//读指针
	reg[$clog2(FIFO_DEPTH)-1:0] rd_ptr;
	always @(posedge clk_b) begin
		if(rst) begin
			rd_ptr <= 0;
			rd_data <= 0;
		end
		else begin
			if(rd_en)begin
				rd_data <= ram[rd_ptr];
				if(rd_ptr == FIFO_DEPTH - 1)
					rd_ptr <= 0;
				else 
					rd_ptr <= rd_ptr + 1;
			end
			else begin
				rd_data <= rd_data;
			end
		end
	end
endmodule