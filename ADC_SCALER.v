`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/11 15:42:11
// Design Name: 
// Module Name: ADC_SCALER
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


module ADC_SCALER(
    input clk,
    input signed [13:0] adc_dat,
    output reg [11:0] out,
    output reg [1:0] trunc
    );
    
    reg [1:0] trunc_r;
    reg signed [13:0] adc_dat_bias=14'sd0;
    reg signed [13:0] adc_dat_bias_trunc=14'sd0;
    always@(posedge clk)begin
        adc_dat_bias<=adc_dat*(-14'sd1);
        if(adc_dat_bias<14'sd0)begin
            adc_dat_bias_trunc<=14'sd0;
            trunc_r<=2'b01;
        end else if(adc_dat_bias>14'sd3185)begin
            adc_dat_bias_trunc<=14'sd3185;
            trunc_r<=2'b10;
        end else begin
            adc_dat_bias_trunc<=adc_dat_bias;
            trunc_r<=2'b00;
        end
        trunc<=trunc_r;
        out<=adc_dat_bias_trunc+adc_dat_bias_trunc/4;
    end
endmodule
