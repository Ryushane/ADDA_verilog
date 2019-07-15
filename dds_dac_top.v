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


module dds_dac_top#(
	parameter       FIFO_WIDTH = 14,
	parameter       FIFO_DEPTH = 512,
    parameter       SAMPLE_RATE = 4 // sampling per 2^n data
    // parameter       DATAWIDTH = 14
)
(                 
    input clk_in,
    input rst_in,
    // input wr_en,
    // input[FIFO_WIDTH-1:0] wr_data,
    
    (*mark_debug = "true"*)output[FIFO_WIDTH-1:0] dac_dataA_out,
    (*mark_debug = "true"*)output[FIFO_WIDTH-1:0] dac_dataB_out,
    output dac_clkA_out,
    output dac_clkB_out,
    output dac_gset_out,
    output dac_mode_out,
    output dac_sleep_out,

    input SW3,
    output led_on
    // output fifo_full,
    // // output[FIFO_WIDTH-1:0] rd_data,
    // output fifo_empty
    // output fifo_almst_empty,
);
    wire[FIFO_WIDTH-1:0] rd_data;
    (*mark_debug = "true"*)wire[FIFO_WIDTH-1:0] inter_data;

    (*mark_debug = "true"*)wire[FIFO_WIDTH-1:0] dds_usout;
    // wire[FIFO_WIDTH-1:0] dac_dataA_out;
    // wire[FIFO_WIDTH-1:0] dac_dataB_out;
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

    led_test led_test(
        .clk_in(clk),
        .rst(rst),
        .switch_on(SW3),
        .led_on(led_on)
    );
    
    DDS_wrapper#(.SAMPLE_RATE(SAMPLE_RATE)
    ) 
    DDS_wrapper
    (
        .clk (clk ), // input wire aclk
        .rst (rst),
        .wr_en (wr_en ),      // output wire m_axis_data_tvalid
        .dds_usout (dds_usout ) // output wire [31 : 0] dds_out
    );

    fifo #(.FIFO_WIDTH(FIFO_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) u_fifo(
        .clk                             ( clk     ),
        .rst                             ( rst   ),
        .wr_en                           ( wr_en   ),
        .wr_data                         ( dds_usout ),
        .rd_en                           ( rd_en   ),

        .fifo_full                       ( fifo_full  ),
        .fifo_almst_full                 ( fifo_almst_full ),
        // .fifo_count                      ( fifo_count ),
        .rd_data                         ( rd_data ),
        .fifo_empty                      ( fifo_empty ),
        .fifo_almst_empty                ( fifo_almst_empty ),
        .fifo_above_half                 ( fifo_above_half )
    );


    interpolation #(
        .SAMPLE_RATE(SAMPLE_RATE), 
        .DATAWIDTH(FIFO_WIDTH)
        )
        interpolation(
        .clk                             ( clk     ),
        .rst                             ( rst   ),
        .ena                             ( fifo_above_half   ),
        .dataIn                          ( rd_data ),
        .inter_data                      ( inter_data ),

        .rd_en                            ( rd_en   )
    );

    DAC_DRIVER DAC_DRIVER
    (
        .clk                     ( clk                   ),
        .dac_dataA               ( inter_data      ),
        .dac_dataB               ( inter_data     ),

        .dac_dataA_out           ( dac_dataA_out ),
        .dac_dataB_out           ( dac_dataB_out ),
        .dac_clkA_out            ( dac_clkA_out          ),
        .dac_clkB_out            ( dac_clkB_out          ),
        .dac_gset_out            ( dac_gset_out          ),
        .dac_mode_out            ( dac_mode_out          ),
        .dac_sleep_out           ( dac_sleep_out         )
);

    ila_0 u_ila(
        .clk(clk),
        .probe0(dds_usout),
        .probe1(inter_data),
        .probe2(dac_dataA_out),
        .probe3(dac_dataB_out)
    );
endmodule
