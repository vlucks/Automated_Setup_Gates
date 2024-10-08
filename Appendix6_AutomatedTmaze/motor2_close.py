# Python script | Appendix 6: Automated T-maze gates - motor2_close.py
# modified after Joy-It_2017
# A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
# 2024

from time import sleep
import RPi.GPIO as GPIO
import os
import sys

steps_i_ = open("/home/pi/steps_motor2.txt")
steps_i = steps_i_.read(3)
steps_i = int(steps_i)
GPIO.cleanup()
GPIO.setmode(GPIO.BCM)

state = open("/home/pi/state_motor2.txt") #read state
state = state.read(3)
state = int(state)

#used GPIOs
A=2
B=3
C=4
D=17

# set gpios as ouput
GPIO.setup(A,GPIO.OUT)
GPIO.setup(B,GPIO.OUT)
GPIO.setup(C,GPIO.OUT)
GPIO.setup(D,GPIO.OUT)
GPIO.output(A, False)
GPIO.output(B, False)
GPIO.output(C, False)
GPIO.output(D, False)

time = 0.0009 #delay inbetween motor steps - defines gate speed
def Step1():
    GPIO.output(D, True)
    sleep (time)
    GPIO.output(D, False)

def Step2():
    GPIO.output(D, True)
    GPIO.output(C, True)
    sleep (time)
    GPIO.output(D, False)
    GPIO.output(C, False)

def Step3():
    GPIO.output(C, True)
    sleep (time)
    GPIO.output(C, False)
def Step4():
    GPIO.output(B, True)
    GPIO.output(C, True)
    sleep (time)
    GPIO.output(B, False)
    GPIO.output(C, False)

def Step5():
    GPIO.output(B, True)
    sleep (time)
    GPIO.output(B, False)

def Step6():
    GPIO.output(A, True)
    GPIO.output(B, True)
    sleep (time)
    GPIO.output(A, False)
    GPIO.output(B, False)

def Step7():
    GPIO.output(A, True)
    sleep (time)
    GPIO.output(A, False)

def Step8():
    GPIO.output(D, True)
    GPIO.output(A, True)
    sleep (time)
    GPIO.output(D, False)
    GPIO.output(A, False)



#run for the #steps the opening script made & if state is 0 
i = 1
while (i <steps_i) and (state !=1):
    Step8()
    Step7()
    Step6()
    Step5()
    Step4()
    Step3()
    Step2()
    Step1()
    i = i+1

os.system("echo '1' > /home/pi/state_motor2.txt")
GPIO.cleanup()
