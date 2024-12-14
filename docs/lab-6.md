# Lab 6: Custom Hardware Component in Platform Designer
## EELE 467: SoC FPGAs
### Fall 2024
#### Taught by Professor Trevor Vannoy

## Fundamentals
This lab was difficult because I had to define a large number of terms. One definition led to the next and so on. So here are a few:

> #### Hard Processor System (HPS)
>A system including CPUs and peripherals that are implemented in silicon.
Compared to a soft processor system that is created using the FPGA fabric, on top of silicon.

 > #### Advanced Extensible Interface (AXI) Bridge 
 > On-chip communication bus protocol.

> #### Bus Protocols
>  A __bus__ is a system of communication pathways that connect components and devices together.
> A bus can be a set of wires or traces embedded in a PCB or chip, used to transfer data. A bus protocol is the set of rules that allow the bus to communicate data.
>
> NOTE: Common bus protocols are SPI, I2C, USB, Ethernet. UART and USART are _NOT_ bus protocols-they are serial commincation protocols.

> #### Universal Synchronous-Asynchronous Receiver and Transmitter (USART or UART)
> __UART__ or USART is a _serial communication protocol_. The reason it is not considered a bus protocol is because the transmitter and receiver are __CIRCUITS__. Not pathways.
> This caused me confusion due to the misinformation surrounding communication protocols on the web, but is probably more intiutive for someone on the PCB level. Not for the weak lol.

>  #### Joint Test Action Group (JTAG)
> __JTAG__ is a standard for boundary testing, debugging, and programming. It uses PCB interconnect to control IC pins using communication pathways. JTAG is pretty much these signals TDI TDO, TMS, and TCK. 

>  #### Interface
> An interface typically describes a connection point between two different components. In this context, an interface describes the enter and exit points of the bus.

---
## Deliverables
## System Architecture

> HPS logic and FPGA fabric are connected through 
> Advanced Extensible Interface (AXI) bridge.
 >
> Avalon Memory-Mapped Interface to read and write to 

## Register Map

![Block Diagram](assets/lab6_diagram.png)

## Platform Designer

> How did you connect these registers to the ARM CPUs in the HPS?

The registers are connected through Platform Designer. 

> What is the base address of your component in your Platform Designer system?

Platform Designer `led_patterns_avalon`: Base: 0x0000_0000 End: 0x0000_000f
