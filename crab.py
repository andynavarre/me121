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
            time.sleep(0.1)
            led.value(1)  # Turn on the LED when starting to draw
            
        else:
            print(f"Point {i}: x = {x:.2f}, y = {y:.2f} is unreachable")
    led.value(0)  # Turn off the LED when finished drawing
    time.sleep(1)

num_points = 15  # Number of points to generate

# Link lengths
L1 = 7.8
L2 = 8.8

# Generate points on the line and actuate servos
points_1 = generate_line_points(5, -72, 14.2, 14.4, num_points)
actuate_servos(points_1)

points_2 = generate_line_points(-5, 72, 14.2, 14.4, num_points)
actuate_servos(points_2)

points_3 = generate_line_points(-0.5, 8.1, 13.2, 14.2, num_points)
actuate_servos(points_3)

points_4 = generate_line_points(0.5, -5.1, 12.2, 13.2, num_points)
actuate_servos(points_4)

points_5 = generate_line_points(5, -60, 12, 12.2, num_points)
actuate_servos(points_5)

points_6 = generate_line_points(-5, 60, 12, 12.2, num_points)
actuate_servos(points_6)

points_7 = generate_line_points(-0.5, 5.1, 12.2, 13.2, num_points)
actuate_servos(points_7)

points_8 = generate_line_points(0.5, -8.1, 13.2, 14.2, num_points)
actuate_servos(points_8)

points_9 = generate_line_points(-1, 13.7, 11.5, 12.7, num_points)
actuate_servos(points_9)

points_10 = generate_line_points(1, -13.7, 11.5, 12.7, num_points)
actuate_servos(points_10)

points_11 = generate_line_points(1, -14.2, 12, 13.2, num_points)
actuate_servos(points_11)

points_12 = generate_line_points(-1, 14.2, 12, 13.2, num_points)
actuate_servos(points_12)

points_13 = generate_line_points(0, -1.5, 13.7, 14.7, num_points)
actuate_servos(points_13)

points_14 = generate_line_points(-1, 12.2, 13.7, 14.2, num_points)
actuate_servos(points_14)

points_15 = generate_line_points(1, -16.2, 14.2, 14.7, num_points)
actuate_servos(points_15)

points_16 = generate_line_points(0, 1.5, 13.7, 14.7, num_points)
actuate_servos(points_16)

points_17 = generate_line_points(-1, 16.2, 14.2, 14.7, num_points)
actuate_servos(points_17)

points_18 = generate_line_points(1, -12.2, 13.7, 14.2, num_points)
actuate_servos(points_18)
