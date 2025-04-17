//=======================================================
// Top-Level ADPLL with DCO, Divider, and Control Logic
//=======================================================
module adpll (
  input wire ref_clk,      // Reference clock (e.g., 10 MHz)
  input wire reset,        // Active-high reset
  input wire enable,       // Enable DCO oscillation
  output wire dco_clk      // DCO output clock
);

  // Internal signals
  wire feedback_clk;       // DCO output divided by N
  wire UP, DN;             // Phase detector outputs
  wire UP_filtered;        // Filtered UP signal
  wire DN_filtered;        // Filtered DN signal
  wire [7:0] CTW;          // Coarse Tuning Word (VLRO stages)
  wire [7:0] FTW;          // Fine Tuning Word (path selection)

  //-------------------------------------------------------
  // Feedback Divider (DCO output ÷ N)
  //-------------------------------------------------------
  divider #(
    .DIV_RATIO(8)          // Example: Divide-by-8
  ) feedback_divider (
    .clk_in(dco_clk),
    .reset(reset),
    .clk_out(feedback_clk)
  );

  //-------------------------------------------------------
  // Phase-Frequency Detector (PFD)
  //-------------------------------------------------------
  phase_detector pfd (
    .clk(ref_clk),
    .reset(reset),
    .A(ref_clk),           // Reference clock
    .B(feedback_clk),      // Divided DCO feedback
    .UP(UP),
    .DN(DN)
  );

  //-------------------------------------------------------
  // Digital Glitch Filter
  //-------------------------------------------------------
  digital_filter filter (
    .clk(ref_clk),
    .reset(reset),
    .UP_in(UP),
    .DN_in(DN),
    .UP_out(UP_filtered),
    .DN_out(DN_filtered)
  );

  //-------------------------------------------------------
  // Controller (Generates CTW/FTW for DCO)
  //-------------------------------------------------------
  controller ctrl (
    .clk(ref_clk),
    .reset(reset),
    .UP(UP_filtered),
    .DN(DN_filtered),
    .CTW(CTW),
    .FTW(FTW)
  );

  //-------------------------------------------------------
  // Digitally Controlled Oscillator (DCO)
  //-------------------------------------------------------
  dco dco_unit (
    .CTW(CTW),            // Coarse Tuning Word
    .FTW(FTW),            // Fine Tuning Word
    .enable(enable),      // Enable oscillation
    .clk_dco(dco_clk)     // DCO output clock
  );

endmodule