# 4-Bit Reprogrammable Processor Documentation and Instruction Manual

## Documentation Guide

### 1. Introduction
This document describes a 4-bit reprogrammable processor designed in VHDL and implemented on a Digilent Basys 3 FPGA board using Xilinx Vivado. The processor is intended for educational purposes, demonstrating fundamental concepts of computer architecture, including instruction execution, register operations, and reprogrammable memory. Key features include:
- 4-bit data processing with an ALU supporting addition and subtraction.
- 8-word, 12-bit instruction memory, reprogrammable via switches.
- 8 registers (R0–R7), with R0 fixed at `0000`.
- 4-digit 7-segment display for real-time output of program counter, register number, negative flag, and register value.
- Support for continuous (`Run`) and step-by-step (`Step`) execution.
- Conditional jump instruction based on the zero flag.

### 2. Architecture Overview
The processor consists of the following components:
- **Program Counter (PC)**: 3-bit counter addressing up to 8 instructions.
- **Program RAM**: 8x12-bit memory storing instructions, reprogrammable via switches.
- **Instruction Decoder**: Decodes 12-bit instructions to control ALU, registers, and jumps.
- **ALU (AddSub_4bit)**: Performs 4-bit addition or subtraction, generating zero, overflow, and negative flags.
- **Register Bank**: Eight 4-bit registers (R0 fixed at `0000`, R1–R7 general-purpose).
- **Multiplexers**: Select register data and immediate values for ALU and register writes.
- **I/O System**: Drives a 4-digit 7-segment display to show PC, register number, negative flag, and register value.
- **Slow Clock**: Divides 100 MHz input clock to ~3 Hz for step-by-step execution.

**Data Path**:
- Instructions are fetched from Program RAM using the PC’s address.
- The Instruction Decoder extracts opcode, register addresses, and immediate/jump values.
- The ALU processes data from registers or immediate values, selected via a 2-to-1 MUX.
- Results are written back to the Register Bank.
- The I/O System displays the PC, selected register, and flags.

**Control Signals**:
- `Run`/`Step`: Enable continuous or single-step execution.
- `Upload`: Enables writing to Program RAM.
- `Res`, `ResRB`, `ResRAM`: Reset PC, registers, and RAM, respectively.

### 3. VHDL Implementation
The processor is implemented in VHDL with the following modules:
- **AddSub_4bit**: 4-bit ALU for addition (`Op = '0'`) or subtraction (`Op = '1'`), generating `Q` (result), `Zero`, `Overflow`, and `Cout`.
- **Program_counter**: 3-bit PC, incrementing or jumping based on `JFlag` and `JAdr`.
- **Instruction_Decoder**: Decodes 12-bit instructions to generate control signals (`RegEn`, `LoadSel`, `Op`, etc.).
- **Program_RAM**: 8x12-bit memory using `REG_12bit` registers, with default instructions loaded on reset.
- **Register_Bank**: Eight 4-bit registers (`REG`), with R0 fixed at `0000`.
- **MUX_8_to_1_4bit/12bit**: Selects register data or instructions based on 3-bit addresses.
- **MUX_2_to_1_4bit**: Selects between ALU output and immediate value.
- **IO_System**: Multiplexes 4-digit 7-segment display (refresh rate ~2.5 ms at 100 MHz).
- **Slow_Clock**: Divides 100 MHz clock to ~3 Hz.
- **REG_12bit/REG**: 12-bit and 4-bit registers for RAM and Register Bank.
- **Decoder_3_to_8/2_to_4**: Decoders for register and RAM write enables.

**Clocking**: The processor uses a 100 MHz input clock, divided to ~3 Hz by `Slow_Clock` for most components. The I/O System uses the full 100 MHz clock for display refresh.

**Interconnections** (from `Processor_4bit`):
- Program Counter feeds address to Program RAM.
- Program RAM outputs instructions to Instruction Decoder.
- Instruction Decoder controls ALU, Register Bank, and jumps.
- Register Bank outputs feed MUXes for ALU inputs and display.
- ALU output or immediate value is selected for register writes.
- I/O System displays PC, register number, negative flag, and register value.

### 4. Instruction Set
The processor supports four instructions, encoded in 12 bits:
| Instruction | Opcode [11:10] | Format                | Description                              |
|-------------|----------------|-----------------------|------------------------------------------|
| ADD         | 00             | 00 RRR BBB 0000       | R[RRR] ← R[RRR] + R[BBB]                |
| MOVI        | 10             | 10 RRR 000 dddd       | R[RRR] ← dddd (immediate value)         |
| NEG         | 01             | 01 RRR 000 0000       | R[RRR] ← 0 - R[RRR]                     |
| JZ          | 11             | 11 RRR 000 0ddd       | If Zero = 1, PC ← ddd; else PC ← PC + 1 |

- **RRR**: 3-bit destination register (R0–R7).
- **BBB**: 3-bit source register (R0–R7).
- **dddd**: 4-bit immediate value.
- **ddd**: 3-bit jump address.

**Example**:
- `00 001 010 0000` → ADD R1, R2 (R1 ← R1 + R2).
- `10 001 000 1010` → MOVI R1, 10 (R1 ← 1010).
- `01 001 000 0000` → NEG R1 (R1 ← 0 - R1).
- `11 000 000 0011` → JZ 3 (Jump to address 3 if Zero = 1).

### 5. Reprogrammability Features
- **Program Memory**: 8x12-bit RAM, implemented as registers (`REG_12bit`).
- **Reprogramming**: Set `Data_write` (12 switches) to the desired instruction, set PC to the target address, and press `Upload` to write.
- **Default Program**: Loaded on reset (`ResRAM = '1'`):
  - Address 0: `100010001010` (MOVI R1, 10)
  - Address 1: `100100000001` (MOVI R2, 1)
  - Address 2: `010100000000` (NEG R2)
  - Address 3: `000010100000` (ADD R1, R2)
  - Address 4: `110010000111` (JZ 7)
  - Address 5: `110000000011` (JZ 3)
  - Address 6: `000000000000` (NOP, implemented as ADD R0, R0)
  - Address 7: `000000000000` (NOP)

### 6. Simulation and Testing
- **Simulation Setup**: Use Vivado’s simulator to create testbenches for individual modules (`AddSub_4bit`, `Program_counter`, etc.) and the top-level `Processor_4bit`.
- **Recommended Testbenches**:
  - **ALU**: Test addition (e.g., `0011 + 0010`), subtraction (e.g., `0100 - 0010`), and flag generation (Zero, Overflow).
  - **Program Counter**: Test increment, jump, and reset.
  - **Instruction Decoder**: Test all instruction types with sample inputs.
  - **Top-Level**: Run the default program and verify register values, PC, and display outputs.
- **Example Test Case**: Load the default program, set `Run = '1'`, and check R1 = `1111` (15) after execution (MOVI R1, 10; MOVI R2, 1; NEG R2; ADD R1, R2).

### 7. Synthesis and Implementation
- **Target**: Digilent Basys 3 (Artix-7 FPGA).
- **Constraints**: Defined in `Basys3Labs.xdc`:
  - Clock: 100 MHz on pin W5.
  - Inputs: 12 switches (`Data_write`), 3 switches (`RegSel`), buttons (`Res`, `ResRB`, `ResRAM`, `Upload`, `Step`), switch (`Run`).
  - Outputs: 12 LEDs (`Command`), 3 LEDs (`Flags`), 4-digit 7-segment display (`Data_seg`, `An_out`).
- **Resource Utilization**: Estimated low due to simple design (e.g., ~100 LUTs, ~50 FFs, no DSPs or BRAM).
- **Setup**: Create a Vivado project, add VHDL files, set `Processor_4bit` as top module, and apply `Basys3Labs.xdc`.

### 8. Limitations and Future Improvements
- **Limitations**:
  - 4-bit data width limits numerical range (0–15).
  - 8-instruction memory restricts program complexity.
  - Limited instruction set (no logical operations or direct branching).
- **Future Improvements**:
  - Expand to 8-bit data width.
  - Increase program memory size.
  - Add instructions (e.g., AND, OR, unconditional jump).
  - Implement BRAM for program memory.

## Instruction Manual

### 1. Getting Started
- **Prerequisites**:
  - Digilent Basys 3 FPGA board.
  - Xilinx Vivado 2018.1 or later.
  - USB cable for programming.
- **Inputs (Switches and Buttons)**:
  - **Switches (16 total)**:
    - `Data_write[0]` (V17): Bit 0 of 12-bit instruction input.
    - `Data_write[1]` (V16): Bit 1.
    - `Data_write[2]` (W16): Bit 2.
    - `Data_write[3]` (W17): Bit 3.
    - `Data_write[4]` (W15): Bit 4.
    - `Data_write[5]` (V15): Bit 5.
    - `Data_write[6]` (W14): Bit 6.
    - `Data_write[7]` (W13): Bit 7.
    - `Data_write[8]` (V2): Bit 8.
    - `Data_write[9]` (T3): Bit 9.
    - `Data_write[10]` (T2): Bit 10.
    - `Data_write[11]` (R3): Bit 11.
    - `RegSel[0]` (W2): Bit 0 of register select (R0–R7).
    - `RegSel[1]` (U1): Bit 1.
    - `RegSel[2]` (T1): Bit 2.
    - `Run` (R2): Enables continuous execution (~3 Hz).
  - **Buttons (5 total)**:
    - `Res` (U18, center): Resets Program Counter to `000`.
    - `ResRB` (W19, left): Resets Register Bank to `0000` (except R0).
    - `ResRAM` (U17, down): Resets Program RAM to default program.
    - `Upload` (T18, up): Writes `Data_write` to Program RAM at current PC address.
    - `Step` (T17, right): Executes one instruction per press.
- **Outputs (LEDs and 7-Segment Display)**:
  - **LEDs (15 total)**:
    - `Command[0]` (U16): Bit 0 of current instruction.
    - `Command[1]` (E19): Bit 1.
    - `Command[2]` (U19): Bit 2.
    - `Command[3]` (V19): Bit 3.
    - `Command[4]` (W18): Bit 4.
    - `Command[5]` (U15): Bit 5.
    - `Command[6]` (U14): Bit 6.
    - `Command[7]` (V14): Bit 7.
    - `Command[8]` (V13): Bit 8.
    - `Command[9]` (V3): Bit 9.
    - `Command[10]` (W3): Bit 10.
    - `Command[11]` (U3): Bit 11.
    - `Flags[0]` (L1): Zero flag (1 if ALU result is `0000`).
    - `Flags[1]` (P1): Overflow flag (1 if ALU overflow occurs).
    - `Flags[2]` (N3): Negative flag (1 if ALU result’s MSB is `1`).
  - **7-Segment Display (4 digits)**:
    - Digit 0 (leftmost, anode U2): Shows currently running Program Counter (0–7, hex).
    - Digit 1 (anode U4): Shows selected register number (0–7, hex).
    - Digit 2 (anode V4): Shows negative flag (`-` if selected register’s MSB is `1`, blank otherwise).
    - Digit 3 (rightmost, anode W4): Shows selected register’s value (0–F, hex).
    - Segments: `Data_seg[0]` (W7), `Data_seg[1]` (W6), `Data_seg[2]` (U8), `Data_seg[3]` (V8), `Data_seg[4]` (U5), `Data_seg[5]` (V5), `Data_seg[6]` (U7).
- **Setup**:
  1. Install Vivado 2018.1 and Basys 3 drivers.
  2. Create a new Vivado project, add all VHDL files, and set `Processor_4bit` as the top module.
  3. Add `Basys3Labs.xdc` as the constraints file.
  4. Synthesize, implement, and generate the bitstream.
  5. Connect the Basys 3 to your computer and program the FPGA.

### 2. Programming the Processor
- **Instruction Format**: 12-bit instructions (see Section 4 of Documentation).
- **Important Notes**:
  - The 12 `Data_write` switches (V17–R3) set the instruction to be written to Program RAM during programming. These may differ from the current instruction shown on the `Command` LEDs (U16–U3), which reflect the instruction being executed.
  - The first 7-segment digit (leftmost) shows the currently running PC address. The PC address for programming (where the instruction will be written) is not directly displayed and must be set using `Res` (U18) or `Step` (T17).
  - Keep the `Run` switch (R2) **off** during programming to prevent the PC from advancing and causing conflicts.
- **Steps**:
  1. Set the `Run` switch (R2) to `0` to disable continuous execution.
  2. Set the 12 `Data_write` switches (V17, V16, W16, W17, W15, V15, W14, W13, V2, T3, T2, R3) to the desired instruction (e.g., `100010001010` for MOVI R1, 10). Verify the switch settings visually.
  3. Set the Program Counter to the target address:
     - Press `Res` (U18) to reset PC to `000`.
     - Or press `Step` (T17) repeatedly to advance to the desired address (monitor the first 7-segment digit, U2).
  4. Press the `Upload` button (T18) to write the `Data_write` instruction to Program RAM at the current PC address.
  5. Repeat for each instruction (up to 8 addresses, 0–7).
- **Instruction Set Reference**:
  | Instruction | Binary Format         | Example                |
  |-------------|-----------------------|------------------------|
  | ADD         | 00 RRR BBB 0000       | `000010100000` (R1 ← R1 + R2) |
  | MOVI        | 10 RRR 000 dddd       | `100010001010` (R1 ← 10)      |
  | NEG         | 01 RRR 000 0000       | `010010000000` (R1 ← -R1)     |
  | JZ          | 11 RRR 000 0ddd       | `110000000011` (JZ 3)         |

### 3. Running a Program
- **Execution Modes**:
  - **Continuous**: Set `Run` switch (R2) to `1` to execute the program continuously (~3 Hz clock).
  - **Step-by-Step**: Press `Step` button (T17) to execute one instruction per press.
- **Monitoring Outputs**:
  - **7-Segment Display**:
    - **Digit 0 (leftmost, anode U2)**: Shows the currently running Program Counter (0–7, hex), indicating the address of the instruction being executed.
    - **Digit 1 (anode U4)**: Shows the register number (0–7, hex) selected by `RegSel` switches (W2, U1, T1).
    - **Digit 2 (anode V4)**: Shows the negative flag (`-` if the selected register’s MSB is `1`, blank otherwise).
    - **Digit 3 (rightmost, anode W4)**: Shows the selected register’s value (0–F, hex).
  - **LEDs**:
    - **Command LEDs (U16, E19, U19, V19, W18, U15, U14, V14, V13, V3, W3, U3)**: Show the 12-bit instruction currently being executed (1 = on, 0 = off). This may differ from the `Data_write` switch settings used for programming.
    - **Flag LEDs**:
      - Zero (L1): On if ALU result is `0000`.
      - Overflow (P1): On if ALU overflow occurs.
      - Negative (N3): On if ALU result’s MSB is `1`.
  - Set `RegSel` switches (W2, U1, T1) to select the register to display (000–111 for R0–R7).
- **Verification**:
  - Use the `Command` LEDs to verify the current instruction being executed.
  - Use the 7-segment display to verify the PC address (digit 0), register number (digit 1), and register value (digit 3).
  - Use the `Flags` LEDs to verify ALU status (Zero, Overflow, Negative).
- **Debugging**:
  - Use `Step` mode (T17) to observe instruction-by-instruction execution.
  - Check `Command` LEDs for the current instruction.
  - Monitor `Flags` LEDs for ALU status.
  - Reset with `Res` (U18), `ResRB` (W19), or `ResRAM` (U17) if needed.

### 4. Reprogramming the Processor
- **Important Notes**:
  - Ensure the `Run` switch (R2) is **off** to avoid PC advancement during programming.
  - Verify `Data_write` switch settings (V17–R3) before pressing `Upload` to ensure the correct instruction is written.
  - The PC address for programming is set via `Res` (U18) or `Step` (T17) and shown on the first 7-segment digit (U2).
- **Steps**:
  1. Press `ResRAM` button (U17) to reset Program RAM to the default program, if needed.
  2. Set `Run` switch (R2) to `0`.
  3. Set `Data_write` switches (V17–R3) to the desired instruction (e.g., `000010100000` for ADD R1, R2). Verify the switch settings.
  4. Set the PC to the target address:
     - Press `Res` (U18) to reset PC to `000`.
     - Or press `Step` (T17) to advance to the desired address (monitor digit 0 on the 7-segment display).
  5. Press `Upload` button (T18) to write the instruction.
  6. Repeat for additional instructions.
- **Example**: To change address 0 to `ADD R1, R2`:
  1. Set `Run` (R2) to `0`.
  2. Set `Data_write` switches to `000010100000`.
  3. Press `Res` (U18) to set PC to `000` (verify on digit 0, U2).
  4. Press `Upload` (T18).

### 5. Example Applications
- **Program 1: Add Two Numbers**
  - Goal: Add 5 and 3, store in R1.
  - Program:
    - Address 0: `100010000101` (MOVI R1, 5)
    - Address 1: `100100000011` (MOVI R2, 3)
    - Address 2: `000010100000` (ADD R1, R2)
  - Expected Output: R1 = `1000` (8), visible on 7-segment digit 3 (W4) when `RegSel = 001`. Verify instruction on `Command` LEDs.

- **Program 2: Loop Until Zero**
  - Goal: Decrement R1 until it reaches 0.
  - Program:
    - Address 0: `100010000101` (MOVI R1, 5)
    - Address 1: `100100000001` (MOVI R2, 1)
    - Address 2: `010100000000` (NEG R2)
    - Address 3: `000010100000` (ADD R1, R2)
    - Address 4: `110000000011` (JZ 3)
  - Expected Output: R1 decrements from 5 to 0, then jumps to address 3 repeatedly. Zero flag LED (L1) turns on when R1 = 0. Verify PC on digit 0 (U2) and instruction on `Command` LEDs.

### 6. FAQs and Troubleshooting
- **Q: LEDs show incorrect instruction.**
  - A: Press `ResRAM` (U17) to reset Program RAM. Verify `Data_write` switches (V17–R3) are set correctly during programming. Ensure `Run` (R2) is off when uploading.
- **Q: 7-segment display is blank.**
  - A: Ensure `RegSel` switches (W2, U1, T1) are set correctly (e.g., `001` for R1). Check clock signal (W5) and synthesis.
- **Q: First 7-segment digit shows wrong PC address.**
  - A: The first digit (U2) shows the currently running PC. To set the PC for programming, use `Res` (U18) or `Step` (T17). Ensure `Run` (R2) is off.
- **Q: Processor doesn’t execute.**
  - A: Verify `Run` (R2) or `Step` (T17) inputs. Ensure `Res` (U18), `ResRB` (W19), and `ResRAM` (U17) are not active.
- **Q: Synthesis errors in Vivado.**
  - A: Ensure all VHDL files are added and `Basys3Labs.xdc` is applied correctly. Use Vivado 2018.1.
- **Q: Negative flag digit shows incorrect symbol.**
  - A: Check the selected register’s MSB via `RegSel`. Digit 2 (V4) shows `-` only if MSB is `1`.
