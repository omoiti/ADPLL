//=======================================================
// Two-Level TDC (Coarse Counter + Fine Delay Line)
//=======================================================
module tdc (
  input wire ref_clk,
  input wire dco_clk,
  input wire early_late,
  input wire reset,
  output reg [9:0] phase_error
);

  reg [7:0] coarse_cnt;
  reg [1:0] fine_cnt;
  wire [3:0] delay_line;

  // Coarse counter
  always @(posedge dco_clk or posedge reset) begin
    if (reset) coarse_cnt <= 0;
    else if (ref_clk) coarse_cnt <= 0;
    else coarse_cnt <= coarse_cnt + 1;
  end

  // Delay line using NAND cells (replace with library cells)
  generate
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin : delay_chain
      if (i == 0) assign delay_line[i] = dco_clk;
      else nand2 nand_cell (.A(delay_line[i-1]), .B(1'b1), .Y(delay_line[i]));
    end
  endgenerate

  // Fine counter
  always @(posedge ref_clk) begin
    if (reset) fine_cnt <= 0;
    else fine_cnt <= delay_line[3:2];
  end

  // Phase error output
  always @(posedge ref_clk) begin
    phase_error <= {coarse_cnt, fine_cnt};
  end

endmodule
