module filter_test_top_tb();
parameter PERIOD = 10;
wire[3:0] fir_outdata;
wire[13:0] dds_out;
reg clk;
reg rst;

initial begin
    clk = 0;
    rst = 1;
    #(PERIOD*5)
    rst = 0;
end

always #(PERIOD/2) begin
    clk = ~clk;
end


filter_test_top filter_test_top_inst(
    .clk(clk),
    .rst(rst),
    .dds_out(dds_out),
    .fir_outdata(fir_outdata)
);

endmodule