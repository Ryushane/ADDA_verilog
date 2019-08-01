`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: rotom407
// 
// Create Date: 2019/07/16 16:59:19
// Design Name: 
// Module Name: COSTAS_LOOP
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


module COSTAS_LOOP(
        input clk,  //clock input 100MHz
        input rst,  //reset
        input en,   //enable
        input [13:0] us_sigin,   //signal input
        output [13:0] us_demodout,   //demodulated output
        output [9:0] us_phasemod    //phase detector output
    );

    // sign convert
    wire signed [13:0] sigin;
    wire signed [13:0] demodout;
    wire signed [31:0] phasemod;

    wire sigin_hbit, us_demodout_hbit, us_phasemod_hbit;

    assign sigin_hbit =  us_sigin[13] ? 1'b0 : 1'b1;
    assign us_demodout_hbit = demodout[13] ? 1'b0 : 1'b1;
    assign us_phasemod_hbit = phasemod[31] ? 1'b0 : 1'b1;

    assign sigin = { sigin_hbit, us_sigin[12:0] };
    assign us_demodout = { us_demodout_hbit, demodout[12:0] };
    assign us_phasemod = { us_phasemod_hbit, phasemod[30:22] };



    wire [31:0]phaseincr;
    reg signed [31:0]phasemod_r0=32'sd0;
    assign phasemod=phasemod_r0;
    assign phaseincr=32'sd919123001+phasemod_r0;   //10.7MHz nominal @100MHz
    wire vcoouts;
    wire vcooutc;
    wire signed [13:0]mixs;
    wire signed [13:0]mixc;
    assign mixs=(vcoouts?sigin:-sigin);
    assign mixc=(vcooutc?sigin:-sigin);
    reg signed [13:0]mixslpf=14'sd0;
    reg signed [13:0]mixclpf=14'sd0;
    wire mixscmp;
    wire mixccmp;
    assign mixscmp=~mixslpf[13];
    assign mixccmp=~mixclpf[13];
    wire pdinst;
    assign pdinst=mixccmp^mixscmp;
    wire signed [31:0]pdinstexp;
    //assign pdinstexp=(pdinst?32'sd9191230:-32'sd9191230);
    assign pdinstexp=(pdinst?32'sd5000000:-32'sd5000000);
    
    // reg signed [13:0]mixslpflpf=14'sd0;
    // assign demodout=mixslpflpf;
    // assign demodout=mixslpf;
    
    always@(posedge clk)begin
        if(rst)begin
            phasemod_r0<=32'sd0;
            mixslpf<=14'sd0;
            mixclpf<=14'sd0;
        end else begin
            if(en)begin
                //mix lpf
                mixslpf<=mixslpf-mixslpf/14'sd4+mixs/14'sd4;
                mixclpf<=mixclpf-mixclpf/14'sd4+mixc/14'sd4;
                //mix lpf lpf
                // mixslpflpf<=mixslpflpf-mixslpflpf/14'sd16+mixslpf/14'sd16;
                //phasemod lpf
                phasemod_r0<=phasemod_r0-phasemod_r0/32'sd1024+pdinstexp/32'sd1024;
            end
        end
    end


    DDS_SQUARE DDS_SQUARE_inst(
        .clk(clk), //input clk
        .rst(rst), //input rst
        .phaseincr(phaseincr), //input phase increment
        .outs(vcoouts), //output outs
        .outc(vcooutc) //output outc
    );

    wire signed[39:0] m_axis_data_tdata;
    // wire signed[13:0] demodout;
    // assign demodout = m_axis_data_tdata[31:18];    
    wire signed[13:0] demodout_withDC;
    assign demodout_withDC = m_axis_data_tdata[31:18];
    fir_compiler_0 fir_compiler_0_inst(
        .aclk(clk),
        .s_axis_data_tdata(mixslpf),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tvalid(en),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tvalid(m_axis_data_tvalid)
    );

    reg signed[13:0] DC_comp = 0;
    reg [15:0]gre_counter, less_counter;

    assign demodout = demodout_withDC - DC_comp;

    // always @(posedge clk) begin
    //     if(rst) begin
    //         DC_comp <= 14'sb0;
    //     end
    //     else if(less_counter == 0)
    //         DC_comp <= DC_comp + 14'sd1;
    //     else if(gre_counter == 0)
    //         DC_comp <= DC_comp - 14'sd1;
    // end

    // wire greater, lesser;
    // assign greater = (DC_comp > demodout_withDC);
    // assign lesser = (DC_comp < demodout_withDC);

    // always @(posedge clk) begin
    //     if(rst) begin
    //         less_counter <= 16'b1;
    //         gre_counter <= 16'b1;
    //     end
    //     else if(lesser)
    //         less_counter <= less_counter + 1;
    //     else if(greater)
    //         gre_counter <= gre_counter + 1;
    // end

    // ila_nosp ila_nosp(
    //     .clk(clk),
    //     .probe0(demodout_withDC),
    //     .probe1(DC_comp),
    //     .probe2(us_demodout),
    //     .probe3(demodout),
    //     .probe4(gre_counter)
    // );

endmodule
