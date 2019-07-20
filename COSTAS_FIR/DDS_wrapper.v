`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2017/10/14 14:43:25
// Design Name:
// Module Name: DDS_wrapper
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

module DDS_wrapper#(
    parameter SAMPLE_RATE=4
)
(
    input clk,
    input rst,
    output reg wr_en,
    output [13:0] dds_usout, // unsigned
    output signed[13:0] dds_out // signed
);

reg s_axis_phase_tvalid;
reg[31:0] s_axis_phase_tdata;
// reg s_axis_phase_tvalid;
reg[SAMPLE_RATE-1:0] datacounter;
// reg signed[13:0] dds_data;
wire m_axis_data_tvalid;
wire signed[15:0] m_axis_data_tdata;
assign dds_out = m_axis_data_tdata;

assign h_bit = (dds_out[13] == 1) ? 1'b0 : 1'b1;
assign dds_usout = { h_bit, dds_out[12:0] };
// signed to unsigned
reg[7:0] phase_counter = 0;

always @ (posedge clk) begin
    if(rst) begin
        s_axis_phase_tvalid <= 1'd0;
        s_axis_phase_tdata <= 32'd4294900; // 1KHz
        // 356485000再向上就不太正弦了 (8.3M) 到21474836开始衰减
    end
    else if(phase_counter == 0)
        s_axis_phase_tdata <= s_axis_phase_tdata + 32'd42949;
    else begin
        s_axis_phase_tvalid <= 1'd1;
        // s_axis_phase_tdata <= 32'd42949700; // 1MHz
    end
end

always @(posedge clk) begin
    if(rst) begin
        datacounter <= 0;
    end
    else begin
        datacounter <= datacounter + 1;
    end
end

always @(posedge clk) begin
    if(rst)
        wr_en <= 0;
    else if(datacounter == 0)
        wr_en <= 1;
    else
        wr_en <= 0;
end
    

always @(posedge clk) begin
    if(rst)
        phase_counter <= 0;
    else
        phase_counter <= phase_counter + 1;
end



dds_compiler_0 dds_compiler_0 (
.aclk (clk ), // input wire aclk
.s_axis_phase_tvalid  (s_axis_phase_tvalid   ),     // input wire s_axis_phase_tvalid
.s_axis_phase_tdata (s_axis_phase_tdata ),      // input wire [31 : 0] s_axis_phase_tdata
.m_axis_data_tvalid (m_axis_data_tvalid ),      // output wire m_axis_data_tvalid
.m_axis_data_tdata (m_axis_data_tdata ) // output wire [15 : 0] m_axis_data_tdata
);
endmodule