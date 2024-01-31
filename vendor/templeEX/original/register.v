`timescale 1ns / 1ns
module register #(
    parameter N = 16
) (
    input clk,
    rst,
    en,
    input [N-1:0] data_in,
    output reg [N-1:0] data_out
);

  always @(posedge clk, negedge rst) begin
    if (!rst) begin
      data_out <= 0;
    end else begin
      if (en) begin
        data_out <= data_in;
      end
    end
  end
endmodule
