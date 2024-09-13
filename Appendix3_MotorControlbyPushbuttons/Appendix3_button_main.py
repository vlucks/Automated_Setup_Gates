# main.py Python3 script | Appendix 3: Motor control by push buttons
# A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
# 2024

import RPi.GPIO as GPIO
import os

# Define a callback function that is triggered by GPIO input
def open(channel):
        if channel == 16:
                os.system("python3 /home/pi/motor_open.py")

def close(channel):
        if channel == 20:
                os.system("python3 /home/pi/motor_close.py")

# Setup GPIO16 as button-input for opening and GPIO20 for closing:
GPIO.setmode(GPIO.BCM)
GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(20, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Register an GPIO events and execute accroding callback function
# bouncetime ignores events for 10000ms after input to avoid double-triggers
GPIO.add_event_detect(16, GPIO.RISING, callback=open, bouncetime=10000)
GPIO.add_event_detect(20, GPIO.RISING, callback=close, bouncetime=10000)

while True: 
        a=1


