from servo import Servo
from machine import Pin
import time
import math

# Initialize LED on pin D4 and set it to ON
led = Pin(22, Pin.OUT)
led.value(1)  # Ensure LED starts ON

# Initialize servos
servo1 = Servo(0)  # Big arm
servo2 = Servo(2)  # Small arm with LED

# Function to move servos
def move_servo(servo, angle, delay=0.1):
    """
    Move a servo to a specific angle with a delay.
    :param servo: Servo object to move
    :param angle: Target angle
    :param delay: Time to wait after moving the servo
    """
    servo.write(angle)
    time.sleep(delay)

# Small petals pattern function (upper right corner)
def small_star_pattern(radius=8, points=50, link1=10.16, link2=10.16):
    """
    Create a small flower in the upper right corner.
    - Radius determines the size of the flower.
    - Points determines the number of "petals" on the star.
    - link1, link2: Lengths of the first and second arm links (in cm).
    """
    print("Starting the small flower pattern in the upper right corner...")
    
    # Calculate angles for the flower vertices
    step_angle = 2 * math.pi / points
    star_angles = [i * step_angle for i in range(points)]
    
    # Alternate between inner and outer radius for the petals and flower effect
    coordinates = []
    for i, angle in enumerate(star_angles):
        if i % 2 == 0:
            # Outer radius
            x = radius * math.cos(angle) + 7  # Shift star to the upper right
            y = radius * math.sin(angle) + 7  # Shift star to the upper right
        else:
            # Inner radius, scaled down
            x = (radius * 0.2) * math.cos(angle) + 7  # 60% of the outer radius
            y = (radius * 0.2) * math.sin(angle) + 7
        coordinates.append((x, y))

    # Start the timer
    start_time = time.time()
    
    # Draw the pattern
    for _ in range(2):  # Repeat the pattern twice
        for x, y in coordinates:
            # Calculate distance from origin
            distance = math.sqrt(x**2 + y**2)

            # Check if the point is within the arm's reach
            if distance < abs(link1 - link2) or distance > (link1 + link2):
                print(f"Skipping unreachable point at x={x}, y={y}")
                continue

            # Inverse kinematics calculations for servos
            angle1 = math.atan2(y, x) - math.acos((link1**2 + distance**2 - link2**2) / (2 * link1 * distance))
            angle2 = math.pi - math.acos((link1**2 + link2**2 - distance**2) / (2 * link1 * link2))

            # Convert radians to degrees and limit to -90 to 90 degrees
            servo1_angle = math.degrees(angle1)
            servo2_angle = math.degrees(angle2) - 90  # Adjust for second servo's orientation

            # Ensure angles are within the servo limits
            if servo1_angle < -90:
                servo1_angle = -90
            elif servo1_angle > 90:
                servo1_angle = 90

            if servo2_angle < -90:
                servo2_angle = -90
            elif servo2_angle > 90:
                servo2_angle = 90

            # Debugging output
            print(f"Point: ({x:.2f}, {y:.2f}), Servo1: {servo1_angle:.2f}, Servo2: {servo2_angle:.2f}")

            # Move servos
            move_servo(servo1, servo1_angle)
            move_servo(servo2, servo2_angle)

    # Stop the timer
    end_time = time.time()
    
    # Calculate the elapsed time
    elapsed_time = end_time - start_time
    print(f"Star pattern completed in {elapsed_time:.2f} seconds.")
    
    # Return arms to the starting position
    move_servo(servo1, 0)
    move_servo(servo2, 0)

# Run the pattern in the upper right corner
small_star_pattern(radius=8, points=50, link1=10.16, link2=10.16)
#Draw the stem of the flower
servo2.write(-90)
