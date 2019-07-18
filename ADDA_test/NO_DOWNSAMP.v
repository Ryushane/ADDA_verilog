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
    output[DATA_WIDTH-1:0] dsoutdata,
    output out_en,    
    input outbusy
);
    assign out_en = !outbusy;
    wire hbit; 
    wire[DATA_WIDTH-1:0] us_dataIn;
    assign hbit = (dataIn[DATA_WIDTH-1] == 1) ? 1'b0 : 1'b1;
    assign us_dataIn = { hbit, dataIn[DATA_WIDTH-2:0]};

    assign dsoutdata = us_dataIn;
    
endmodule