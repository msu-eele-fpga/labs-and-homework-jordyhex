# LED Pattern SW Controller

## Usage
```
Format: {command} [data]
```
### Commands

- `-h`: Open the help menu.
- `-p (pattern)`: Specify associated arguments `{pattern(s) (in hexadecimal)} {time}`.
- `-f (file)`: Specify a file name to open and read patterns and times from.
- `-v (verbose)`: Print LED patterns as binary strings and how long they are being displayed.

__Note:__ You cannot use `-f` and `-p` together.

### Pattern Mode `-p` 
```bash
./led_patterns -p 0x01 1000
```
This command displays the LED pattern `0x01` for 1000 milliseconds.

#### Using a File (`-f`)
```bash
./led_pattern -f patterns.txt
```
Where `patterns.txt` contains:
```
0xAA 1000
0x10 2000
0xF0 3000
0xf5 1000
0x56 2000
```

#### Verbose Mode (`-v`)
```bash
./led_pattern_controller -v -p 0x03 1500 
```
This command displays the LED patterns in binary format and the time each pattern is shown.

## Build

To compile the led-patterns.c file run the following:

`arm-linux-gnueabihf-gcc -o led_patterns -Wall -static led_patterns.c`