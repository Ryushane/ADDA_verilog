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


module top#(
    parameter       DATA_WIDTH = 14,
    parameter       SAMPLE_RATE = 4
)
(
    input clk_in,
    input rst_in,
    // ADC
    output adc_clkP_out_P,
    output adc_clkM_out_N,
    input adc_clkPout_in_P,
    input adc_clkMout_in_N,
    output adc_ctrl1_out,
    output adc_ctrl2_out,
    output adc_ctrl3_out,
    output adc_reset_out,
    output adc_sclk_out,
    output adc_sdata_out,
    input adc_sdout_in,
    output adc_sen_out,
    input [6:0] adc_dataA_in_P,
    input [6:0] adc_dataA_in_N,
    input [6:0] adc_dataB_in_P,
    input [6:0] adc_dataB_in_N,
    
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

    wire signed[DATA_WIDTH-1:0] adcdatA;
    wire signed[DATA_WIDTH-1:0] adcdatB;    
    wire clkadc;

    ADC_DRIVER adcdriver_inst(
        .clk(clk),
        .clkadc(clkadc),
        .rst(rst),
        .clkadclocked(clkadclocked),
        .adc_clkP_out_P(adc_clkP_out_P),
        .adc_clkM_out_N(adc_clkM_out_N),
        .adc_clkPout_in_P(adc_clkPout_in_P),
        .adc_clkMout_in_N(adc_clkMout_in_N),
        .adc_ctrl1_out(adc_ctrl1_out),
        .adc_ctrl2_out(adc_ctrl2_out),
        .adc_ctrl3_out(adc_ctrl3_out),
        .adc_reset_out(adc_reset_out),
        .adc_sclk_out(adc_sclk_out),
        .adc_sdata_out(adc_sdata_out),
        .adc_sdout_in(adc_sdout_in),
        .adc_sen_out(adc_sen_out),
        .adc_dataA_in_P(adc_dataA_in_P),
        .adc_dataA_in_N(adc_dataA_in_N),
        .adc_dataB_in_P(adc_dataB_in_P),
        .adc_dataB_in_N(adc_dataB_in_N),
        .adcdatA(adcdatA),
        .adcdatB(adcdatB)
    );


    wire[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata;
    DOWNSAMP #(
        .SAMPLE_RATE(SAMPLE_RATE),
        .DATA_WIDTH(DATA_WIDTH)
    )
    downsamp_inst
    (
        .clk                             ( clkadc    ),
        .rst                             ( rst       ),
        .ena                             ( 1         ),
        .dataIn                          ( adcdatB ),
        .dsoutdata                       ( dsoutdata ),
        .out_en                          ( out_en    ),

        .outbusy                         (inwr_rst_busy)
    ); 


    wire[DATA_WIDTH-1+SAMPLE_RATE:0] inrd_data;
    fifo_generator_in infifo(
        .rst(rst),
        .wr_clk(clkadc),
        .wr_en(out_en),
        .din(dsoutdata),
        
        .rd_clk(clk),
        .dout(inrd_data),
        .rd_en(dsp_en),
        .almost_empty(infifo_almst_empty),       
        .almost_full(infifo_almst_full),


        .wr_rst_busy(inwr_rst_busy),
        .rd_rst_busy(inrd_rst_busy)
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
        .inbusy(inrd_rst_busy),
        .ena(dsp_en),
        .dataIn(inrd_data),
        .dataOut(dsp_out)
    );

    wire[DATA_WIDTH-1:0] outrd_data;

    fifo_generator_out outfifo(
        .srst(rst),
        .clk(clk),
        .wr_en(dsp_en),
        .din(dsp_out),

        .dout(outrd_data),
        .rd_en(outrd_en),

        .almost_empty(outfifo_almst_empty),
        .almost_full(outfifo_almst_full)

    );


    wire[DATA_WIDTH-1:0] inter_data;

    INTERPOLATION #(
        .SAMPLE_RATE(SAMPLE_RATE), 
        .DATA_WIDTH(DATA_WIDTH)
        )
        INTERPOLATION(
        .clk                             ( clk     ),
        .rst                             ( rst   ),
        .ena                             ( outfifo_almst_full),
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

    ila_top ila_top(
        .clk(clk),
        .probe0(adcdatA),
        .probe1(adcdatB),
        .probe2(dsoutdata),
        .probe3(outrd_data),
        .probe4(inter_data)
    );


endmodule
