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

# 2) Final Project

# RISC-V Single-Cycle Processor

A **32-bit RISC-V Single-Cycle Processor** implemented in Verilog HDL as part of the **NTI Digital IC Summer 2026 Training**.

The project implements a modular single-cycle datapath containing the program counter, instruction memory, register file, ALU, immediate extension unit, control unit, and data memory.

The processor is designed for educational purposes to demonstrate the fundamentals of **RISC-V ISA**, datapath design, control generation, RTL modeling, simulation, and verification.

---

## Features

* 32-bit RISC-V processor
* Single-cycle datapath
* Modular Verilog RTL implementation
* Separate instruction and data memories
* 32 general-purpose registers
* Immediate generation and sign extension
* ALU supporting arithmetic and logical operations
* Main control decoder
* ALU decoder
* Conditional branching using `BEQ`
* Load/store memory operations
* Assembly programs converted to machine-code HEX files
* Automated simulation through a dedicated testbench
* Designed for simulation using **QuestaSim / ModelSim**

---

## Supported Instructions

The current implementation supports a subset of the **RV32I** instruction set.

### R-Type

| Instruction | Description            |
| ----------- | ---------------------- |
| `ADD`       | Addition               |
| `SUB`       | Subtraction            |
| `AND`       | Bitwise AND            |
| `OR`        | Bitwise OR             |
| `SLT`       | Set Less Than          |
| `SLTU`      | Set Less Than Unsigned |

### I-Type

| Instruction | Description                      |
| ----------- | -------------------------------- |
| `ADDI`      | Add Immediate                    |
| `ANDI`      | AND Immediate                    |
| `ORI`       | OR Immediate                     |
| `SLTI`      | Set Less Than Immediate          |
| `SLTIU`     | Set Less Than Immediate Unsigned |
| `LW`        | Load Word                        |

### S-Type

| Instruction | Description |
| ----------- | ----------- |
| `SW`        | Store Word  |

### B-Type

| Instruction | Description     |
| ----------- | --------------- |
| `BEQ`       | Branch if Equal |

The control logic identifies load, store, R-type, immediate ALU, and branch instructions through their RISC-V opcodes.

---

## Processor Architecture

The processor follows the standard single-cycle architecture:

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

The top-level module connects the PC, instruction memory, control logic, register file, immediate extension, ALU, data memory, and PC branch-target calculation.

---

## Project Structure

```text
risc_v_single_cycle_processor/
│
├── Images/
│   └── Processor diagrams / simulation images
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
│   └── Simulation / build scripts
│
├── build/
│   └── Build and generated files
│
└── syn/
    └── Synthesis-related files
```

The RTL directory contains the individual processor blocks, while the `program` directory contains assembly test programs and their corresponding HEX machine-code files.

---

## RTL Modules

### `riscv_single.v`

Top-level processor module.

It integrates:

* Program Counter
* Instruction Memory
* Register File
* Control Unit
* Immediate Extension
* ALU
* Data Memory
* PC + 4 adder
* Branch target adder
* Multiplexing for ALU and write-back paths

### `program_counter.v`

Stores the current program counter and updates it on every clock cycle.

The next PC is selected between:

```text
PC + 4
```

and

```text
PC + Immediate
```

for taken branches.

### `instruction_mem.v`

Contains the instruction memory.

The current implementation uses a 256-word memory:

```verilog
reg [31:0] mem [0:255];
```

Instructions are addressed using `A[31:2]`, reflecting 32-bit word-aligned instructions.

### `reg_file.v`

Implements the RISC-V register file with:

* Two read ports
* One write port
* Register write enable
* Clocked writes

The testbench accesses the internal register array for verification.

### `alu.v`

Performs arithmetic and logical operations.

Current ALU operations include:

```text
ADD
SUB
AND
OR
SLT
```

The ALU also generates a `zero` flag used by `BEQ`.

### `extend.v`

Generates and sign-extends immediate values according to the instruction format.

The immediate formats used include:

* I-type
* S-type
* B-type

### `main_decoder.v`

Generates the main control signals based on the instruction opcode.

Important control signals include:

```text
Branch
ResultSrc
MemWrite
ALUSrc
ImmSrc
RegWrite
ALUOp
```

### `alu_decoder.v`

Converts `ALUOp`, `funct3`, and `funct7` information into the required ALU control signal.

It distinguishes operations such as:

```text
ADD
SUB
SLT
SLTU
OR
AND
```

### `data_mem.v`

Implements the processor's data memory and supports memory read/write operations for `LW` and `SW`.

---

# Instruction Execution

## R-Type

Example:

```asm
add x4, x1, x2
```

The processor:

1. Fetches the instruction.
2. Reads `x1` and `x2`.
3. Selects register data as ALU inputs.
4. ALU performs addition.
5. Result is written back to `x4`.

---

## I-Type

Example:

```asm
addi x3, x1, 10
```

The immediate is generated by the immediate extension unit and selected as the second ALU input.

```text
Register → ALU ← Immediate
```

---

## Load Word

Example:

```asm
lw x4, 16(x0)
```

Execution:

```text
Base Register + Immediate
          ↓
      ALU Address
          ↓
      Data Memory
          ↓
      Register File
```

---

## Store Word

Example:

```asm
sw x3, 16(x0)
```

Execution:

```text
Base Register + Immediate
          ↓
      ALU Address
          ↓
      Data Memory
          ↑
       Register
```

The ALU calculates the memory address while the register file supplies the data to be stored.

---

## BEQ

Example:

```asm
beq x1, x2, label
```

The ALU subtracts the two register operands:

```text
x1 - x2
```

If the result is zero:

```text
zero = 1
```

and the branch target is selected as the next PC.

The top-level datapath implements:

```verilog
assign pc_next = pc_src ? pc_target : pc_plus_4;
```

---

# Verification

The project includes a dedicated Verilog testbench:

```text
tb/tb_riscv_single.v
```

The testbench verifies three major groups of functionality:

### 1. R-Type and Immediate Instructions

Tests include:

* `ADD`
* `SUB`
* `AND`
* `OR`
* `XOR`
* `SLT`
* `ORI`
* `ANDI`
* `SLTI`

### 2. Control Flow

The `BEQ` program verifies conditional branching and checks the resulting register value.

### 3. Memory Operations

The memory test verifies:

* `SW`
* `LW`

For example, the testbench checks that memory location `16` contains `50` after the store operation and that the value can subsequently be loaded into register `x4`.

---

# Test Programs

The `program/` directory contains assembly programs and their machine-code representations.

### `program_r_type&imm.s`

Tests arithmetic, logical, comparison, and immediate instructions.

### `program_control.s`

Tests control-flow behavior, particularly `BEQ`.

### `program_mem.s`

Tests load/store operations.

Each assembly program has a corresponding `.hex` file that can be loaded into instruction memory during simulation.

---

# Simulation

The project is intended to be simulated using **QuestaSim / ModelSim**.

A typical simulation flow is:

```text
1. Compile RTL
       ↓
2. Compile Testbench
       ↓
3. Start Simulation
       ↓
4. Apply Reset
       ↓
5. Load Program HEX
       ↓
6. Run Clock Cycles
       ↓
7. Check Register / Memory Results
```

The testbench uses `$readmemh` to load the selected HEX program into instruction memory.

Example:

```verilog
$readmemh("../program/program_control.hex", dut.imem.mem);
```

---

# Reset

The processor includes an active reset input:

```verilog
input rst
```

During reset, the program counter and relevant state are initialized before program execution begins.

The testbench applies reset for several clock cycles before releasing the processor.

---

# Design Philosophy

The processor is intentionally implemented as a **single-cycle architecture**.

Each instruction completes all of its required operations within one clock cycle:

```text
Instruction Fetch
       ↓
Instruction Decode
       ↓
Register Read
       ↓
Execute
       ↓
Memory Access
       ↓
Write Back
```

This makes the architecture simple to understand and suitable for learning CPU datapath and control design.

---

# Tools

Recommended tools:

* **QuestaSim 2024.1**
* ModelSim
* Verilog HDL
* RISC-V assembler/toolchain for generating machine code
* Git / GitHub

---

# Learning Objectives

This project demonstrates practical understanding of:

* RISC-V instruction encoding
* CPU datapath design
* Control-unit design
* ALU design
* Register-file implementation
* Instruction and data memories
* Immediate generation
* Branch handling
* RTL design using Verilog
* Testbench development
* Functional verification
* Simulation using QuestaSim
* Basic synthesis flow

---

# Future Improvements

Possible extensions include:

* Add `BNE`
* Add `JAL`
* Add `JALR`
* Add additional branch instructions
* Add more RV32I instructions
* Improve memory initialization
* Add automated pass/fail verification
* Add assertions
* Add waveform documentation
* Add synthesis reports
* Add FPGA implementation
* Extend the design to a pipelined RISC-V processor

---

# Author

**Mazen Mahmoud**

Digital IC / RTL Design Training
**NTI Digital IC Summer 2026**

---

# Repository

The complete project is available here:

[RISC-V Single-Cycle Processor — GitHub](https://github.com/mazenmahmoud00/NTI_DIGITAL_IC_SUMMER_2026/tree/main/risc_v_single_cycle_processor?utm_source=chatgpt.com)

---

## License

This project was developed for educational and training purposes as part of the NTI Digital IC Summer 2026 program.
