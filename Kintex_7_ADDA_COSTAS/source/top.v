`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/21 15:54:13
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
    parameter DATA_WIDTH = 12,
    parameter SAMPLE_RATE = 0
)
(
    input CLK_IN,
    input RESET,
    
    output AD_SDATA,
    output AD_RESET,
    output AD_SEN,
    output AD_SCLK,
    input AD_SDOUT,
    output [2:0]AD_CTRL,
    input [5:0]AD_DA_P,
    input [5:0]AD_DA_N,
    input [5:0]AD_DB_P,
    input [5:0]AD_DB_N,
    input AD_CLKOUT_P,
    input AD_CLKOUT_N,
    output Local_CLKOUT_P,
    output Local_CLKOUT_N,
    
    output DA_CLKA,
    output DA_CLKB,
    output DA_WRTA,
    output DA_WRTB,
    output [7:0]DA_DBPA,
    output [7:0]DA_DBPB
);

wire AD_Local_CLK;

clk_wiz_0 Local_CLK_DCM(
    .clk_out1(AD_Local_CLK),    // output clk_out1
    .resetn(RESET),        // input resetn
    .locked(clklocked),
    .clk_in1(CLK_IN)       // input clk_in1
);      


// assign rst = RESET;
rstpulse rstpulse_0(
    .clk_in(CLK_IN),
    .clk_sys(AD_Local_CLK),
    .rst_in(RESET),
    .rst(rst)
);



wire AD_CLKOUT;
(*mark_debug = "true"*)wire signed[11:0]AD_Data_A;
(*mark_debug = "true"*)wire signed[11:0]AD_Data_B;

ADS4226_Top #(
    .AD_SAMPLE_RATE(100))
ADS4226(
    .Local_CLKIN(AD_Local_CLK),
    .RESET(!rst),
    .AD_CLKOUT(AD_CLKOUT),
    .AD_Data_A(AD_Data_A),
    .AD_Data_B(AD_Data_B),
    
    .AD_SDATA(AD_SDATA),
    .AD_RESET(AD_RESET),
    .AD_SEN(AD_SEN),
    .AD_SCLK(AD_SCLK),
    .AD_SDOUT(AD_SDOUT),
    .AD_CTRL(AD_CTRL),
    .AD_DA_P(AD_DA_P),
    .AD_DA_N(AD_DA_N),
    .AD_DB_P(AD_DB_P),
    .AD_DB_N(AD_DB_N),
    .AD_CLKOUT_P(AD_CLKOUT_P),
    .AD_CLKOUT_N(AD_CLKOUT_N),
    .Local_CLKOUT_P(Local_CLKOUT_P),
    .Local_CLKOUT_N(Local_CLKOUT_N)
);


wire AD_Local_CLK;

// SAMPLING MODULE
    (*mark_debug ="true"*)wire signed[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata;
    NO_DOWNSAMP #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    no_downsamp_inst
    (
        .dataIn                          ( AD_Data_A ),
        .dsoutdata                       ( dsoutdata ),
        .out_en                          ( out_en    ),
        .outbusy                         (inwr_rst_busy)
    ); 


    (*mark_debug ="true"*)wire signed[DATA_WIDTH-1+SAMPLE_RATE:0] inrd_data;
    fifo_generator_in_ns infifo(
        .rst(rst),
        .wr_clk(AD_CLKOUT),
        .wr_en(out_en),
        .din(dsoutdata),
        
        .rd_clk(AD_Local_CLK),
        .dout(inrd_data),
        .rd_en(dsp_en),
        .empty(infifo_empty),       
        .full(infifo_full),


        .wr_rst_busy(inwr_rst_busy),
        .rd_rst_busy(inrd_rst_busy)
    );


    // costas loop module
    
    (*mark_debug = "true"*)wire signed[DATA_WIDTH-1:0] demodout;
    (*mark_debug = "true"*)wire signed[9:0]phasemod;
    assign dsp_en = !((infifo_empty) || (outfifo_full) || inrd_rst_busy);
    COSTAS_LOOP COSTAS_LOOP_inst(
        .clk(AD_Local_CLK),
        .rst(rst),
        .en(1),
        .sigin(inrd_data),
        .demodout(demodout),
        .phasemod(phasemod)
    );


    wire signed[DATA_WIDTH-1:0] outrd_data;

    fifo_generator_out_ns outfifo(
        .srst(rst),
        .clk(AD_Local_CLK),
        .wr_en(dsp_en),
        .din(demodout),

        .dout(outrd_data),
        .rd_en(outrd_en),

        .empty(outfifo_empty),
        .full(outfifo_full)

    );


    wire signed[DATA_WIDTH-1:0] inter_data;

    NO_INTERPOLATION #(
        .DATA_WIDTH(DATA_WIDTH)
        )
        no_interpolation(
        .ena                             ( 1 ),
        .rd_en                           ( outrd_en   ),
        .dataIn                          ( outrd_data ),
        .inter_data                      ( inter_data )
    );


(*mark_debug = "true"*)wire [7:0]DA_Data_A;
(*mark_debug = "true"*)wire [7:0]DA_Data_B;

// assign DA_Data_A = AD_Data_A[11:4] + 8'h80;
// assign DA_Data_B = AD_Data_B[11:4] + 8'h80;
assign DA_Data_A = inter_data[11:4] + 8'h80;
assign DA_Data_B = phasemod[9:2] + 8'h80;

AD9709_Top AD9709(
    .CLK_IN_A(AD_Local_CLK),
    .CLK_IN_B(AD_Local_CLK),
    .RESET(!rst),
    .DA_Data_A(DA_Data_A),
    .DA_Data_B(DA_Data_B),
    
    .DA_CLKA(DA_CLKA),
    .DA_CLKB(DA_CLKB),
    .DA_WRTA(DA_WRTA),
    .DA_WRTB(DA_WRTB),
    .DA_DBPA(DA_DBPA),
    .DA_DBPB(DA_DBPB)
);


// ila_0 AD_ILA (
// 	.clk(AD_Local_CLK), // input wire clk
// 	.probe0(AD_Data_A), // input wire [11:0]  probe0  
//     .probe1(DA_Data_A)
//     // .probe1(DA_DBPA),
//     // .probe2(dsoutdata),
//     // .probe3(inrd_data),
//     // .probe4(phasemod)
// );

endmodule
