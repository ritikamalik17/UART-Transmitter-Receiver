# UART Transmitter & Receiver (RTL Design)
A synthesizable UART transmitter implemented in Verilog, verified via
simulation with Icarus Verilog. Supports 8N1 framing (8 data bits,
no parity, 1 stop bit) at a configurable baud rate.

## Overview

This project implements a UART communication system using Verilog HDL.

The design includes:

- UART Transmitter
- UART Receiver
- Baud Rate Generator
- 16x Oversampling
- Verification Testbench


## UART Frame Format
Idle | Start | Data Bits | Stop
1 | 0 | D0-D7 | 1


## UART Transmitter

The transmitter converts 8-bit parallel data into serial data.

### Features

- Configurable baud rate via parameterized clock divisor
- Standard 8N1 UART frame: 1 start bit, 8 data bits (LSB-first), 1 stop bit
- FSM-based transmitter design (IDLE → START → DATA → STOP)
- Fully simulated and verified with a self-checking testbench


## Architecture

- `baud_generator.v` — generates a single-cycle `tick` pulse at the
  target baud rate by dividing down the system clock
- `uart_tx.v` — FSM that shifts out a byte on `tx`, synchronized to `tick`
- `uart_tx_tb.v` — testbench with event-driven verification (background
  flag latches the `tx_done` pulse for a reliable pass/fail check)


## Transmitter FSM
    tx_start

       |
       v

    IDLE
       |
       v

    START
       |
       v

    DATA
       |
       v

    STOP
       |
       v

    IDLE

    

## Simulation

Testbench verifies:

- Reset operation
- Start bit generation
- Data transmission
- Stop bit generation
- tx_done signal


## Tools Used

- Verilog HDL
- Xilinx Vivado
- GTKWave / Vivado Simulator

## Results
Simulated transmission of byte `0xA5` at 9600 baud (50MHz system clock,
divisor = 5208). Waveform confirms correct start bit, LSB-first data bits,
and stop bit timing; `tx_done` pulses exactly once per frame.

<img width="1158" height="305" alt="image" src="https://github.com/user-attachments/assets/29c62272-9d97-41af-b221-6ad75eefa5b0" />



## Debugging notes
Found and fixed a level-sensitive vs. edge-sensitive bug during testbench
development: an early testbench toggled the tick signal manually, causing
it to stay high for two clock cycles instead of one. Since the FSM checks
`if(tick)` (level-sensitive), this caused bits to be processed twice per
intended tick. Fixed by ensuring `tick` is a proper single-cycle pulse
from the baud generator.

## Status
- [x] UART Transmitter (verified)
- [ ] UART Receiver
- [ ] TX/RX loopback test
- [ ] Top-level integration module

