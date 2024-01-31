`timescale 1ns / 1ns

module testfix;
  reg         clk;
  reg         rst;
  wire [15:0] rd_data;
  wire [15:0] wr_data;
  wire [15:0] addr;
  wire        wen;

  integer i, F_HANDLE, num;


  parameter STEP = 100;
  always #(STEP / 2) begin
    clk = ~clk;
    i   = i + 1;
  end


  initial begin
    $dumpfile("testfix.vcd");  //GTKwaveで波形表示する為の記述
    $dumpvars(0, testfix);  //GTKwaveで波形表示する為の記述

    $readmemb("../programs/loop_1_to_10.dat", memory.mem);

    {memory.mem[1001], memory.mem[1000]} = 16'h9;
    {memory.mem[1003], memory.mem[1002]} = 16'h8;
    {memory.mem[1005], memory.mem[1004]} = 16'h7;
    {memory.mem[1007], memory.mem[1006]} = 16'h6;
    {memory.mem[1009], memory.mem[1008]} = 16'h5;
    {memory.mem[1011], memory.mem[1010]} = 16'h4;
    {memory.mem[1013], memory.mem[1012]} = 16'h3;
    {memory.mem[1015], memory.mem[1014]} = 16'h2;
    {memory.mem[1017], memory.mem[1016]} = 16'h1;
    {memory.mem[1019], memory.mem[1018]} = 16'h0;

    #(STEP * 0) clk = 0;
    rst = 1;
    i   = 0;
    #(STEP + 10) rst = 0;
    #(STEP * 2 + 10) rst = 1;


    while (temple.PC.data_out != 16'hFFFF) begin
      #STEP;
    end

    F_HANDLE = $fopen("loop_1_to_10.txt");
    $fwrite(F_HANDLE, "cycle = %d\n", i);
    for (i = 1000; i < 1020; i = i + 2) begin
      $fwrite(F_HANDLE, "mem[%6d] = %d\n", i, $unsigned({memory.mem[i+1], memory.mem[i]}));
    end
    $finish;

  end  // initial begin



  Temple temple (
      .clk(clk),
      .rst(rst),
      .rd_data(rd_data),
      .addr(addr),
      .wr_data(wr_data),
      .en(wen)
  );

  memory memory (
      .clk(clk),
      .rw(wen),
      .addr(addr),
      .rdata(rd_data),
      .wdata(wr_data)
  );


endmodule

module memory (
    clk,
    rw,
    addr,
    rdata,
    wdata
);
  input rw, clk;
  input [15:0] addr;
  input [15:0] wdata;
  output [15:0] rdata;
  reg [7:0] mem[0:65535];


  assign rdata = (!rw) ? {mem[addr+1], mem[addr]} : 16'hz;  // Read mode

  always @(posedge clk) if (rw) {mem[addr+1], mem[addr]} = wdata;  // Write mode
endmodule




