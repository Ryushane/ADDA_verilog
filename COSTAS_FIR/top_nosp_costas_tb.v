`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/16 18:10:15
// Design Name: 
// Module Name: tb_costasloop
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


module tb_costasloop(

    );
    reg clk=1'b0;
    reg rst=1'b1;
    always begin
        #5 clk<=~clk; // 100Mhz
    end
    
    initial begin
        #50 rst<=1'b0;
    end
    
    reg signed [13:0]sigin=14'sd0;
    integer data_file; // file handler
    integer scan_file; // file handler
    reg signed [13:0] captured_data;
    
    wire[13:0] dac_dataA_out;
    wire[13:0] dac_dataB_out;

    initial begin
        data_file=$fopen("simquan.txt", "r");
        if(data_file==0)begin
            $display("data_file handle was NULL");
            $finish;
        end
    end
    
    always@(posedge clk)begin
        if(~rst)begin
            scan_file=$fscanf(data_file, "%d\n", captured_data);
            if (!$feof(data_file)) begin
                sigin<=captured_data;
            end else begin
                $finish;
            end
        end
    end
    //input signed [13:0]sigin,
    //output signed [13:0]demodout
    top_nosp_costas top_nosp_costas(
        .clk_in(clk),
        .rst_in(~rst),
        .sigin(sigin),
        .dac_dataA_out(dac_dataA_out),
        .dac_dataB_out(dac_dataB_out)
    );
endmodule
