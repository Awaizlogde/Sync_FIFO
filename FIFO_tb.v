`timescale 1ns/1ps

module fifo_tb;
  // Parameters should match FIFO instance (or let default)
  reg clk;
  reg rst;
  reg wr_en;
  reg rd_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire full, empty;
integer timeout;

  // DUT
  sync_FIFO dut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock: 10 ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Waveform
  initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, fifo_tb);
  end

  // Stimulus
  initial begin
    // init
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 8'd00;
    #20;
    rst = 0;
    #10;

    $display("Start test\n");

    repeat (8) begin
      @(posedge clk);
      wr_en = 1;
      rd_en = 0;
      data_in = $random;
    end
    @(posedge clk); // allow flags to update
    wr_en = 0;
    data_in = 8'h00;
    #10;

    $display("After 8 writes: full=%b empty=%b", full, empty);

    // 2) Try writing when full (should be ignored)
    @(posedge clk);
    wr_en = 1;
    data_in = 8'hFF;
    rd_en = 0;
    @(posedge clk);
    wr_en = 0;
    data_in = 8'hxx;
    #5;
    $display("Attempted write when full: full=%b empty=%b", full, empty);

    // 3) Read 3 words
    $display("Read 3 values...");
    repeat (3) begin
      @(posedge clk);
      rd_en = 1;
      wr_en = 0;
    end
    @(posedge clk);
    rd_en = 0;
    #10;
    $display("After 3 reads: full=%b empty=%b", full, empty);

    // 4) Simultaneous write + read for two cycles
    $display("Simultaneous write+read...");
    @(posedge clk);
    wr_en = 1; rd_en = 1; data_in = 8'hA5;
    @(posedge clk);
    wr_en = 1; rd_en = 1; data_in = 8'h5A;
    @(posedge clk);
    wr_en = 0; rd_en = 0; data_in = 8'hxx;
    #10;

    // 5) Drain FIFO completely
    $display("Draining FIFO...");

timeout = 0;
    while (!empty && timeout < 20) begin
      @(posedge clk);
      rd_en = 1;
      wr_en = 0;
timeout = timeout +1;
    end
    @(posedge clk);
    rd_en = 0;
#10;    
$display("After draining: full=%b empty=%b", full, empty);

$display("\n---- Test complete ----\n");
#20;
$finish;
$stop;
  end

  // Monitor show per-clock summary (optional)
  always @(posedge clk) begin
    $display("T=%0t | wr=%b rd=%b full=%b empty=%b din=%h dout=%h",
             $time, wr_en, rd_en, full, empty, data_in, data_out);
end

endmodule
