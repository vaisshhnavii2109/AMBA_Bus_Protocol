# AMBA Bus Protocol Verification

This repository contains the **design and verification of AMBA Bus Protocols** 

– **APB (Advanced Peripheral Bus)** 
- **AHB (Advanced High-performance Bus)**. 

The implementation includes **Verilog, SystemVerilog (SV), and UVM testbenches**, along with simulation waveforms.


## **Project Overview**
### **What is AMBA?**
AMBA (**Advanced Microcontroller Bus Architecture**) is a standard developed by ARM for efficient communication in **System-on-Chip (SoC) designs**. 
It ensures seamless data transfer between processors, memory, and peripherals.

1. **APB (Advanced Peripheral Bus)**
   - Used for low-power peripherals like UART, GPIO, Timers.
   - Simple, **non-pipelined** transactions.
   - Verified using **Verilog, SV, and UVM**.

2. **AHB (Advanced High-performance Bus)**
   - Designed for **high-speed memory access**.
   - Supports **pipelined, burst-based transactions**.
   - Verified using **Verilog, SV, and UVM**.


## **Tools Used**
- **Cadence**: Used for **APB & AHB (SV, UVM) verification**.
- **ModelSim**: Used for **AHB (Verilog) simulation**.

## **Future Work**
- **AXI (Advanced eXtensible Interface)**: High-speed, multi-channel interconnects.
- **AHB to APB Bridge**: Verification of low-power and high-speed interfacing.
- **AXI to APB Bridge**: Ensuring seamless protocol translation.
