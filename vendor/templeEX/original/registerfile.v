`timescale 1ns / 1ns
module registerfile #(
    parameter N = 16,
    M = 5
) (
    input clk,
    en,
    input [N-1:0] wr_data,
    input [M-1:0] addr,
    output [N-1:0] rd_data
);

  reg [N-1:0] mem[(2**M)-1:0];

  assign rd_data = (addr == 29) ? 0 : ( (addr == 30) ? 16'h1 : ( (addr == 31) ? 16'hffff : mem[addr]));

  always @(posedge clk) begin
    if (en) begin
      mem[addr] <= wr_data;
    end
  end

endmodule
