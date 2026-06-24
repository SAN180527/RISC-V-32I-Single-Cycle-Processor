# 32-Bit RISC-V Single-Cycle Processor

A structural Verilog implementation of a 32-bit RISC-V processor core based on the RV32I instruction set architecture. This project features a complete single-cycle datapath, a dedicated control unit, and Harvard architecture memory modules, fully verified via Icarus Verilog simulation.

## Architecture Overview

* **Architecture:** 32-bit RISC-V (RV32I Base Integer Instruction Set)
* **Design Type:** Single-Cycle Datapath
* **Memory Structure:** Harvard Architecture (Separate Instruction and Data Memory)
* **Implementation Language:** Verilog (Structural & Behavioral RTL)
* **Simulation Tool:** Icarus Verilog / EDA Playground (EPWave)

<img src="RISC_V_image.png" width="700">
*Diagram based on the RISC-V Single-Cycle Datapath from Harris & Harris, "Digital Design and Computer Architecture".*

---

## Supported Instruction Set

The core successfully decodes and executes the following fundamental RV32I instructions. The ALU and Control Unit were implemented as modular Verilog components, mapped directly to the RV32I datapath structure.

| Type | Instruction | Assembly Format | Operation |
| :--- | :--- | :--- | :--- |
| **R-Type** | `add` | `add rd, rs1, rs2` | Addition (Register to Register) |
| **I-Type** | `addi` | `addi rd, rs1, imm` | Addition (Immediate) |
| **Store** | `sw` | `sw rs2, offset(rs1)` | Store Word to Data Memory |
| **Load** | `lw` | `lw rd, offset(rs1)` | Load Word from Data Memory |
| **Branch** | `beq` | `beq rs1, rs2, offset`| Branch if Equal |

---

## Verification & Waveforms

The processor's architectural state and control logic were rigorously verified using targeted machine-code testbenches. 

### 1. Arithmetic & Register Writeback
**Test:** `addi x1, x0, 5` -> `addi x2, x0, 7` -> `add x3, x1, x2`

<img src="Screenshot 2026-06-24 171811.png" width="700">

* **Result:** The ALU successfully processes immediate and register values, and the `WE3` signal correctly asserts to save the final calculation (`x3 = 0xc = 12`) back into the register file.
* **Note on Simulation State:** `WE3` enters an undefined state (X) after the final instruction as the processor fetches from uninitialized memory - expected behavior in simulation when no program termination instruction is present.

### 2. Control Flow & Branching Logic
**Test:** `addi x1, x0, 1` -> `beq x1, x1, -4` (Infinite Loop)

<img src="Screenshot 2026-06-24 172241.png" width="700">

* **Result:** The ALU `zero` flag successfully triggers the control unit's `pc_src` multiplexer, dynamically rerouting the Program Counter backward instead of continuing sequentially.

### 3. Memory Subsystem Interface
**Test:** `addi x4, x0, 15` -> `sw x4, 0(x0)` -> `lw x5, 0(x0)`

<img src="Screenshot 2026-06-24 172716.png" width="700">

* **Result:** Data is successfully routed from the register file to Data Memory via `sw`. On the subsequent clock cycle, `ResultSrc=1` selects `ReadData` over `ALU_Result` at the write-back multiplexer, loading the value stored by `sw` back into `x5` via `lw`.
* **Note on Simulation State:** Signals enter an undefined state (X) after the final instruction as the processor fetches from uninitialized memory - expected behavior in simulation when no program termination instruction is present.
