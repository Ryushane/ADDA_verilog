`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/16 17:18:01
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


module dds_test_top#(
    parameter       DATA_WIDTH = 14,
	parameter       FIFO_DEPTH = 64,
    parameter       SAMPLE_RATE = 4
)
(
    input clk_in,
    input rst_in,
    // // ADC
    // output adc_clkP_out_P,
    // output adc_clkM_out_N,
    // input adc_clkPout_in_P,
    // input adc_clkMout_in_N,
    // output adc_ctrl1_out,
    // output adc_ctrl2_out,
    // output adc_ctrl3_out,
    // output adc_reset_out,
    // output adc_sclk_out,
    // output adc_sdata_out,
    // input adc_sdout_in,
    // output adc_sen_out,
    // input [6:0] adc_dataA_in_P,
    // input [6:0] adc_dataA_in_N,
    // input [6:0] adc_dataB_in_P,
    // input [6:0] adc_dataB_in_N,
    
    //DAC
    output[DATA_WIDTH-1:0] dac_dataA_out,
    output[DATA_WIDTH-1:0] dac_dataB_out,
    output dac_clkA_out,
    output dac_clkB_out,
    output dac_gset_out,
    output dac_mode_out,
    output dac_sleep_out,


    input SW3,
    output led_on
    );

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

    wire signed[DATA_WIDTH-1:0] dds_out;
    DDS_wrapper#(.SAMPLE_RATE(SAMPLE_RATE)
    ) 
    DDS_wrapper
    (
        .clk (clk ), // input wire aclk
        .rst (rst),
        .dds_out (dds_out) // output wire [31 : 0] dds_out
    );

    // ADC_DRIVER adcdriver_inst(
    //     .clk(clk_in)
    //     .clkadc(clkadc),
    //     .rst(rst),
    //     .clkadclocked(clkadclocked),
    //     .adc_clkP_out_P(adc_clkP_out_P),
    //     .adc_clkM_out_N(adc_clkM_out_N),
    //     .adc_clkPout_in_P(adc_clkPout_in_P),
    //     .adc_clkMout_in_N(adc_clkMout_in_N),
    //     .adc_ctrl1_out(adc_ctrl1_out),
    //     .adc_ctrl2_out(adc_ctrl2_out),
    //     .adc_ctrl3_out(adc_ctrl3_out),
    //     .adc_reset_out(adc_reset_out),
    //     .adc_sclk_out(adc_sclk_out),
    //     .adc_sdata_out(adc_sdata_out),
    //     .adc_sdout_in(adc_sdout_in),
    //     .adc_sen_out(adc_sen_out),
    //     .adc_dataA_in_P(adc_dataA_in_P),
    //     .adc_dataA_in_N(adc_dataA_in_N),
    //     .adc_dataB_in_P(adc_dataB_in_P),
    //     .adc_dataB_in_N(adc_dataB_in_N),
    //     .adcdatA(adcdatA),
    //     .adcdatB(adcdatB)
    // );
    wire[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata;
    DOWNSAMP #(
        .SAMPLE_RATE(SAMPLE_RATE),
        .DATA_WIDTH(DATA_WIDTH)
    )
    downsamp_inst
    (
        .clk                             ( clk    ),
        .rst                             ( rst       ),
        .ena                             ( 1         ),
        .dataIn                          ( dds_out ),
        .dsoutdata                       ( dsoutdata ),
        .out_en                          ( out_en    )
    ); 


    wire[DATA_WIDTH-1+SAMPLE_RATE:0] inrd_data;
    wire[$clog2(FIFO_DEPTH)-1:0] infifo_count;

    // downsampling FIFO, DATA_WIDTH = DATA_WIDTH + SAMPLE_RATE
    ASYN_FIFO#(
        .FIFO_WIDTH(DATA_WIDTH + SAMPLE_RATE),
        .FIFO_DEPTH(FIFO_DEPTH)
    )
    input_fifo
    (
        .clk_a                          ( clk            ),  
        .clk_b                          ( clk_in            ),  
        .rst                            ( rst               ),

        .wr_en                          ( out_en            ),
        .wr_data                        ( dsoutdata         ),
        .rd_en                          ( dsp_en             ),
        .rd_data                        ( inrd_data           ),

        .fifo_count                     ( infifo_count ),
        .fifo_full                      ( infifo_full       ),
        .fifo_almst_full                ( infifo_almst_full ),

        .fifo_empty                     ( infifo_empty       ),
        .fifo_almst_empty               ( infifo_almst_empty ),
        .fifo_above_half                ( infifo_above_half  )
    );


    wire[DATA_WIDTH-1:0] dsp_out;

    // HALF_AMP
    HALF_AMP#(
        .SAMPLE_RATE(SAMPLE_RATE),
        .DATA_WIDTH(DATA_WIDTH)
    )
    dsp_inst(
        .infifo_almst_empty(infifo_almst_empty),
        .outfifo_almst_full(outfifo_almst_full),
        .ena(dsp_en),
        .dataIn(inrd_data),
        .dataOut(dsp_out)
    );

    wire[DATA_WIDTH-1:0] outrd_data;
    wire[$clog2(FIFO_DEPTH)-1:0] outfifo_count;

    ASYN_FIFO#(
        .FIFO_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )
    output_fifo
    (
        .clk_a                          ( clk_in            ),  
        .clk_b                          ( clk_in            ),  
        .rst                            ( rst               ),

        .wr_en                          ( dsp_en            ),
        .wr_data                        ( dsp_out         ),
        .rd_en                          ( outrd_en             ),
        .rd_data                        ( outrd_data           ),

        .fifo_count                     ( outfifo_count ),
        .fifo_full                      ( outfifo_full       ),
        .fifo_almst_full                ( outfifo_almst_full ),

        .fifo_empty                     ( outfifo_empty       ),
        .fifo_almst_empty               ( outfifo_almst_empty ),
        .fifo_above_half                ( outfifo_above_half  )
    );


    wire[DATA_WIDTH-1:0] inter_data;

    interpolation #(
        .SAMPLE_RATE(SAMPLE_RATE), 
        .DATA_WIDTH(DATA_WIDTH)
        )
        interpolation(
        .clk                             ( clk     ),
        .rst                             ( rst   ),
        .ena                             ( fifo_above_half   ),
        .rd_en                           ( outrd_en   ),
        .dataIn                          ( outrd_data ),
        .inter_data                      ( inter_data )
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

endmodule
