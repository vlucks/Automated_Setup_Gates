# Python script | Appendix 2: Motor Control - motor_close.py
# modified after Joy-It_2017
# A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
# 2024

from time import sleep
import RPi.GPIO as GPIO
import os
import sys
GPIO.setmode(GPIO.BCM)

# used GPIOs
A=18
B=23
C=24
D=25


# define pins as output
GPIO.setup(A,GPIO.OUT)
GPIO.setup(B,GPIO.OUT)
GPIO.setup(C,GPIO.OUT)
GPIO.setup(D,GPIO.OUT)
GPIO.output(A, False)
GPIO.output(B, False)
GPIO.output(C, False)
GPIO.output(D, False)

time = 0.0009 # delay inbetween motor steps - defines gate speed

# define steps 
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

# run a full round in reverse order
for j in range (1, 256):
    Step8()
    Step7()
    Step6()
    Step5()
    Step4()
    Step3()
    Step2()
    Step1()

GPIO.cleanup()
