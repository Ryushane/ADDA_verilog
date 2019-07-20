module led_test(clk_in,rst,switch_on,led_on);

input wire clk_in;
input wire rst;
input wire switch_on;
output reg led_on;

reg[31:0] counter;

// always@ (posedge clk_in) begin
//   if (rst) begin
//     led_on <= 0;
//   end
//   else begin
//     if (switch_on) begin
//       led_on <= 1;
//     end
//     else begin
//       led_on <= 0;
//     end
//   end
// end

always@ (posedge clk_in) begin
  if(rst) begin
    counter <= 0;
    led_on <= 0;
  end
  else if(counter < 49999999)begin
    counter <= counter + 1;
  end
  else begin
    counter <= 0;
    led_on <= ~led_on;
  end
end

endmodule