`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/7/12 10:01:06
// Design Name: 
// Module Name: Downsampling
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

module Downsampling#(
    parameter DS_PARAM = 4, // sampling per 2^n data
    parameter DATAWIDTH = 14
)
(
    input clk,
    input rst_n,
    input ena, 
    input[DATAWIDTH-1:0] adcdata,
    output reg[DATAWIDTH-1:0] ds_data
);

    // parameter DS_NUM = 1<<(DS_PARAM) - 1;
    
    reg[DS_PARAM-1:0] ds_counter;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ds_counter <= 0;
        else if(ena)
            ds_counter <= ds_counter + 1; 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ds_data <= 0;
        else if(!ena)
            ds_data <= 0;
        else if(ds_counter == 0)
            ds_data <= adcdata;
    end
endmodule