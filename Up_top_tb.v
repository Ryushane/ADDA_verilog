`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/13 11:28:38
// Design Name: 
// Module Name: top_tb
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
module Up_top_tb;

// fifo Parameters
parameter PERIOD      = 10;
parameter FIFO_WIDTH  = 14;
parameter FIFO_DEPTH  = 64;
parameter US_PARAM = 4; // sampling per 2^n data

// fifo Inputs
reg   clk                                = 0 ;
reg   rst_n                                = 0 ;
reg   wr_en                                = 0 ;
reg   [FIFO_WIDTH-1:0]  wr_data            = 0 ;
// reg   rd_en                                = 0 ;

wire[FIFO_WIDTH-1:0] dac_dataA_out;
wire[FIFO_WIDTH-1:0] dac_dataB_out; 

// fifo Outputs
wire  fifo_full                            ;
// wire  [$clog2(FIFO_DEPTH)-1:0] fifo_count                 ;
// wire  [FIFO_WIDTH-1:0]       rd_data       ;
wire  fifo_empty                          ;
wire  fifo_almst_empty                     ;



reg [FIFO_WIDTH-1 :0] test_vec;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    clk = 1'b0;
    rst_n = 1'b0;
    wr_en = 1'b0;
    wr_data = 16'b0;

    #(PERIOD*2) rst_n  =  1;
end

always begin
    #(PERIOD*2)
    for(test_vec=0; test_vec < 8; test_vec = test_vec + 1) begin
        #(PERIOD) 
        wr_en = 1'b1;
        wr_data = test_vec << test_vec;
        #(PERIOD) 
        wr_en = 1'b0;		
    end
end



Up_top Up_top (
    .clk                             ( clk  ),
    .rst_n                           ( rst_n),
    .wr_en                           ( wr_en),
    .wr_data                         ( wr_data),

    .dac_dataA_out                   (dac_dataA_out),
    .dac_dataB_out                   (dac_dataB_out),
    .fifo_full                       ( fifo_full),
    .fifo_empty                      ( fifo_empty),
    .fifo_almst_empty                ( fifo_almst_empty)
);




endmodule