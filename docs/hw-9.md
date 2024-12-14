# Homework 9: Pulse Width Modulated Signal (PWM) Controller

## Focuses
- Keeping attributes that aren't input or output out of the port declarations and keeping them as generics.
- Adhering to the VHDL style guide.

---

The period is assigned in ms. W is the size of the signal and F is the number of fractional bits.

W.F
W or N = Width or Weight (number of bits in the entire number), F = Fractional Bits
I = Integer Bits

#### PERIOD
W = 18, I = 6, F = 12

It looks like this : 000000.000000000000

#### DUTY CYCLE
W = 11, I = 1, F = 10

This duty cycle allows for a range from 0 to 1.9990

#### MULTIPLICATION

W_i + W_i+1 = total width

#### DIVISION
W_numerator + F_denominator