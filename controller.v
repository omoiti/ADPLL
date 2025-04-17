//=======================================================
// Controller with Up/Down Counters
//=======================================================
module controller (
  input wire clk,         // System clock
  input wire reset,       // System reset
  input wire UP,          // Filtered UP signal
  input wire DN,          // Filtered DN signal
  output wire [15:0] FTW  // Frequency Tuning Word (to DCO)
);

  reg [7:0] up_cnt;       // Up counter (increments on UP)
  reg [7:0] dn_cnt;       // Down counter (increments on DN)
  reg up_carry, dn_borrow; // Overflow flags

  // Up counter (counts UP pulses)
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      up_cnt <= 8'b0;
      up_carry <= 0;
    end else if (UP) begin
      if (up_cnt == 8'hFF) begin
        up_cnt <= 8'b0;
        up_carry <= 1;
      end else begin
        up_cnt <= up_cnt + 1;
        up_carry <= 0;
      end
    end
  end

  // Down counter (counts DN pulses)
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      dn_cnt <= 8'b0;
      dn_borrow <= 0;
    end else if (DN) begin
      if (dn_cnt == 8'hFF) begin
        dn_cnt <= 8'b0;
        dn_borrow <= 1;
      end else begin
        dn_cnt <= dn_cnt + 1;
        dn_borrow <= 0;
      end
    end
  end

  // Calculate FTW as difference between up/dn counts
  assign FTW = {8'b0, up_cnt} - {8'b0, dn_cnt};

endmodule
