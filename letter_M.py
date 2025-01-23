import math
import machine
from machine import Pin
import servo
import time

# Initialize servos
servo0 = servo.Servo(0)  # Servo 0 (theta1)
servo1 = servo.Servo(2)  # Servo 1 (theta2)

# Initialize LED
led = Pin(22, Pin.OUT)
led.value(0)

# Function to generate line points
def generate_line_points(slope, intercept, x_start, x_end, num_points):
    """
    Generate a set of points on a line defined by y = slope * x + intercept.
    """
    x_values = [x_start + (x_end - x_start) * i / (num_points - 1) for i in range(num_points)]
    y_values = [slope * x + intercept for x in x_values]
    return list(zip(x_values, y_values))

# Function to compute inverse kinematics
def inverse_kinematics(x, y, L1, L2):
    """
    Compute the inverse kinematics for a 2DOF robotic arm.
    """
    # Check reachability
    if math.sqrt(x**2 + y**2) > (L1 + L2):
        return None, None  # Target is unreachable

    # Compute theta2
    cos_theta2 = (x**2 + y**2 - L1**2 - L2**2) / (2 * L1 * L2)
    theta2 = math.acos(cos_theta2)

    # Compute theta1
    phi = math.atan2(y, x)
    psi = math.atan2(L2 * math.sin(theta2), L1 + L2 * math.cos(theta2))
    theta1 = phi - psi

    return math.degrees(theta1), math.degrees(theta2)

# Actuate servos for each point
def actuate_servos(points):
    led.value(0)
    time.sleep(1)
    for i, (x, y) in enumerate(points, 1):
        theta1, theta2 = inverse_kinematics(x, y, L1, L2)
        if theta1 is not None:
            print(f"Point {i}: x = {x:.2f}, y = {y:.2f}, θ1 = {theta1:.2f}°, θ2 = {theta2:.2f}°")
        
            # Move the servos to the calculated angles
            servo0.write(theta1)
            servo1.write(theta2)
            time.sleep(0.2)
            led.value(1)  # Turn on the LED when starting to draw
            
        else:
            print(f"Point {i}: x = {x:.2f}, y = {y:.2f} is unreachable")
    led.value(0)  # Turn off the LED when finished drawing
    time.sleep(1)

# Line parameters
slope_1 = -0.75278
intercept_1 = 17.78
x_start_1 = 0
x_end_1 = 17.086
num_points = 25  # Number of points to generate

# Link lengths
L1 = 8.255
L2 = 9.525

# Generate points on the line and actuate servos
points_1 = generate_line_points(slope_1, intercept_1, x_start_1, x_end_1, num_points)
actuate_servos(points_1)

slope_2 = 1.02054
intercept_2 = -12.85885
x_start_2 = 12.60
x_end_2 = 17.086

points_2 = generate_line_points(slope_2, intercept_2, x_start_2, x_end_2, num_points)
actuate_servos(points_2)
