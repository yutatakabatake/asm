`timescale 1ns / 1ns
module alu #(
    parameter DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] data_in1,
    data_in2,
    input [1:0] op,
    output reg [DATA_WIDTH-1:0] data_out,
    output [2:0] flag
);

  reg carry;
  wire zero, neg;
  wire [16:0] data_in1_add, data_in2_add;

  assign data_in1_add = data_in1;
  assign data_in2_add = data_in2;

  always @(*) begin
    case (op)
      2'b00: {carry, data_out} = {1'b0, ~(data_in1 | data_in2)};
      2'b01: {carry, data_out} = data_in1_add + data_in2_add;
      2'b10: {carry, data_out} = {1'b0, data_in1};
      2'b11: {carry, data_out} = {1'b0, (data_in2 >> 1)};
    endcase
  end

  assign zero = ~(|data_out);
  assign neg  = data_out[DATA_WIDTH-1];

  assign flag = {zero, neg, carry};

endmodule
