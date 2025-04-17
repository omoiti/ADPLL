//=======================================================
// Digitally Controlled Oscillator (DCO)
// - Coarse Tuning: Variable-Length Ring Oscillator (VLRO)
// - Fine Tuning: Multiplexer-Based Path Selection
//=======================================================
module dco (
  input wire [7:0] CTW,      // Coarse Tuning Word (VLRO stages)
  input wire [7:0] FTW,      // Fine Tuning Word (path selection)
  input wire enable,         // Enable oscillation
  output wire clk_dco        // DCO output clock
);

  //-------------------------------------------------------
  // Coarse Tuning: Variable-Length Ring Oscillator (VLRO)
  //-------------------------------------------------------
  wire vlro_feedback;
  wire [15:0] stage_out;     // Outputs of VLRO stages

  // VLRO chain with dummy cells for load balancing
  generate
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin : vlro_chain
      // Real NAND gate (part of oscillation path)
      nand2 real_nand (
        .A(i == 0 ? vlro_feedback : stage_out[i-1]),
        .B(1'b1), // Tie one input high (acts as inverter)
        .Y(stage_out[i])
      );
      // Dummy NAND for load balancing
      nand2 dummy_nand (
        .A(stage_out[i]),
        .B(1'b1),
        .Y() // No connection (dummy load)
      );
    end
  endgenerate

  // VLRO feedback control (CTW selects active stages)
  assign vlro_feedback = (CTW >= 8'd16) ? stage_out[15] : stage_out[CTW];

  //-------------------------------------------------------
  // Fine Tuning: Multiplexer-Based Path Selection
  //-------------------------------------------------------
  wire [7:0] fine_path;      // Output of each fine stage
  wire [7:0] fine_path_a;    // Path A (faster)
  wire [7:0] fine_path_b;    // Path B (slower)

  generate
    for (i = 0; i < 8; i = i + 1) begin : fine_stage
      // Path A (?A delay)
      nand2 nand_a (
        .A(i == 0 ? stage_out[CTW] : fine_path[i-1]),
        .B(1'b1),
        .Y(fine_path_a[i])
      );
      // Path B (?B delay)
      nand2 nand_b (
        .A(i == 0 ? stage_out[CTW] : fine_path[i-1]),
        .B(1'b1),
        .Y(fine_path_b[i])
      );
      // Mux select (FTW bit controls path)
      assign fine_path[i] = FTW[i] ? fine_path_b[i] : fine_path_a[i];
    end
  endgenerate

  //-------------------------------------------------------
  // Output Clock Generation
  //-------------------------------------------------------
  reg clk_reg;
  always @(posedge fine_path[7] or negedge enable) begin
    if (!enable) clk_reg <= 0;
    else clk_reg <= ~clk_reg; // Toggle on fine_path[7] edges
  end

  assign clk_dco = clk_reg;

endmodule
