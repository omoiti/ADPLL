`timescale 1ns/1ps
module adpll_tb;

  reg ref_clk;
  reg reset;
  reg enable;
  wire dco_clk;
  
  adpll uut (
    .ref_clk(ref_clk),
    .reset(reset),
    .enable(enable),
    .dco_clk(dco_clk)
  );

  initial begin
    ref_clk = 0;
    forever #50 ref_clk = ~ref_clk; // 10MHz reference
  end

  initial begin
    reset = 1;
    enable = 0;
    #200 reset = 0;
    enable = 1;
    #5000 $finish;
  end

  initial begin
    $dumpfile("adpll.vcd");
    $dumpvars(0, adpll_tb);
    $monitor("Time=%t ref_clk=%b dco_clk=%b", 
             $time, ref_clk, dco_clk);
  end
endmodule
