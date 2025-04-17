# All-Digital Phase-Locked Loop (ADPLL)

A synthesizable, portable ADPLL design based on standard cells. This project implements a fully digital PLL with coarse/fine frequency tuning and a two-level time-to-digital converter (TDC) for rapid frequency locking.

## Key Specifications
- **Architecture**: Fully digital, synthesizable with standard cells.
- **Process Node**: Portable across nodes
- **Frequency Range**: Configurable via Coarse/Fine Tuning Words (CTW/FTW).
- **TDC Resolution**: Two-level structure (coarse counter + fine delay line)
- **Components**: DCO, TDC, digital filter, phase detector, feedback divider.

## Block Diagram
![ADPLL Top Level Diagram](adpll.jpg)

## Modules

| Module                 | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `adpll`                | Top-level ADPLL integrating all components.                                |
| `phase_detector`       | DFF-based phase-frequency detector (PFD) generating UP/DN signals.   |
| `tdc`                  | Two-level time-to-digital converter (coarse counter + fine delay line).    |
| `digital_filter`       | Filter for loop stability.                      |
| `controller`           | Generates Coarse/Fine Tuning Words (CTW/FTW) for DCO.                      |
| `dco`                  | Digitally Controlled Oscillator (VLRO + NAND path mux).                    |
| `divider`              | Divides DCO output to generate feedback clock.                             |

## Testbenches

| Testbench               | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| `adpll_tb`             | Validates full ADPLL locking behavior and frequency tracking.              |
| `phase_detector_tb`    | Tests UP/DN signal generation.             |
| `tdc_tb`               | Measures phase error accuracy (coarse and fine resolution).                |
| `digital_filter_tb`    | Verifies filtering.                            |
| `controller_tb`        | Checks CTW/FTW generation based on filtered error signals.                 |
| `dco_tb`               | Tests DCO frequency tuning with varying CTW/FTW codes.                     |
| `divider_tb`           | Validates frequency division functionality.                           |

