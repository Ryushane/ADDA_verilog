`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 14:55:41
// Design Name: 
// Module Name: ADS4226_Top
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


module ADS4226_Top #(
    parameter AD_SAMPLE_RATE = 160)
(
    input Local_CLKIN,
    input RESET,
    output AD_CLKOUT,
    output [11:0]AD_Data_A,
    output [11:0]AD_Data_B,
    
    output AD_SDATA,
    output AD_RESET,
    output AD_SEN,
    output AD_SCLK,
    input AD_SDOUT,
    output [2:0]AD_CTRL,
    input [5:0]AD_DA_P,
    input [5:0]AD_DA_N,
    input [5:0]AD_DB_P,
    input [5:0]AD_DB_N,
    input AD_CLKOUT_P,
    input AD_CLKOUT_N,
    output Local_CLKOUT_P,
    output Local_CLKOUT_N
);

assign AD_SDATA = 1'b0;
assign AD_RESET = 1'b1;
assign AD_SEN = 1'b1;
assign AD_SCLK = 1'b0;
assign AD_CTRL = 3'b0;

ADS4226_CLK # (
    .AD_SAMPLE_RATE(AD_SAMPLE_RATE)) 
    AD_CLK(
    .Local_CLKIN(Local_CLKIN),
    .Local_CLKOUT_P(Local_CLKOUT_P),
    .Local_CLKOUT_N(Local_CLKOUT_N),
    .AD_CLKOUT_P(AD_CLKOUT_P),
    .AD_CLKOUT_N(AD_CLKOUT_N),
    .AD_CLKOUT(AD_CLKOUT)
);

ADS4226_Data Channel_A(
    .AD_CLK_IN(AD_CLKOUT),
    .RESET(RESET),
    .AD_DIN_P(AD_DA_P),
    .AD_DIN_N(AD_DA_N),
    .AD_Data(AD_Data_A)
);

ADS4226_Data Channel_B(
    .AD_CLK_IN(AD_CLKOUT),
    .RESET(RESET),
    .AD_DIN_P(AD_DB_P),
    .AD_DIN_N(AD_DB_N),
    .AD_Data(AD_Data_B)
);

endmodule
