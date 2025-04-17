`timescale 1ns/1ps
module dco_tb;

  reg [7:0] CTW;
  reg [7:0] FTW;
  reg enable;
  wire clk_dco;
  
  // Variables for period measurement
  real last_edge;
  real last_period;
  
  dco uut (
    .CTW(CTW),
    .FTW(FTW),
    .enable(enable),
    .clk_dco(clk_dco)
  );

  // Capture clock edges for period calculation
  always @(posedge clk_dco) begin
    if (last_edge != 0) begin
      last_period = $realtime - last_edge;
    end
    last_edge = $realtime;
  end

  initial begin
    enable = 0;
    CTW = 8'd8; // Mid-range CTW
    FTW = 8'd128; // Mid-range FTW
    last_edge = 0;
    last_period = 0;
    
    #50 enable = 1;
    
    // Test CTW variation
    #200 CTW = 8'd4;
    #200 CTW = 8'd12;
    
    // Test FTW variation
    #200 FTW = 8'd64;
    #200 FTW = 8'd192;
    
    #500 $finish;
  end

  initial begin
    $dumpfile("dco.vcd");
    $dumpvars(0, dco_tb);
    $monitor("Time=%t CTW=%d FTW=%d Period=%0.1fns", 
             $time, CTW, FTW, last_period);
  end
endmodule
