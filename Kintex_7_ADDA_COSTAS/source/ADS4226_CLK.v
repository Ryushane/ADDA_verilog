`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 15:17:06
// Design Name: 
// Module Name: ADS4226_CLK
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


module ADS4226_CLK #(
    parameter AD_SAMPLE_RATE = 160)
(
    input Local_CLKIN,
    output Local_CLKOUT_P,
    output Local_CLKOUT_N,
    input AD_CLKOUT_P,
    input AD_CLKOUT_N,
    output AD_CLKOUT
);

// OBUFDS: Differential Output Buffer

OBUFDS #(
  .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
  .SLEW("SLOW")           // Specify the output slew rate
) OBUFDS_Local_CLK (
  .O(Local_CLKOUT_P),     // Diff_p output (connect directly to top-level port)
  .OB(Local_CLKOUT_N),   // Diff_n output (connect directly to top-level port)
  .I(Local_CLKIN)      // Buffer input 
);

wire        clk_in1_clk_wiz_1;
wire        clk_out1_clk_wiz_1;

wire [15:0] do_unused;
wire        drdy_unused;
wire        psdone_unused;
wire        locked_int;
wire        clkfbout_clk_wiz_1;
wire        clkfbout_buf_clk_wiz_1;
wire        clkfboutb_unused;
wire        clkout0b_unused;
wire        clkout1_unused;
wire        clkout1b_unused;
wire        clkout2_unused;
wire        clkout2b_unused;
wire        clkout3_unused;
wire        clkout3b_unused;
wire        clkout4_unused;
wire        clkout5_unused;
wire        clkout6_unused;
wire        clkfbstopped_unused;
wire        clkinstopped_unused;

localparam PAR_CLKIN1_PERIOD = (10000000/AD_SAMPLE_RATE+5)/10*0.001;
localparam PAR_CLKFBOUT_MULT_F = (80000/AD_SAMPLE_RATE+5)/10*0.125;
localparam PAR_CLKOUT0_DIVIDE_F = (80000/AD_SAMPLE_RATE+5)/10*0.125;

IBUFDS clkin1_ibufgds(
    .O  (clk_in1_clk_wiz_1),
    .I  (AD_CLKOUT_P),
    .IB (AD_CLKOUT_N)
);

MMCME2_ADV#(
    .BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (PAR_CLKFBOUT_MULT_F),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (PAR_CLKOUT0_DIVIDE_F),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (PAR_CLKIN1_PERIOD))
mmcm_adv_inst
// Output clocks
(
    .CLKFBOUT            (clkfbout_clk_wiz_1),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (clk_out1_clk_wiz_1),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
    // Input clock control
    .CLKFBIN             (clkfbout_buf_clk_wiz_1),
    .CLKIN1              (clk_in1_clk_wiz_1),
    .CLKIN2              (1'b0),
    // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

BUFG clkf_buf(
    .O (clkfbout_buf_clk_wiz_1),
    .I (clkfbout_clk_wiz_1)
);

BUFG clkout1_buf(
    .O   (AD_CLKOUT),
    .I   (clk_out1_clk_wiz_1)
);

endmodule
