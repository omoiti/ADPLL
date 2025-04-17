`timescale 1ns/1ps
module divider_tb;

  reg clk_in;
  reg reset;
  wire clk_out;
  
  divider #(.DIV_RATIO(4)) uut (
    .clk_in(clk_in),
    .reset(reset),
    .clk_out(clk_out)
  );

  initial begin
    clk_in = 0;
    forever #2 clk_in = ~clk_in; // 250MHz input
  end

  initial begin
    reset = 1;
    #20 reset = 0;
    #100 $finish;
  end

  initial begin
    $dumpfile("divider.vcd");
    $dumpvars(0, divider_tb);
    $monitor("Time=%t clk_in=%b clk_out=%b", 
             $time, clk_in, clk_out);
  end
endmodule
