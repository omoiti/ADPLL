`timescale 1ns/1ps

module tdc_tb;

  // Inputs
  reg ref_clk;        // Reference clock (10 MHz)
  reg dco_clk;        // DCO clock (100 MHz)
  reg early_late;     // Phase detector output (not used in this TDC)
  reg reset;          // Active-high reset

  // Outputs
  wire [9:0] phase_error; // TDC output: {coarse_cnt[7:0], fine_cnt[1:0]}

  // Instantiate TDC
  tdc uut (
    .ref_clk(ref_clk),
    .dco_clk(dco_clk),
    .early_late(early_late),
    .reset(reset),
    .phase_error(phase_error)
  );

  // Generate reference clock (10 MHz, period = 100ns)
  initial begin
    ref_clk = 0;
    forever #50 ref_clk = ~ref_clk;
  end

  // Generate DCO clock (100 MHz, period = 10ns) with varying phase shifts
  initial begin
    dco_clk = 0;
    // Phase shifts to test:
    // - Case 1: DCO leads by 2ns
    #2; // Initial phase shift
    forever #5 dco_clk = ~dco_clk;
  end

  // Control reset and test sequence
  initial begin
    reset = 1;
    early_late = 0; // Not used in this TDC
    #100; // Hold reset for 100ns

    // Release reset and observe TDC output
    reset = 0;

    // Test 1: DCO leads reference by 2ns
    #200; // Wait for TDC to capture
    $display("Test 1: Phase Error = %d (Expected Coarse=0, Fine=2)", phase_error);

    // Test 2: Change phase shift (DCO leads by 7ns)
    $display("Re-initializing DCO clock with 7ns phase shift...");
    #100;
    // Reset DCO clock with new phase shift
    dco_clk = 0;
    #7;
    forever #5 dco_clk = ~dco_clk;

    #200;
    $display("Test 2: Phase Error = %d (Expected Coarse=0, Fine=7)", phase_error);

    // Test 3: Reset and check zero phase error
    reset = 1;
    #100;
    reset = 0;
    #200;
    $display("Test 3: Phase Error = %d (Expected 0 after reset)", phase_error);

    #100 $finish;
  end

  // Dump waveforms for analysis
  initial begin
    $dumpfile("tdc_tb.vcd");
    $dumpvars(0, tdc_tb);
  end

endmodule
