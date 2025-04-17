`timescale 1ns/1ps
module phase_detector_tb;

  reg clk;
  reg reset;
  reg A, B;
  wire UP, DN;
  
  phase_detector uut (
    .clk(clk),
    .reset(reset),
    .A(A),
    .B(B),
    .UP(UP),
    .DN(DN)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end

  initial begin
    reset = 1;
    A = 0; B = 0;
    #20 reset = 0;
    
    // Test 1: A leads B
    #30 A = 1; #10 B = 1;
    #50 A = 0; B = 0;
    
    // Test 2: B leads A
    #50 B = 1; #10 A = 1;
    #50 A = 0; B = 0;
    
    // Test 3: Simultaneous edges
    #50 A = 1; B = 1;
    #50 A = 0; B = 0;
    
    #100 $finish;
  end

  initial begin
    $dumpfile("phase_detector.vcd");
    $dumpvars(0, phase_detector_tb);
    $monitor("Time=%t A=%b B=%b UP=%b DN=%b", 
             $time, A, B, UP, DN);
  end
endmodule
