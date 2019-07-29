`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/7/12 10:01:06
// Design Name: 
// Module Name: NO_DOWNSAMP
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

module NO_DOWNSAMP#(
    parameter DATA_WIDTH = 14
)
(
    input signed[DATA_WIDTH-1:0] dataIn,
    output signed[DATA_WIDTH-1:0] dsoutdata,
    output out_en,    
    input outbusy
);
    assign out_en = !outbusy;
    assign dsoutdata = dataIn;
    
endmodule