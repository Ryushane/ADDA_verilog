`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/16 18:44:04
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


module costas_top(
        input clkin,
        input rstin,
        input signed [13:0]sigin,
        output signed [13:0]demodout,
        output locked
    );
    wire clk;
    clk_wiz_0 clkwiz_inst(
        // Clock out ports
        .clk_out1(clk),     // output clk_out1
        // Status and control signals
        .reset(1'b0), // input reset
        .locked(locked),       // output locked
        // Clock in ports
        .clk_in1(clkin)
    );
    COSTAS_LOOP COSTAS_LOOP_inst(
        .clk(clk),
        .rst(rstin),
        .en(1'b1),
        .sigin(sigin),
        .demodout(demodout),
        .phasemod()
    );
endmodule
