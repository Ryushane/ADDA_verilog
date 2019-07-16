`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/13 10:28:38
// Design Name: 
// Module Name: top
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


module adc_top#(
	parameter       DATA_WIDTH = 14,
	parameter       FIFO_DEPTH = 64,
    parameter       SAMPLE_RATE = 4 // sampling per 2^n data
    // parameter       DATAWIDTH = 14
)
(                 
    input clk,
    input rst_n,
    input wr_en,
    input[DATA_WIDTH-1:0] wr_data,
    input rd_en,

    output fifo_full,
    // output[DATA_WIDTH-1:0] rd_data,
    output fifo_empty,
    output fifo_almst_empty
    );
    wire[DATA_WIDTH-1:0] rd_data;
    wire[DATA_WIDTH-1:0] ds_data;

    

    fifo #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) u_fifo(
        .clk                             ( clk     ),
        .rst_n                           ( rst_n   ),
        .wr_en                           ( wr_en   ),
        .wr_data                         ( wr_data ),
        .rd_en                           ( rd_en   ),

        .fifo_full                       ( fifo_full  ),
        .fifo_almst_full                 (fifo_almst_full),
        .fifo_count                      ( fifo_count ),
        .rd_data                         ( rd_data ),
        .fifo_empty                      ( fifo_empty ),
        .fifo_almst_empty                ( fifo_almst_empty ),
        .fifo_above_half                 ( fifo_above_half )
    );


    Downsampling #(.DS_PARAM(DS_PARAM), .DATAWIDTH(DATA_WIDTH)) Downsamling(
        .clk                             ( clk     ),
        .rst_n                           ( rst_n   ),
        .ena                             ( rd_en   ),
        .adcdata                         ( rd_data ),
        .ds_data                         ( ds_data )
    );




endmodule
