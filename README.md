# UART Transmitter & Receiver (RTL Design)

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

- FSM based RTL design
- LSB first transmission
- Configurable baud tick input
- Shift register based serializer
- Transmission complete indication


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


## Author

Ritika Malik
