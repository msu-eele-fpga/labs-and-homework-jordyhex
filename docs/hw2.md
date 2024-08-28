# VHDL Refresher  

___Multiplexer___ 

> 2-to-1 multiplexer truth table:

|Sel|A|B|F|
|---|---|---|---|
|0|0|0|0|
|0|0|1|0|
|0|1|0|1|
|0|1|1|1|
|1|0|0|0|
|1|0|1|1|
|1|1|0|0|
|1|1|1|1|

___D-Flip-Flop___

```vhdl 
 D_FLIP_FLOP  : process (Clock)
    begin

        if (rising_edge(Clock)) then
                Q <= D;  
        end if;

    end process;  

```

> [!Note]
> A register is a circuit similar to a D-Flip-Flop but the I/O data are vectors. 
___Binary Number Systems__

-The range of an unsigned number => $0 \leq\ N \leq\ (2^n-1)$
-The range of signed numbers => $ -(2^(n-1)) \leq\ N \leq\ (2^(n-1)-1)$
    1. One's Complement
    2. Two's Complement

___Resources___

_Verilog__: [HDL Bits](https://hdlbits.01xz.net/wiki/Main_Page)

_Binary Number System_: 

![Table of the binary number system.](https://www.google.com/imgres?q=twos%20complement%20table&imgurl=https%3A%2F%2Farith-matic.com%2Fnotebook%2Fimg%2Fsubtraction%2Ftwos-complement-4bit.jpg&imgrefurl=https%3A%2F%2Farith-matic.com%2Fnotebook%2Fbinary-subtraction&docid=oe6H4nFRS00dEM&tbnid=KCivPQGBwphFDM&vet=12ahUKEwi4yrHt0ZiIAxW8CjQIHYGECBMQM3oECGcQAA..i&w=440&h=615&hcb=2&ved=2ahUKEwi4yrHt0ZiIAxW8CjQIHYGECBMQM3oECGcQAA)
