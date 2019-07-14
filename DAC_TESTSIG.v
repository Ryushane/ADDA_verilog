`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/11 16:22:19
// Design Name: 
// Module Name: DAC_TESTSIG
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


module DAC_TESTSIG(
    input clk,
    input rst,
    output reg [13:0] out
    );
    
    reg rstc=1'b0;
    wire [7:0] rnd;
    reg [8:0] biascnt=9'd0;
    always@(posedge clk)begin
        if(rst)begin
            biascnt<=9'd0;
        end else begin
            biascnt<=biascnt+9'd1;
            if(biascnt>=9'd271)begin
                biascnt<=9'd0;
            end
            if(biascnt<9'd16)begin
                out<=14'd0;
            end else begin
                out<=14'd4096+32*rnd+16*rnd;
            end
            if(biascnt==9'd0)begin
                rstc<=1'b1;
            end else begin
                rstc<=1'b0;
            end
        end
    end
    
    RANDOM_GEN rnd_inst(
        .clk(clk),
        .rst(rstc),
        .out(rnd)
    );
    
endmodule
