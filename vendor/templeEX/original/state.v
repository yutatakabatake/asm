`timescale 1ns / 1ns

`include "head.v"

module state (
    input            clk,
    rst,
    input      [2:0] op,
    output reg [3:0] state,
    input      [2:0] flag
);
  reg [3:0] nextstate;
  reg       br;


  always @(*) begin
    case (state)
      `FETCH: begin
        if (op == 3'b000) begin
          nextstate = `NOR;
        end else if (op == 3'b001) begin
          nextstate = `ADD;
        end else if (op == 3'b010) begin
          nextstate = `LD;
        end else if (op == 3'b011) begin
          nextstate = `PC;
        end else if (op == 3'b100) begin
          nextstate = `SD;
        end else if (op == 3'b101) begin
          nextstate = `SETI1;
        end else if (op == 3'b110) begin
          nextstate = `JL1;
        end else nextstate = `SRL;
      end
      `NOR: begin
        nextstate = `PC;
      end
      `ADD: nextstate = `PC;
      `LD: nextstate = `PC;
      `SD: nextstate = `PC;
      `SETI1: nextstate = `SETI2;
      `SETI2: nextstate = `PC;
      `SRL: nextstate = `PC;
      `JL1:
      if (br) nextstate = `JL2;
      else nextstate = `PC;
      `JL2: nextstate = `FETCH;
      //`MOVE: nextstate = `PC;
      `PC: nextstate = `FETCH;
      default: nextstate = `FETCH;
    endcase  // case (state)
  end

  always @(posedge clk, negedge rst) begin
    if (!rst) begin
      state <= `FETCH;
    end else begin
      state <= nextstate;
    end
  end

  always @(*) begin
    case (op)
      3'h0: br = 0;
      3'h1: br = flag[0];
      3'h2: br = flag[1];
      3'h3: br = flag[1] | flag[0];
      3'h4: br = flag[2];
      3'h5: br = flag[2] | flag[0];
      3'h6: br = flag[2] | flag[1];
      3'h7: br = 1;
      default: br = 0;
    endcase  // case (cond)
  end  // always @ begin


endmodule  // state

