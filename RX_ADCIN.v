`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/19 10:20:26
// Design Name: 
// Module Name: RX_ADCIN
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


module RX_ADCIN(
        input clk,
        output clkadc,
        output clkadclocked,
        input rst,
        
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
        
        output frameen,
        output [1:0] err,
        output symouten_re,
        output symouten_im,
        output [15:0]symout,
        output [6:0]symout_addr,
        output [9:0]symcnt
    );
    wire signed [13:0]adcdatA;
    wire signed [13:0]adcdatB;
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
    
    wire [11:0]adcdatAscaled;
    ADC_SCALER adcscalerA_inst(
        .clk(clkadc),
        .adc_dat(adcdatA),
        .out(adcdatAscaled),
        .trunc()
    );
    
    wire [11:0]adcdatAfiltered;
    ADC_FILTER adcfiltA_inst(
        .clk(clkadc),
        .in(adcdatAscaled),
        .outf(adcdatAfiltered)
    );
    
    wire symen;
    wire [11:0]symo;
    wire [15:0]symcnttotal;
    wire [3:0]sigphase;
    CLK_RECOVERY clkrecovery_inst(
        .clk(clkadc),
        .rst(rst),
        .dat(adcdatAfiltered),
        .symen(symen),
        .symo(symo),
        .symcnt(symcnttotal),
        .sigphase(sigphase)
    );
    
    RX_FRAMEWRITER fw_inst(
        .clk(clkadc),
        .rst(rst),
        .syminen(symen),
        .symin(symo),
        .frameen(frameen),
        .err(err),
        .symouten_re(symouten_re),
        .symouten_im(symouten_im),
        .symout_addr(symout_addr),
        .symout(symout),
        .symcnt_w(symcnt)
    );
endmodule
