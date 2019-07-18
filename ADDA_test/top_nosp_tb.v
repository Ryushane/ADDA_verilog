`timescale 1ns / 1ps

module top_nosp_tb();
parameter       PERIOD = 10;
parameter       SAMPLE_RATE = 0;
parameter       DATA_WIDTH = 14;

reg clk = 0;
reg rst = 0;

wire[DATA_WIDTH-1:0] dac_dataA_out, dac_dataB_out;


top_nosp#(
  .DATA_WIDTH(DATA_WIDTH),
  .SAMPLE_RATE(SAMPLE_RATE)
) 
top_nosp(
    .clk_in(clk),
    .rst_in(!rst),
    .dac_dataA_out(dac_dataA_out),
    .dac_dataB_out(dac_dataB_out)
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
