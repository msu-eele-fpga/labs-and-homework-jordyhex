#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>

#define HPS_LED_CONTROL_OFFSET 	0x00
#define BASE_PERIOD_OFFSET 	0x04
#define LED_REG_OFFSET 		0x08

#define BASE_RATE 		62500 // 62.5 ms 
#define NUM_LEDS		8

uint8_t circular_shift_left(uint8_t val, int num_bits) 
{
    return (val << num_bits) | (val >> (NUM_LEDS - num_bits));
}

int main(void) 
{
    FILE *file;
    size_t ret; 
    uint8_t val = 0x01;   

    file = fopen("/dev/led_patterns", "rb+");
    if (file == NULL) {
        printf("Failed to open /dev/led_patterns");
        exit(1);
    }

    uint8_t mode = 0x01; // Set software control mode
    fseek(file, HPS_LED_CONTROL_OFFSET, SEEK_SET);
    fwrite(&mode, sizeof(mode), 1, file);
    fflush(file);

    printf("Displaying custom LED pattern. Press Ctrl+C to exit.\n");

    while (1) 
    {
	    fseek(file, LED_REG_OFFSET, SEEK_SET);
	    fwrite(&val, sizeof(val), 1, file);
	    fflush(file);
	    
	    val = circular_shift_left(val, 1);
	    usleep(BASE_RATE); 
    }

    fclose(file);
    return 0;
}

