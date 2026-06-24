\# 32-Bit RISC-V Single-Cycle Processor



A structural Verilog implementation of a 32-bit RISC-V processor core based on the RV32I instruction set architecture. This project features a complete single-cycle datapath, a dedicated control unit, and Harvard architecture memory modules, fully verified via Icarus Verilog simulation.



\## 🏗️ Architecture Overview



\* \*\*Architecture:\*\* 32-bit RISC-V (RV32I Base Integer Instruction Set)

\* \*\*Design Type:\*\* Single-Cycle Datapath

\* \*\*Memory Structure:\*\* Harvard Architecture (Separate Instruction and Data Memory)

\* \*\*Implementation Language:\*\* Verilog (Structural \& Behavioral RTL)

\* \*\*Simulation Tool:\*\* Icarus Verilog / EDA Playground (EPWave)



\*(📸 \*\*Insert Image Here:\*\* Upload a block diagram of your datapath showing the PC, ALU, Register File, and Control Unit routing)\*



\---



\## ⚙️ Supported Instruction Set



The core successfully decodes and executes the following fundamental RV32I instructions:



| Type | Instruction | Assembly Format | Operation |

| :--- | :--- | :--- | :--- |

| \*\*R-Type\*\* | `add` | `add rd, rs1, rs2` | Addition (Register to Register) |

| \*\*I-Type\*\* | `addi` | `addi rd, rs1, imm` | Addition (Immediate) |

| \*\*Store\*\* | `sw` | `sw rs2, offset(rs1)` | Store Word to Data Memory |

| \*\*Load\*\* | `lw` | `lw rd, offset(rs1)` | Load Word from Data Memory |

| \*\*Branch\*\* | `beq` | `beq rs1, rs2, offset`| Branch if Equal |



\---



\## 🔬 Verification \& Waveforms



The processor's architectural state and control logic were rigorously verified using targeted machine-code testbenches. 



\### 1. Arithmetic \& Register Writeback

\*\*Test:\*\* `addi x1, x0, 5` -> `addi x2, x0, 7` -> `add x3, x1, x2`

\*(📸 \*\*Insert Image Here:\*\* Upload your 2nd screenshot showing `WD3` calculating `c`)\*

\* \*\*Result:\*\* The ALU successfully processes immediate and register values, and the `WE3` signal correctly asserts to save the final calculation (`0xc` / 12) back into the register file.



\### 2. Control Flow \& Branching Logic

\*\*Test:\*\* `addi x1, x0, 1` -> `beq x1, x1, -4` (Infinite Loop)

\*(📸 \*\*Insert Image Here:\*\* Upload your 1st screenshot showing `PC\_Top` looping 0->4->0)\*

\* \*\*Result:\*\* The ALU `zero` flag successfully triggers the control unit's `pc\_src` multiplexer, dynamically rerouting the Program Counter backward instead of continuing sequentially.



\### 3. Memory Subsystem Interface

\*\*Test:\*\* `addi x4, x0, 15` -> `sw x4, 0(x0)` -> `lw x5, 0(x0)`

\*(📸 \*\*Insert Image Here:\*\* Upload your 3rd screenshot showing `MemWrite` and `ReadData`)\*

\* \*\*Result:\*\* Data is successfully routed from the register file to Data Memory (`sw`). On the subsequent clock cycle, the writeback multiplexer correctly isolates the memory output to load the stored data back into a new register (`lw`).



\---



\## 🚀 How to Run the Simulation



You can view and execute the RTL code directly in your browser without any CAD tool installation:



1\. Navigate to the live workspace: \*\*\[Insert Your EDA Playground Link Here]\*\*

2\. Ensure the simulator is set to \*\*Icarus Verilog 0.9.7\*\*.

3\. Check the box for \*\*Open EPWave after run\*\*.

4\. Click \*\*Run\*\* to compile the core and view the interactive waveforms.

