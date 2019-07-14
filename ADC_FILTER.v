`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/11 18:40:56
// Design Name: 
// Module Name: ADC_FILTER
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


module ADC_FILTER(
    input clk,
    input [11:0] in,
    output [11:0] outf,
    output [11:0] outo
    );
    reg[11:0] in_r=12'd0;
    reg[12:0] outfr;
    assign outo=in_r;
    assign outf=outfr[12:1];
    always@(posedge clk)begin
        in_r<=in;
        outfr<=in+in_r;
    end
endmodule
