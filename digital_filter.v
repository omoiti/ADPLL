//=======================================================
// Digital Glitch Filter
//=======================================================
module digital_filter (
  input wire clk,       // System clock
  input wire reset,     // System reset
  input wire UP_in,     // Raw UP signal from PFD
  input wire DN_in,     // Raw DN signal from PFD
  output reg UP_out,    // Filtered UP signal
  output reg DN_out     // Filtered DN signal
);

  // 2-stage synchronizer to filter glitches
  reg [1:0] UP_sync, DN_sync;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      UP_sync <= 2'b00;
      DN_sync <= 2'b00;
      UP_out <= 0;
      DN_out <= 0;
    end else begin
      UP_sync <= {UP_sync[0], UP_in};
      DN_sync <= {DN_sync[0], DN_in};
      // Filtered outputs (majority vote)
      UP_out <= (UP_sync[1] & UP_sync[0]) | (UP_sync[1] & UP_out) | (UP_sync[0] & UP_out);
      DN_out <= (DN_sync[1] & DN_sync[0]) | (DN_sync[1] & DN_out) | (DN_sync[0] & DN_out);
    end
  end

endmodule