# Python script | Appendix 6: Automated T-maze gates - motor1_open.py
# modified after Joy-It_2017
# A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
# 2024

from time import sleep
import RPi.GPIO as GPIO
import os
import sys

steps_i_ = open("/home/pi/steps_motor1.txt")   #read number of steps 
steps_i = steps_i_.read(3)
steps_i = int(steps_i)
GPIO.cleanup()
GPIO.setmode(GPIO.BCM)

state = open("/home/pi/state_motor1.txt") #read state
state = state.read(3)
state = int(state)


# used GPIOs
A=14
B=15
C=18
D=20

# define pins as outputs 
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


#run for the read number of steps if state is 1
i = 1 
while (state !=0) and (i <steps_i): 
    Step1()
    Step2()
    Step3()
    Step4()
    Step5()
    Step6()
    Step7()
    Step8()
    i = i+1


os.system("echo " + str(i) + " > /home/pi/steps_motor1.txt") #save steps
os.system("echo '0' > /home/pi/state_motor1.txt") #change state variable
GPIO.cleanup()
