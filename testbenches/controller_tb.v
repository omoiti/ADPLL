`timescale 1ns/1ps
module controller_tb;

  reg clk;
  reg reset;
  reg UP, DN;
  wire [7:0] CTW;
  wire [7:0] FTW;
  
  controller uut (
    .clk(clk),
    .reset(reset),
    .UP(UP),
    .DN(DN),
    .CTW(CTW),
    .FTW(FTW)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1;
    UP = 0; DN = 0;
    #20 reset = 0;
    
    // Test UP pulses
    repeat(5) begin
      #20 UP = 1; #10 UP = 0;
    end
    
    // Test DN pulses
    repeat(5) begin
      #20 DN = 1; #10 DN = 0;
    end
    
    // Test both
    #20 UP = 1; DN = 1; #10 UP = 0; DN = 0;
    
    #100 $finish;
  end

  initial begin
    $dumpfile("controller.vcd");
    $dumpvars(0, controller_tb);
    $monitor("Time=%t CTW=%d FTW=%d", 
             $time, CTW, FTW);
  end
endmodule
