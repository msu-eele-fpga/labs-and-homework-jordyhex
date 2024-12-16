# Lab 8: LED Patterns Software Controller
## Overview
This lab focuses on implementing a software controller for LED patterns on the DE10-Nano.

To read about program usage click [here](../sw/led-patterns/README.md).

## Deliverables

The physical address for the LED control register was determined based on the order of registers specified in Quartus.

Since the LED control register is the third in sequence, its physical address was calculated by adding `4(N-1)` to the base address `0xFF200000`.