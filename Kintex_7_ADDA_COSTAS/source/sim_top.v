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


module sim_top#(
    parameter DATA_WIDTH = 12,
    parameter SAMPLE_RATE = 0
)
(
    input CLK_IN,
    input RESET,
    input signed[11:0]sigin,

    output [7:0]DA_DBPA,
    output [7:0]DA_DBPB
);

wire AD_Local_CLK;

clk_wiz_1 Local_CLK_DCM(
    .clk_out1(AD_Local_CLK),    // output clk_out1
    .reset(!RESET),        // input resetn
    .locked(clklocked),
    .clk_in1(CLK_IN)       // input clk_in1
);      


// assign rst = RESET;
rstpulse rstpulse(
    .clk_in(CLK_IN),
    .clk_sys(AD_Local_CLK),
    .rst_in(RESET),
    .rst(rst)
);
// SAMPLING MODULE
    wire signed[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata;
    NO_DOWNSAMP #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    no_downsamp_inst
    (
        .dataIn                          ( sigin ),
        .dsoutdata                       ( dsoutdata ),
        .out_en                          ( out_en    ),
        .outbusy                         (inwr_rst_busy)
    ); 


    wire signed[DATA_WIDTH-1+SAMPLE_RATE:0] inrd_data;

    fifo_generator_in_ns infifo(
        .rst(rst),
        .wr_clk(AD_Local_CLK),
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
    
    wire signed[DATA_WIDTH-1:0] demodout;
    wire signed[9:0]phasemod;
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


wire [7:0]DA_Data_A;
wire [7:0]DA_Data_B;

// assign DA_Data_A = AD_Data_A[11:4] + 8'h80;
// assign DA_Data_B = AD_Data_B[11:4] + 8'h80;
assign DA_Data_A = inter_data[11:4] + 8'h80;
assign DA_Data_B = inter_data[11:4] + 8'h80;

AD9709_Top AD9709(
    .CLK_IN_A(AD_Local_CLK),
    .CLK_IN_B(AD_Local_CLK),
    .RESET(RESET),
    .DA_Data_A(DA_Data_A),
    .DA_Data_B(DA_Data_B),
    
    .DA_CLKA(DA_CLKA),
    .DA_CLKB(DA_CLKB),
    .DA_WRTA(DA_WRTA),
    .DA_WRTB(DA_WRTB),
    .DA_DBPA(DA_DBPA),
    .DA_DBPB(DA_DBPB)
);



endmodule
