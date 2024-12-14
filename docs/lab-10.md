# Lab 10: Device Trees - _Creating a Heartbeat LED on the DE10-Nano_

## Overview
This lab focuses on understanding and using device trees to describe hardware in an embedded Linux system. 
It explores how device trees enable the operating system to understand the hardware configuration, eliminating the need for hardcoding. 
The lab involves creating and modifying device tree files for the DE10-Nano board, enabling LED functionality via device tree configurations and kernel settings.

This lab involved enabling and configuring a heartbeat LED. The process included modifying the kernel configuration, updating the device tree to define the LED, and compiling both the kernel and device tree to reflect the changes. 

---

## Deliverables

### Demonstrations
1. **Turning the LED On/Off and Setting Trigger Sources**  
   Successfully toggled the LED brightness using `sysfs` and set various trigger sources like `heartbeat` and `timer`.

2. **Heartbeat LED Functionality on Boot**  
   Verified that the heartbeat LED blinks on boot with the system load-dependent pulse rate.

3. **Updated `sysfs` Directory Name**  
   Confirmed that the LED's `sysfs` directory is named `green:heartbeat` as specified in the device tree.

---

## Questions

> **What is the purpose of a device tree?**

The device tree describes the hardware components of an embedded system to the operating system. It abstracts hardware details such as memory addresses, registers, and bus configurations, allowing the kernel to manage hardware without hardcoding specifics. This improves flexibility and portability.

---
## Notes
- The kernel was configured using `menuconfig` to enable the heartbeat trigger.
- Adding more to this later.

