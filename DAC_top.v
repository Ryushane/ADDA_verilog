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


module top#(
	parameter       FIFO_WIDTH = 14,
	parameter       FIFO_DEPTH = 64,
    parameter       DS_PARAM = 4 // sampling per 2^n data
    // parameter       DATAWIDTH = 14
)
(                 
    input clk,
    input rst_n,
    input wr_en,
    input[FIFO_WIDTH-1:0] wr_data,
    input rd_en,

    output fifo_full,
    // output[FIFO_WIDTH-1:0] rd_data,
    output fifo_empty,
    output fifo_almst_empty
    );
    wire[FIFO_WIDTH-1:0] rd_data;
    wire[FIFO_WIDTH-1:0] ds_data;
    wire[FIFO_WIDTH-1:0] dac_dataA_out;
    wire[FIFO_WIDTH-1:0] dac_dataB_out;


    fifo #(.FIFO_WIDTH(FIFO_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) u_fifo(
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


    Upsampling #(.DS_PARAM(DS_PARAM), .DATAWIDTH(FIFO_WIDTH)) Upsampling(
        .clk                             ( clk     ),
        .rst_n                           ( rst_n   ),
        .ena                             ( rd_en   ),
        .adcdata                         ( rd_data ),
        .ds_data                         ( ds_data )
    );

    DAC_DRIVER DAC_DRIVER
    (
        .clk                     ( clk                   ),
        .dac_dataA               ( ds_data      ),
        .dac_dataB               ( ds_data     ),

        .dac_dataA_out           ( dac_dataA_out ),
        .dac_dataB_out           ( dac_dataB_out ),
        .dac_clkA_out            ( dac_clkA_out          ),
        .dac_clkB_out            ( dac_clkB_out          ),
        .dac_gset_out            ( dac_gset_out          ),
        .dac_mode_out            ( dac_mode_out          ),
        .dac_sleep_out           ( dac_sleep_out         )
);


endmodule
