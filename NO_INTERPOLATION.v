`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/7/12 10:01:06
// Design Name: 
// Module Name: interpolation
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

module NO_INTERPOLATION#(
    parameter DATA_WIDTH = 14
    )
    (
    input ena, // 接上一级fifo的above half, above half 就算 rst_done，然后一直传输
    output rd_en,
    input[DATA_WIDTH-1:0] dataIn, // unsigned type
    output [DATA_WIDTH-1:0] inter_data // unsigned type
    );

    assign rd_en = ena;
    assign inter_data = dataIn;
    
endmodule