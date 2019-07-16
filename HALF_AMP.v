`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/7/12 10:01:06
// Design Name: 
// Module Name: HALF_AMP
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

module HALF_AMP#(
    parameter SAMPLE_RATE = 4, // sampling per 2^n data
    parameter DATA_WIDTH = 14
)
(
    input infifo_almst_empty,
    input outfifo_almst_full,
    input inbusy,
    output ena, 
    input[DATA_WIDTH-1+SAMPLE_RATE:0] dataIn,
    output[DATA_WIDTH-1:0] dataOut
);

    assign ena = !(infifo_almst_empty || outfifo_almst_full || inbusy);
    assign dataOut = (dataIn >> (SAMPLE_RATE + 1));
endmodule