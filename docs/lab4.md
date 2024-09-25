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
    graph TD;
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
    subgraph Components
        H[Async Conditioner]
        J[LED Patterns]
    end
```

```mermaid
graph TD;
    %% Top-level DE10-Nano block
    subgraph DE10_Nano_Top [de10nano_top]
        direction TB;
        
        %% External Inputs
        clk1_50[fpga_clk1_50] --> denano_top;
        push_button_n[Push Button Input] --> denano_top;
        sw[Slide Switches Input] --> denano_top;

        %% Async Conditioner block inside the DE10-Nano top
        subgraph Async_Conditioner [Async Conditioner]
            direction TB;
            Debouncer --> OnePulse;
            OnePulse --> Synchronizer;
        end

        %% Internal connections to Async Conditioner
        denano_top --> Async_Conditioner;
        Async_Conditioner --> SyncedSignal[Synced Signal];

        %% LED Patterns block inside the DE10-Nano top
        subgraph LED_Patterns [LED Patterns]
            SyncedSignal --> LED_Patterns;
            sw --> LED_Patterns;
        end

        %% LED output going outside DE10-Nano top
        LED_Patterns --> LED_Out[LED Output] --> denano_top --> led[External LED];
    end

```
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