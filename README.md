# Basys3 Stopwatch Project

## Overview
This project implements a stopwatch on the Basys3 FPGA board using SystemVerilog. The stopwatch displays time on four 7-segment displays, counting up in a BCD format (MM:SS). It supports normal speed (1Hz) and a 4x speed mode for faster counting, along with a reset functionality.

## Features
- **Clock Input**: Configurable for simulation and real hardware (100MHz on Basys3).
- **Reset**: Center button to reset the counter to 00:00.
- **Speed Up**: Switch to toggle between 1Hz and 4Hz counting speed.
- **Display**: Outputs to four 7-segment displays representing minutes and seconds.

## Project Structure
- **src/**: Contains Verilog source files and constraints.
  - `stopwatch.v`: Main stopwatch module.
  - `constraints.xdc`: Pin mapping and timing constraints for Basys3.
- **sim/**: Simulation files.
  - `stopwatch_tb.v`: Testbench for verifying BCD counter functionality.
- **basys3_stopwatch.runs/impl_1/**: Generated bitstream.
  - `stopwatch.bit`: Bitstream file for FPGA programming.

## Usage
1. **Simulation**: Use Vivado to run the simulation with `run_simulation.tcl` to verify the design.
2. **Synthesis and Implementation**: Run `reset_and_run.tcl` to generate the bitstream.
3. **Programming**: Connect the Basys3 board and use `program_fpga.tcl` to program the FPGA.
## Running TCL Scripts in Vivado

### Running the Simulation
To run the simulation script:
```bash
vivado -mode tcl -source run_simulation.tcl
```

### Running Synthesis and Implementation
To generate the bitstream:
```bash
vivado -mode tcl -source reset_and_run.tcl
```

### Programming the FPGA
To program the FPGA:
```bash
vivado -mode tcl -source program_fpga.tcl
```

## Hardware Setup
- Ensure the Basys3 board is connected via USB.
- Power on the board before running the programming script.
# basys3-counter
