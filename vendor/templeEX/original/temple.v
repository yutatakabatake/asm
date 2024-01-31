`timescale 1ns / 1ns
module Temple #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 16
) (
    input                   clk,
    rst,
    output [ADDR_WIDTH-1:0] addr,
    input  [          15:0] rd_data,
    output [          15:0] wr_data,
    output                  en
);
  wire [15:0] pc_sel_data, acc_sel_data, reg_sel_data, imm_sel_data;
  wire [15:0] pc_out, add_out, acc_out;
  wire [15:0] regfile_out, rf_out, alu_out;

  wire [2:0] flag_out, alu_flag;


  wire pc_sel, acc_sel, reg_sel, addr_sel;
  wire pc_en, acc_en, regfile_en, flag_en, rf_en;
  wire [1:0] imm_sel, alu_op;

  wire [ 2:0] op;

  wire [ 3:0] state;

  wire [13:0] dec;

  wire [ 4:0] regfile_addr;

  wire [ 7:0] half_imm_data;



  assign {pc_sel,addr_sel,reg_sel,acc_sel,imm_sel[1:0],alu_op[1:0],pc_en,acc_en,regfile_en,rf_en,flag_en,en} = dec;

  state statemachine (
      .clk(clk),
      .rst(rst),
      .op(op),
      .state(state),
      .flag(flag_out)
  );
  decode decode (
      .op(op),
      .state(state),
      .dec(dec)
  );

  register PC (
      .clk(clk),
      .rst(rst),
      .en(pc_en),
      .data_in(pc_sel_data),
      .data_out(pc_out)
  );
  register Acc (
      .clk(clk),
      .rst(rst),
      .en(acc_en),
      .data_in(acc_sel_data),
      .data_out(acc_out)
  );
  register #(
      .N(3)
  ) flag (
      .clk(clk),
      .rst(rst),
      .en(flag_en),
      .data_in(alu_flag),
      .data_out(flag_out)
  );
  register regi (
      .clk(clk),
      .rst(rst),
      .en(rf_en),
      .data_in(regfile_out),
      .data_out(rf_out)
  );

  alu alu (
      .data_in1(rf_out),
      .data_in2(acc_out),
      .op(alu_op),
      .data_out(alu_out),
      .flag(alu_flag)
  );
  registerfile regfile (
      .clk(clk),
      .en(regfile_en),
      .wr_data(reg_sel_data),
      .rd_data(regfile_out),
      .addr(regfile_addr)
  );

  assign pc_sel_data = (pc_sel) ? add_out : rf_out;
  assign add_out = pc_out + 16'h1;
  assign acc_sel_data = (acc_sel) ? alu_out : imm_sel_data;
  assign reg_sel_data = (reg_sel) ? add_out : acc_out;
  assign addr = addr_sel ? {pc_out[15:1], 1'b0} : {rf_out[15:1], 1'b0};
  assign wr_data = acc_out;

  assign op = (pc_out[0]) ? rd_data[15:13] : rd_data[7:5];
  assign regfile_addr = (pc_out[0]) ? rd_data[12:8] : rd_data[4:0];
  assign half_imm_data = (pc_out[0]) ? rd_data[15:8] : rd_data[7:0];

  assign imm_sel_data = (imm_sel[1]) ? rd_data[15:0] : ( (imm_sel[0]) ? {half_imm_data, acc_out[7:0]} : {acc_out[15:8], half_imm_data});

endmodule  // Temple
