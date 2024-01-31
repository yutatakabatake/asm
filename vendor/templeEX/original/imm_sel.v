`timescale 1ns / 1ns
module imm_sel #(
    parameter DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] acc,
    imm,
    output [DATA_WIDTH-1:0] data_out,
    input [2:0] imm_sel
);
  wire [7:0] imm_data;

  assign imm_data = (imm_sel[2]) ? imm[15:8] : imm[7:0];
  assign data_out = (imm_sel[1]) ? imm[15:0] : ( (imm_sel[0]) ? {imm_data, acc[7:0]} : {acc[15:8], imm_data});

endmodule
