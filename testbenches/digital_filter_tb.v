`timescale 1ns/1ps
module digital_filter_tb;

  reg clk;
  reg reset;
  reg UP_in, DN_in;
  wire UP_out, DN_out;
  
  digital_filter uut (
    .clk(clk),
    .reset(reset),
    .UP_in(UP_in),
    .DN_in(DN_in),
    .UP_out(UP_out),
    .DN_out(DN_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1;
    UP_in = 0; DN_in = 0;
    #20 reset = 0;
    
    // Test glitch filtering
    #10 UP_in = 1; #2 UP_in = 0; // Short glitch
    #20 UP_in = 1; #15 UP_in = 0; // Valid pulse
    
    #20 DN_in = 1; #2 DN_in = 0; // Short glitch
    #20 DN_in = 1; #15 DN_in = 0; // Valid pulse
    
    #50 $finish;
  end

  initial begin
    $dumpfile("digital_filter.vcd");
    $dumpvars(0, digital_filter_tb);
    $monitor("Time=%t UP_in=%b DN_in=%b UP_out=%b DN_out=%b", 
             $time, UP_in, DN_in, UP_out, DN_out);
  end
endmodule
