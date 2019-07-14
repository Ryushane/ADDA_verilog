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


module Up_top#(
	parameter       FIFO_WIDTH = 14,
	parameter       FIFO_DEPTH = 64,
    parameter       SAMPLE_RATE = 4 // sampling per 2^n data
    // parameter       DATAWIDTH = 14
)
(                 
    input clk,
    input rst_n,
    input wr_en,
    input[FIFO_WIDTH-1:0] wr_data,
    
    output[FIFO_WIDTH-1:0] dac_dataA_out,
    output[FIFO_WIDTH-1:0] dac_dataB_out,
    output fifo_full,
    // output[FIFO_WIDTH-1:0] rd_data,
    output fifo_empty,
    output fifo_almst_empty
    );
    wire[FIFO_WIDTH-1:0] rd_data;
    wire[FIFO_WIDTH-1:0] us_data;
    // wire[FIFO_WIDTH-1:0] dac_dataA_out;
    // wire[FIFO_WIDTH-1:0] dac_dataB_out;


    fifo #(.FIFO_WIDTH(FIFO_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) u_fifo(
        .clk                             ( clk     ),
        .rst_n                           ( rst_n   ),
        .wr_en                           ( wr_en   ),
        .wr_data                         ( wr_data ),
        .rd_en                           ( rd_en   ),

        .fifo_full                       ( fifo_full  ),
        .fifo_almst_full                 ( fifo_almst_full ),
        .fifo_count                      ( fifo_count ),
        .rd_data                         ( rd_data ),
        .fifo_empty                      ( fifo_empty ),
        .fifo_almst_empty                ( fifo_almst_empty ),
        .fifo_above_half                 ( fifo_above_half )
    );


    interpretation #(
        .SAMPLE_RATE(SAMPLE_RATE), 
        .DATAWIDTH(FIFO_WIDTH)
        )
        interpretation(
        .clk                             ( clk     ),
        .rst_n                           ( rst_n   ),
        .ena                             ( fifo_above_half   ),
        .dataIn                          ( rd_data ),
        .us_data                         ( us_data ),

        .rd_en                            ( rd_en   )
    );

    DAC_DRIVER DAC_DRIVER
    (
        .clk                     ( clk                   ),
        .dac_dataA               ( us_data      ),
        .dac_dataB               ( us_data     ),

        .dac_dataA_out           ( dac_dataA_out ),
        .dac_dataB_out           ( dac_dataB_out ),
        .dac_clkA_out            ( dac_clkA_out          ),
        .dac_clkB_out            ( dac_clkB_out          ),
        .dac_gset_out            ( dac_gset_out          ),
        .dac_mode_out            ( dac_mode_out          ),
        .dac_sleep_out           ( dac_sleep_out         )
);


endmodule
