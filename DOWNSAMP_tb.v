`timescale 1ns / 1ps

module DOWNSAMP_tb();
parameter       PERIOD = 10;
parameter       DATA_WIDTH = 14;
parameter       FIFO_DEPTH = 512;
parameter       SAMPLE_RATE = 4; // sampling per 2^n data
// parameter       DATAWIDTH = 14

reg clk = 0;
reg rst = 0;
wire[DATA_WIDTH-1+SAMPLE_RATE:0] dsoutdata;
// wire fifo_full, fifo_empty;

DOWNSAMP_top#(
  .DATA_WIDTH(DATA_WIDTH),
  .FIFO_DEPTH(FIFO_DEPTH),
  .SAMPLE_RATE(SAMPLE_RATE)
) 
DOWNSAMP_top(
    .clk_in(clk),
    .rst_in(!rst),
    .dsoutdata(dsoutdata)
    // .dac_dataA_out(dac_dataA_out),
    // .dac_dataB_out(dac_dataB_out)
    // .fifo_full(fifo_full),
    // .fifo_empty(fifo_empty)
);

initial begin
    clk = 0;
    rst = 1;
    #(PERIOD*2)
    rst = 0;
end

always begin
    #(PERIOD)
    clk <= ~clk;
end

endmodule
