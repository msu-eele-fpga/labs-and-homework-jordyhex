# Lab 2: Hardware Hello World

## Project Overview

> ## Functional Requirements

> ### Fixed Point
>
> A base rate is a reference rate (initial value). In this case, the base rate is 1 second because it is the base value for different LED tranistion rates.
>
> The base rate is a fixed point data type with a width (W = 8) and fixed point (F = 4). 
>
> ```vhdl
> base_rate : in std_ulogic_vector(7 downto 0); -- The value will be 00010000
> ```
>
> The base rate turns into 16 decimal with the additional zeros after the fixed point.
>
> There are 50,000,000 million clock cycles or periods per second because the system clock is 50 MHz.
>
> (base rate) x (clock cycles per second)
>

> ## System Architecture

```mermaid
    graph TB;
    A[fpga_clk1_50] -->|50 MHz Clock| top[Top Level Entity: denano_top];
    B[push_button_n];
    subgraph top [Top Level Entity: denano_top];
    a1
    end
```

A[Top Level Entity: de10nano_top] -->|50 MHz Clock| B[fpga_clk1_50];
    A -->|Push Button| C[push_button_n];
    A -->|Slide Switches| D[sw];
    A -->|LED Outputs| E[led];
    A -->|GPIO Expansion Headers| F[gpio_0 & gpio_1];
    A -->|Arduino Headers| G[arduino_io & arduino_reset_n];
    B --> H[Async Conditioner];
    C --> H;
    H --> I[Synced Signal];
    I --> J[LED Patterns];
    D --> J;
    E --> J;
    J -->|LED Outputs| E;
>
> ## Implementation Details

> ### User LED Pattern
> 
> The LED pattern in State 4 (users choice) has a rate of 1/16 the base rate and 1 light LED in a circular left shift pattern.
>
> 
## Deliverables

N/A

### Questions 

N/A