//=======================================================
// Clock Divider (DCO output ÷ DIV_RATIO)
//=======================================================
module divider (
  input wire clk_in,     // Input clock (from DCO)
  input wire reset,      // Active-high reset
  output reg clk_out     // Divided output
);

  parameter DIV_RATIO = 8; // Default divide-by-8
  reg [31:0] count;

  always @(posedge clk_in or posedge reset) begin
    if (reset) begin
      count <= 0;
      clk_out <= 0;
    end else begin
      if (count == DIV_RATIO - 1) begin
        count <= 0;
        clk_out <= ~clk_out;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule
