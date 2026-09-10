# NTI Digital IC Summer 2026

# Labs

This directory contains the core source files, verification environments, build artifacts, and automation scripts for the digital integrated circuit design labs.

## 📂 Directory Structure

* **`build/`**: Working directory used for compilation outputs, synthesis reports, and running simulations.
* **`rtl/`**: Houses the synthesizable Register-Transfer Level (RTL) source files (Verilog/SystemVerilog hardware description logic).
* **`script/`**: Contains automation scripts configured with self-contained relative paths, allowing you to build and execute seamlessly from any terminal.
* **`tb/`**: Contains testbenches and verification components used for functional simulation and waveform validation.

## 🚀 Running Simulations

All script paths are fully adjusted. To run codes via Questa or ModelSim from any terminal, navigate to the **`build/`** directory and run the do-file from the scripts folder:

```bash
cd build
vsim -do ../script/<script_name>.do
