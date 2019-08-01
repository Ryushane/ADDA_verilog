`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 23:08:56
// Design Name: 
// Module Name: AD9709_Top
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


module AD9709_Top(
    input CLK_IN_A,
    input CLK_IN_B,
    input RESET,
    input [7:0]DA_Data_A,
    input [7:0]DA_Data_B,
    
    output DA_CLKA,
    output DA_CLKB,
    output DA_WRTA,
    output DA_WRTB,
    output [7:0]DA_DBPA,
    output [7:0]DA_DBPB
);

AD9709_Data AD9709_Channel1(
    .CLK_IN(CLK_IN_A),
    .RESET(RESET),
    .DA_Data(DA_Data_A),
    
    .DA_CLKx(DA_CLKA),
    .DA_WRTx(DA_WRTA),
    .DA_DBPx(DA_DBPA)
);

AD9709_Data AD9709_Channel2(
    .CLK_IN(CLK_IN_B),
    .RESET(RESET),
    .DA_Data(DA_Data_B),
    
    .DA_CLKx(DA_CLKB),
    .DA_WRTx(DA_WRTB),
    .DA_DBPx(DA_DBPB)
);

endmodule
