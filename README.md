# AMBA Bus Protocol Verification

This repository contains the **design and verification of AMBA Bus Protocols** 
 1. **APB (Advanced Peripheral Bus)** 
 2. **AHB (Advanced High-performance Bus)**.
    
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


### **References**
- [ARM AMBA Specification](https://developer.arm.com/architectures/system-architectures/amba)
- [Cadence Verification Guide](https://community.cadence.com) 
- https://www.allaboutcircuits.com/technical-articles/introduction-to-the-advanced-microcontroller-bus-architecture/ 
- L. Deeksha and B. R. Shivakumar, "Effective Design and Implementation of AMBA AHB Bus Protocol using Verilog," 2019 International Conference on Intelligent Sustainable Systems (ICISS), Palladam, India, 2019, pp. 1-5, doi: 10.1109/ISS1.2019.8907975.
- E. Ravikumar, K. B. Ganesha, C. Y. Chethana and T. M. Parikshith Roy, "Design and Verification of Advanced Microcontroller Bus Architecture (AMBA) Advanced Peripheral Bus (APB) Protocol," 2024 International Conference on Smart Systems for applications in Electrical Sciences (ICSSES), Tumakuru, India, 2024, pp. 1-5, doi: 10.1109/ICSSES62373.2024.10561369.
