# NTI Digital IC Summer 2026

# 1) Labs

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
```

# 2) Final project

# RISC-V Single-Cycle Processor

A **32-bit RISC-V Single-Cycle Processor** implemented in Verilog HDL as part of the **NTI Digital IC Summer 2026 Training**.

The project covers the complete RTL-to-synthesis flow, from designing and verifying the processor at RTL level to synthesizing the design using **Synopsys Design Compiler (`dc_shell`)**.

---

## Features

* 32-bit RISC-V single-cycle processor
* Modular Verilog RTL implementation
* Instruction and data memory
* 32 general-purpose registers
* Immediate generation and sign extension
* ALU supporting arithmetic and logical operations
* Main control decoder
* ALU decoder
* Conditional branching using `BEQ`
* Load/store operations
* Assembly test programs
* RTL simulation using **QuestaSim**
* Logic synthesis using **Synopsys Design Compiler**
* Synthesis performed using **`dc_shell`**
* RTL-to-gate-level design flow

---

## Project Structure

```text
risc_v_single_cycle_processor/
│
├── Images/
│   └── Processor diagrams / simulation / synthesis images
│
├── rtl/
│   ├── adder.v
│   ├── alu.v
│   ├── alu_decoder.v
│   ├── control.v
│   ├── data_mem.v
│   ├── extend.v
│   ├── instruction_mem.v
│   ├── main_decoder.v
│   ├── program_counter.v
│   ├── reg_file.v
│   └── riscv_single.v
│
├── tb/
│   └── tb_riscv_single.v
│
├── program/
│   ├── program_control.s
│   ├── program_control.hex
│   ├── program_mem.s
│   ├── program_mem.hex
│   ├── program_r_type&imm.s
│   └── program_r_type&imm.hex
│
├── script/
│   └── Simulation and synthesis scripts
│
├── build/
│   └── Build / generated files
│
└── syn/
    └── Synthesis files and reports
```

---

# Processor Architecture

The processor follows a standard single-cycle RISC-V architecture.

```text
                 ┌─────────────────┐
                 │ Program Counter │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │ Instruction     │
                 │ Memory          │
                 └────────┬────────┘
                          │
                          ▼
                ┌───────────────────┐
                │ Control Unit      │
                │                   │
                │ Main Decoder      │
                │ ALU Decoder       │
                └─────────┬─────────┘
                          │
             ┌────────────┴────────────┐
             │                         │
             ▼                         ▼
      ┌──────────────┐          ┌─────────────┐
      │ Register File│          │ Immediate   │
      │              │          │ Extension   │
      └──────┬───────┘          └──────┬──────┘
             │                         │
             └──────────┬──────────────┘
                        ▼
                  ┌───────────┐
                  │    ALU    │
                  └─────┬─────┘
                        │
             ┌──────────┴──────────┐
             │                     │
             ▼                     ▼
      ┌─────────────┐       ┌─────────────┐
      │ Data Memory │       │ Write Back  │
      └─────────────┘       └──────┬──────┘
                                   │
                                   ▼
                            Register File
```

---

# Verification

The RTL design is verified using a dedicated Verilog testbench located in:

```text
tb/tb_riscv_single.v
```

The verification covers:

* R-type instructions
* Immediate instructions
* Branch instructions
* Load/store instructions
* Register-file operations
* Data-memory operations
* Program-counter updates

Simulation is performed using **QuestaSim**.

---

# Synthesis

After functional verification at RTL level, the processor is synthesized using **Synopsys Design Compiler (DC)**.

The synthesis flow converts the RTL Verilog description into a technology-mapped gate-level netlist based on the selected standard-cell library.

### Synthesis Tool

**Synopsys Design Compiler**

Command-line environment:

```text
dc_shell
```

### Synthesis Flow

```text
              RTL Verilog
                   │
                   ▼
          ┌─────────────────┐
          │ Read / Analyze  │
          │      RTL        │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Elaborate Design│
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Set Constraints │
          │ Clock / I/O     │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │     Compile     │
          │   / Optimize    │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Generate Reports│
          │                 │
          │ Timing          │
          │ Area            │
          │ Power           │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ Gate-Level      │
          │ Netlist         │
          └─────────────────┘
```

---

## Design Compiler Flow

The synthesis scripts are located in:

```text
script/
```

and synthesis-related files and generated reports are organized under:

```text
syn/
```

A typical Design Compiler session is started using:

```bash
dc_shell
```

The synthesis script can then be sourced from the DC shell:

```tcl
source ./script/synthesis.tcl
```

The exact script name may vary depending on the synthesis setup.

---

## Synthesis Steps

### 1. Analyze RTL

The Verilog source files are analyzed by Design Compiler.

```tcl
analyze -format verilog {
    ../rtl/adder.v
    ../rtl/alu.v
    ../rtl/alu_decoder.v
    ../rtl/control.v
    ../rtl/data_mem.v
    ../rtl/extend.v
    ../rtl/instruction_mem.v
    ../rtl/main_decoder.v
    ../rtl/program_counter.v
    ../rtl/reg_file.v
    ../rtl/riscv_single.v
}
```

### 2. Elaborate

The top-level design is elaborated:

```tcl
elaborate riscv_single
```

The design hierarchy and RTL connectivity are then checked.

### 3. Set Clock

A clock constraint is applied to the processor clock.

Example:

```tcl
create_clock -name clk -period 10 [get_ports clk]
```

This corresponds to a target clock period of:

```text
10 ns
```

or:

```text
100 MHz
```

### 4. Set Design Constraints

Input and output timing constraints can be applied to define the expected operating environment.

Typical constraints include:

```tcl
set_input_delay
set_output_delay
set_clock_uncertainty
set_driving_cell
set_load
```

### 5. Compile

Design Compiler optimizes and maps the RTL design to the target standard-cell library.

```tcl
compile
```

For more aggressive optimization, the flow may use:

```tcl
compile_ultra
```

depending on the available Design Compiler configuration.

---

# Synthesis Reports

After synthesis, several reports can be generated to evaluate the implementation.

### Area Report

```tcl
report_area
```

The area report provides information about the amount of standard-cell area used by the synthesized processor.

Important metrics include:

* Combinational area
* Sequential area
* Total cell area
* Number of cells

### Timing Report

```tcl
report_timing
```

The timing report is used to determine whether the processor meets the target clock constraint.

Important metrics include:

* Data arrival time
* Data required time
* Slack
* Critical path
* Startpoint
* Endpoint

### Constraint Report

```tcl
report_constraint -all_violators
```

This helps identify timing or design-constraint violations.

### Power Report

If power analysis is configured:

```tcl
report_power
```

This can be used to estimate:

* Switching power
* Internal power
* Leakage power
* Total power

---

# RTL-to-Gate-Level Flow

The complete project flow is:

```text
       RISC-V Assembly
              │
              ▼
       Machine Code / HEX
              │
              ▼
       ┌───────────────┐
       │ Verilog RTL   │
       └───────┬───────┘
               │
               ▼
       ┌───────────────┐
       │   QuestaSim   │
       │ RTL Simulation│
       └───────┬───────┘
               │
          Verification
               │
               ▼
       ┌───────────────┐
       │ Design        │
       │ Compiler      │
       │  (dc_shell)   │
       └───────┬───────┘
               │
               ▼
       ┌───────────────┐
       │ Synthesis     │
       │ Optimization  │
       └───────┬───────┘
               │
        ┌──────┴───────┐
        ▼              ▼
   Timing Report   Area Report
        │              │
        └──────┬───────┘
               ▼
       Gate-Level Netlist
```

---

# Tools Used

| Tool                         | Purpose                                |
| ---------------------------- | -------------------------------------- |
| **Verilog HDL**              | RTL design                             |
| **QuestaSim 2024.1**         | RTL simulation and verification        |
| **Synopsys Design Compiler** | Logic synthesis                        |
| **dc_shell**                 | Design Compiler command-line interface |
| **Git / GitHub**             | Version control and project management |
| **RISC-V toolchain**         | Assembly / machine-code generation     |

---

# Synthesis Results

The synthesis stage is used to evaluate the processor implementation in terms of:

* **Area**
* **Timing**
* **Critical path**
* **Slack**
* **Cell utilization**
* **Power**, when available

The generated synthesis reports are stored in:

```text
syn/
```

This allows the RTL implementation to be evaluated beyond functional correctness and provides an initial view of its hardware cost and timing performance.

---

# Learning Objectives

This project demonstrates practical experience with:

* RISC-V ISA
* RV32I instruction encoding
* Single-cycle CPU architecture
* Datapath design
* Control-unit design
* RTL coding in Verilog
* Functional verification
* Testbench development
* QuestaSim simulation
* Timing constraints
* Logic synthesis
* Synopsys Design Compiler
* `dc_shell`
* Area analysis
* Timing analysis
* RTL-to-gate-level design flow

---

# Future Improvements

Possible extensions include:

* Add more RV32I instructions
* Add `BNE`, `BLT`, and other branch instructions
* Add `JAL` and `JALR`
* Improve automated verification
* Add SystemVerilog assertions
* Perform gate-level simulation
* Add formal verification
* Optimize area and timing
* Add power analysis
* Implement a pipelined RISC-V processor
* Perform physical-design flow after synthesis

---

# Author

**Mazen Mahmoud**

**NTI Digital IC Summer 2026**

---

# Repository

Complete project:

[GitHub Repository](https://github.com/mazenmahmoud00/NTI_DIGITAL_IC_SUMMER_2026/tree/main/risc_v_single_cycle_processor)
