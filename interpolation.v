`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/7/12 10:01:06
// Design Name: 
// Module Name: Upsampling
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

module interpolation#(
    parameter SAMPLE_RATE = 4,
    parameter DATAWIDTH = 14
    )
    (
    input clk,
    input rst,
    input ena, // 接上一级fifo的above half, above half 就算 rst_done，然后一直传输
    input[DATAWIDTH-1:0] dataIn, // unsigned type
    output [DATAWIDTH-1:0] inter_data, // unsigned type

    output reg rd_en
    );

    reg[SAMPLE_RATE-1:0] us_counter;

    reg rst_done;

    reg signed[DATAWIDTH-1:0] predata;
    reg signed[DATAWIDTH-1:0] latdata;
    reg signed[DATAWIDTH-1+SAMPLE_RATE:0] latdata_ext;
    reg signed[DATAWIDTH-1+SAMPLE_RATE:0] s_data_ext; //
    // wire[DATAWIDTH-1:0] interval;
    wire signed[DATAWIDTH:0] interval;

    wire h_bit;
    // 这里需要有符号数转无符号数
    assign h_bit = (s_data_ext[DATAWIDTH-1+SAMPLE_RATE] == 1) ? 1'b0 : 1'b1;
    assign inter_data = { h_bit, s_data_ext[DATAWIDTH-2+SAMPLE_RATE:SAMPLE_RATE]};

    // datain to signed data in
    wire dataIn_hbit;
    wire signed[DATAWIDTH-1:0] s_dataIn;
    assign dataIn_hbit = (dataIn[DATAWIDTH-1] == 1) ? 1'b0 : 1'b1;
    assign s_dataIn = {dataIn_hbit, dataIn[DATAWIDTH-2:0]};



    // wire signed[DATAWIDTH-1+SAMPLE_RATE:0] us_out[(1<<SAMPLE_RATE)-1:0];

    // reg signed inter_data;

    // wire us_data_us;
    // wire sign_flag;
    // assign sign_flag = (latdata > predata) ? 1'b1 : 1'b0;
    // assign us_data_us = {}

    // wire sign_flag;

    always @(posedge clk) begin
        if(rst) begin
            rst_done = 0;
        end
        else if(ena) begin
            rst_done = 1;
        end
    end


    always @(posedge clk) begin
        if(rst) begin
            us_counter <= 0;
        end
        else if(rst_done) begin
            us_counter <= us_counter + 1;
        end
    end


    always @(posedge clk) begin
        if(rst) begin
            rd_en <= 0;
        end
        else if(rd_en == 1)
            rd_en <= ~rd_en;
        else if((us_counter == ((1<<SAMPLE_RATE) - 1)) && ena)
            rd_en <= 1;
    end


    always @(posedge clk) begin
        if(rst) begin
            predata <= 0;
            latdata <= 0;
            latdata_ext <= 0;
        end
        else if((us_counter == ((1<<SAMPLE_RATE) - 1)) && rst_done) begin//(2<<SAMPLE_RATE)
            predata <= latdata;
            latdata <= s_dataIn; // signed 
            latdata_ext <= { dataIn , {(SAMPLE_RATE){1'b0}}}; //无符号数扩展
        end
    end
    // latdata convert to signed data for interpolation
    wire latdata_hbit;
    wire [DATAWIDTH-1+SAMPLE_RATE:0] s_latdata_ext;
    assign latdata_hbit = (latdata_ext[DATAWIDTH-1+SAMPLE_RATE] == 1) ? 1'b0 : 1'b1;
    assign s_latdata_ext = {latdata_hbit, latdata_ext[DATAWIDTH-2+SAMPLE_RATE:0] };


    assign interval = (latdata - predata);

    always @(posedge clk) begin
        if(rst) begin
            s_data_ext <= 0;
        end
        else if(rst_done) begin
            if(us_counter == ((1<<SAMPLE_RATE) - 1))
                s_data_ext <= s_latdata_ext;
            else
                s_data_ext <= s_data_ext + interval;
        end
    end




    // assign sign_flag = (latdata > predata) ? 1'b1 : 1'b0;
    // always @(posedge clk) begin
    //     if(rst)
    //         interval <= 0;
    //     else if(us_counter == (2<<SAMPLE_RATE) && ena)
    //         interval <= (latdata - predata) >> SAMPLE_RATE; 
    // end
    // assign interval = (latdata_ext - predata_ext) >> SAMPLE_RATE;


    // generate
    //     genvar i;
    //     assign us_out[0] = predata_ext;
    //     for(i=1; i<(1<<SAMPLE_RATE); i=i+1) begin : wiretech
    //         assign us_out[i] = us_out[i-1] + interval;
    //     end
    // endgenerate

    // always @(posedge clk) begin
    //     if(rst)
    //         ;
    //     else if()
endmodule