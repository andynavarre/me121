# me121

ME 121 Advanced Dynamics Spring 2025

Project 1: Create a 2 DOF robotic arm and make a light show with an LED

flower.py draws a daisy flower

Project 2: Using the same robotic arm, apply inverse kinematics to draw the letter M and an animal

letter_M.py draws the letter M

crab.py draws a crab

2DSimulator_Inverse_Kinematics.vi draws the animal using Labview on a 2D simulator

3DSim.vi generates an n-degree of freedom arm based on the user inputs of rotation and translation on a 3D display

Simulation_Reality.vi communicates through serial with the robotic arm and reads a gcode file, which is translated into angle commands to the arm. 

InverseKinematics.vi is a SubVi in Simulation_Reality.vi

Constant_Speed.vi uses two PWM-controlled servomotors to draw a straight line employing Jacobians

Torques_Calc.vi plots the torque required for each motor to keep the EOF at each location of the GCode reader. Then it plots a histogram of required torques for the full drawing\

MidtermSubmission.zip includes the VI uses for the midterm to move a 3DOF robot while keeping the EOF always vertical

