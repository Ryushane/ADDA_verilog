module filter_test_top(
    input clk,
    input rst,
    output signed[13:0] dds_out,
    output signed[32:0] fir_outdata
);

    wire signed[39:0] m_axis_data_tdata;
    assign fir_outdata = m_axis_data_tdata[32:0];
DDS_wrapper DDS_wrapper_inst(
    .clk(clk),
    .rst(rst),
    .dds_out(dds_out)
);

fir_compiler_0 fir_compiler_0_inst(
    .aclk(clk),
    .s_axis_data_tdata(dds_out),
    .s_axis_data_tready(s_axis_data_tready),
    .s_axis_data_tvalid(1),
    .m_axis_data_tdata(m_axis_data_tdata),
    .m_axis_data_tvalid(m_axis_data_tvalid)
);

endmodule
