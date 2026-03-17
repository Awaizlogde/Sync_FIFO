# Synchronous FIFO in Verilog

This project implements a **parameterized synchronous FIFO** using Verilog HDL along with a testbench for verification.

The FIFO stores data in a **First In First Out (FIFO)** order and is commonly used for buffering between digital modules.


## Features
- Parameterized FIFO depth and width
- Full and Empty flag detection
- Simultaneous read and write support
- Complete Verilog testbench
- Waveform generation for verification

## FIFO Parameters

| Parameter|     Description          |
|----------|--------------------------|
| DEPTH    | Number of FIFO locations |
| WIDTH    | Data width               |

Default configuration:
DEPTH = 8
WIDTH = 8


---

## FIFO Interface

| Signal | Direction |  Description    |
|--------|-----------|-----------------|
| clk    |   input   |  System clock   |
| rst    |   input   |      Reset      |
| wr_en  |   input   |  Write enable   |
| rd_en  |   input   |  Read enable    |
|data_in |   input   |  Input data     |
|data_out|   output  |  Output data    |
| full   |   output  | FIFO full flag  |
| empty  |   output  | FIFO empty flag |


## FIFO Architecture

The FIFO consists of:
- Memory array
- Write pointer
- Read pointer
- Counter for tracking stored elements

Full condition:
count == DEPTH

Empty condition:
count == 0


## Expected Behavior
The testbench verifies:

- Reset behavior
- FIFO write operation
- FIFO read operation
- FIFO full condition
- FIFO empty condition
- Simultaneous read/write operation


## Applications

- UART buffers
- Data streaming systems
- Network interfaces
- DSP pipelines
- Processor pipelines


## Author

Awaiz Logde  
M.Tech Semiconductor Chip Design  


