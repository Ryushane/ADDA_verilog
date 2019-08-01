`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 23:19:32
// Design Name: 
// Module Name: AD9709_Data
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


module AD9709_Data(
    input CLK_IN,
    input RESET,
    input [7:0]DA_Data,
    
    output DA_CLKx,
    output DA_WRTx,
    output [7:0]DA_DBPx
);

reg [7:0]DA_Data_BUF;

always@(posedge CLK_IN or negedge RESET)
begin
    if(!RESET)
        DA_Data_BUF <= 8'b0;
    else
        DA_Data_BUF <= DA_Data;
end

assign DA_DBPx = DA_Data_BUF;
assign DA_CLKx = CLK_IN;
assign DA_WRTx = CLK_IN;

endmodule
