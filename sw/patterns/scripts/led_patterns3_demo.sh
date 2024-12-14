#!/bin/bash
HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"

echo 1 > $HPS_LED_CONTROL

led_val=0x01
direction="right"

while true; do
    
    echo $led_val > $LED_REG
    sleep 0.1  # speed

    if [[ "$led_val" -eq 0x80 ]]; then
        direction="left"
    elif [[ "$led_val" -eq 0x01 ]]; then
        direction="right"
    fi

    if [[ "$direction" == "right" ]]; then
        led_val=$(( (led_val << 1) & 0xFF )) 
    else
        led_val=$(( (led_val >> 1) & 0xFF )) 
    fi
done
