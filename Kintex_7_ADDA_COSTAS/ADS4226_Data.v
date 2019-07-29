`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 14:29:56
// Design Name: 
// Module Name: ADS4226_Data
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


module ADS4226_Data(
    input AD_CLK_IN,
    input RESET,
    input [5:0]AD_DIN_P,
    input [5:0]AD_DIN_N,
    output reg [11:0]AD_Data
);

wire [5:0]AD_DIN;
wire [11:0]AD_Data_BUF;

genvar bit_i;
generate
    for(bit_i = 0; bit_i < 6; bit_i = bit_i + 1)
    begin: AD_DIN_IBUFDS_IDDR_GEN
        // IBUFDS: Differential Input Buffer
        IBUFDS #(
           .DIFF_TERM("TRUE"),       // Differential Termination
           .IBUF_LOW_PWR("FALSE"),     // Low power="TRUE", Highest performance="FALSE" 
           .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
        ) IBUFDS_AD_DIN (
           .O(AD_DIN[bit_i]),  // Buffer output
           .I(AD_DIN_P[bit_i]),  // Diff_p buffer input (connect directly to top-level port)
           .IB(AD_DIN_N[bit_i]) // Diff_n buffer input (connect directly to top-level port)
        );
        
        // IDDR: Input Double Data Rate Input Register with Set, Reset and Clock Enable.


        IDDR #(
          .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                          //    or "SAME_EDGE_PIPELINED" 
          .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
          .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
          .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
        ) IDDR_AD_DIN (
          .Q1(AD_Data_BUF[bit_i * 2]), // 1-bit output for positive edge of clock 
          .Q2(AD_Data_BUF[bit_i * 2 + 1]), // 1-bit output for negative edge of clock
          .C(AD_CLK_IN),   // 1-bit clock input
          .CE(1'b1), // 1-bit clock enable input
          .D(AD_DIN[bit_i]),   // 1-bit DDR data input
          .R(1'b0),   // 1-bit reset
          .S(1'b0)    // 1-bit set
        );
    end
endgenerate

always@(posedge AD_CLK_IN or negedge RESET)
begin
    if(!RESET)
        AD_Data <= 12'b0;
    else
        AD_Data <= AD_Data_BUF;
end

endmodule
