`timescale 1ns / 1ns

`include "head.v"

module decode (
    input [2:0] op,
    input [3:0] state,
    output reg [13:0] dec
);

  //  {pc_sel,addr_sel,reg_sel,acc_sel,imm_sel[1:0],alu_op[1:0],pc_en,acc_en,regfile_en,rf_en,flag_en,en}

  always @(*) begin
    case (state)
      `FETCH: begin
        if (op == 3'b110) begin
          dec = 14'b1_1_x_x_xx_xx_1_0_0_1_0_0;
        end else if (op == 3'b101) begin
          dec = 14'b1_1_x_x_xx_xx_1_0_0_0_0_0;
        end else if (op == 3'b011) begin
          dec = 14'bx_1_0_x_1x_xx_0_0_1_0_0_0;
        end else begin
          dec = 14'bx_1_x_x_xx_xx_0_0_0_1_0_0;
        end
      end
      `NOR: dec = 14'bx_x_x_1_xx_00_0_1_0_0_1_0;
      `ADD: dec = 14'bx_x_x_1_xx_01_0_1_0_0_1_0;
      `LD: dec = 14'bx_0_x_0_1x_xx_0_1_0_0_0_0;
      `SD: dec = 14'bx_0_x_x_xx_xx_0_0_0_0_0_1;
      `SETI1: dec = 14'b1_1_x_0_00_xx_1_1_0_0_0_0;
      `SETI2: dec = 14'b1_1_x_0_01_xx_0_1_0_0_0_0;
      `JL1: dec = 14'bx_1_1_x_xx_xx_0_0_1_0_0_0;
      `JL2: dec = 14'b0_x_x_x_xx_xx_1_0_0_0_0_0;
      `SRL: dec = 14'bx_x_x_1_xx_11_0_1_0_0_1_0;
      `MOVE: dec = 14'bx_1_0_x_xx_xx_0_0_0_0_0_1;
      `PC: dec = 14'b1_x_x_x_xx_xx_1_0_0_0_0_0;
    endcase
  end
endmodule
