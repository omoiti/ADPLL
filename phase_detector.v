//=======================================================
// Phase-Frequency Detector (PFD) with D Flip-Flops
//=======================================================
module phase_detector (
  input wire clk,       // System clock
  input wire reset,      // System reset
  input wire A,          // Reference signal (e.g., 10 MHz)
  input wire B,          // Feedback signal (from DCO divider)
  output reg UP,         // "Increase frequency" flag
  output reg DN          // "Decrease frequency" flag
);

  reg [1:0] ff;  // DFFs for detecting edges of A and B

  // Detect rising edges of A and B
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ff <= 2'b00;
      UP <= 0;
      DN <= 0;
    end else begin
      ff <= {A, B};  // Sample A and B
      // Detect rising edges
      if (ff[0] && !B) DN <= 1;    // B rising edge detected
      else if (ff[1] && !A) UP <= 1; // A rising edge detected
      else begin
        UP <= 0;
        DN <= 0;
      end
    end
  end

  // Reset UP/DN when both are high (classic PFD behavior)
  always @(posedge clk) begin
    if (UP && DN) begin
      UP <= 0;
      DN <= 0;
    end
  end

endmodule
