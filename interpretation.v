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

module interpretation#(
    parameter SAMPLE_RATE = 4,
    parameter DATAWIDTH = 14
    )
    (
    input clk,
    input rst_n,
    input ena, // 接上一级fifo的above half, above half 就算 rst_done，然后一直传输
    input[DATAWIDTH-1:0] dataIn,
    output reg[DATAWIDTH-1:0] us_data,

    output reg rd_en
    );

    reg[SAMPLE_RATE-1:0] us_counter;

    reg rst_done;

    reg signed[DATAWIDTH-1:0] predata;
    reg signed[DATAWIDTH-1:0] latdata;
    reg signed[DATAWIDTH-1+SAMPLE_RATE:0] predata_ext;
    reg signed[DATAWIDTH-1+SAMPLE_RATE:0] latdata_ext;
    // wire[DATAWIDTH-1:0] interval;
    wire signed[DATAWIDTH-1:0] interval;
    wire signed[DATAWIDTH-1+SAMPLE_RATE:0] us_out[(1<<SAMPLE_RATE)-1:0];

    // wire sign_flag;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rst_done = 0;
        end
        else if(ena) begin
            rst_done = 1;
        end
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            us_counter <= 0;
        end
        else if(rst_done) begin
            us_counter <= us_counter + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            us_data <= 0;
        end
        else if(rst_done) begin
            us_data <= us_out[us_counter][DATAWIDTH-1+SAMPLE_RATE:SAMPLE_RATE];
        end
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_en <= 0;
        end
        else if(rd_en == 1)
            rd_en <= ~rd_en;
        else if((us_counter == ((1<<SAMPLE_RATE) - 1)) && ena)
            rd_en <= 1;
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            predata <= 0;
            latdata <= 0;
            predata_ext <= 0;
            latdata_ext <= 0;
        end
        else if((us_counter == ((1<<SAMPLE_RATE) - 1)) && rst_done) begin//(2<<SAMPLE_RATE)
            predata <= latdata;
            latdata <= dataIn;
            predata_ext <= latdata_ext;
            latdata_ext <= { dataIn, {(SAMPLE_RATE){1'b0}}};
        end
    end

    // assign sign_flag = (latdata > predata) ? 1'b1 : 1'b0;
    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         interval <= 0;
    //     else if(us_counter == (2<<SAMPLE_RATE) && ena)
    //         interval <= (latdata - predata) >> SAMPLE_RATE; 
    // end
    // assign interval = (latdata_ext - predata_ext) >> SAMPLE_RATE;
    assign interval = (latdata - predata);

    generate
        genvar i;
        assign us_out[0] = predata_ext;
        for(i=1; i<(1<<SAMPLE_RATE); i=i+1) begin : wiretech
            assign us_out[i] = us_out[i-1] + interval;
        end
    endgenerate

    // always @(posedge clk or negedge rst_n) begin
    //     if(rst_n)
    //         ;
    //     else if()
endmodule