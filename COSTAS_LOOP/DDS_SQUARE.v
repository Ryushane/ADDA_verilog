`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/16 16:25:13
// Design Name: 
// Module Name: DDS_SQUARE
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

// 目前是10.7M
module DDS_SQUARE(
        input clk,
        input rst,
        input [31:0] phaseincr,
        output outs,
        output outc
    );
    reg outs_r=1'b0;
    reg outc_r=1'b0;
    reg [32:0]phaseaccs=33'h80000000;
    reg [32:0]phaseaccc=33'h0;
    wire ovfls;
    wire ovflc;
    assign ovfls=phaseaccs[32];
    assign ovflc=phaseaccc[32];
    assign outs=outs_r;
    assign outc=outc_r;
    always@(posedge clk)begin
        if(rst)begin
            phaseaccs<=33'h80000000;
            phaseaccc<=33'h0;
            outs_r<=1'b0;
            outc_r<=1'b0;
        end else begin
            if(ovfls==1'b1)begin
                phaseaccs<=(phaseaccs[31:0]+phaseincr);
                outs_r<=~outs_r;
            end else begin
                phaseaccs<=phaseaccs+phaseincr;
            end
            if(ovflc==1'b1)begin
                phaseaccc<=(phaseaccc[31:0]+phaseincr);
                outc_r<=~outc_r;
            end else begin
                phaseaccc<=phaseaccc+phaseincr;
            end
        end
    end
    
endmodule
