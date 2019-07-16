`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/13 10:28:38
// Design Name: 
// Module Name: DOWNSAMP_top
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


module DOWNSAMP_top#(
	parameter       DATA_WIDTH = 14,
    parameter       SAMPLE_RATE = 4 // sampling per 2^n data
    // parameter       DATAWIDTH = 14
)
(                 
    input clk_in,
    input rst_in,
    output[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata
);
    wire[DATA_WIDTH-1:0] dds_usout;
    wire signed[DATA_WIDTH-1:0] dds_out;

    clk_wiz_0 clk_wiz_test(
        .clk_out1(clk),
        .reset(!rst_in),
        .locked(clklocked),
        .clk_in1(clk_in)
    );

    rstpulse rstpulse(
        .clk_in(clk_in),
        .clk_sys(clk),
        .rst_in(rst_in),
        .rst(rst)
    );
    
    DDS_wrapper#(.SAMPLE_RATE(SAMPLE_RATE)
    ) 
    DDS_wrapper
    (
        .clk (clk ), // input wire aclk
        .rst (rst),
        .wr_en (wr_en ),      // output wire m_axis_data_tvalid
        .dds_usout (dds_usout ), // output wire [31 : 0] dds_out
        .dds_out(dds_out)
    );

    DOWNSAMP #(
        .SAMPLE_RATE(SAMPLE_RATE), 
        .DATAWIDTH(DATA_WIDTH)
        )
        DOWNSAMP(
        .clk                             ( clk     ),
        .rst                             ( rst   ),
        .ena                             ( 1   ),
        .dataIn                          ( dds_out ),
        .dsoutdata                      ( dsoutdata ),
        .out_en                         ( out_en   )
    );
endmodule
