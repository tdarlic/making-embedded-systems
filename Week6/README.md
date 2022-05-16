# Week 6 homework: Final Project Rough Draft

## 1. Application description
The project is digital barometer with algorithm that predicts the oncoming storms. Device sleeps with the screen off until one of the two things happen:
1. Device is picked up and hadled
2. Storm is detected
Accelerometer and gyro will assist in detectin that the dvice was picked up and would also detect the orientation of the device. 
In case of storm the device would periodically light up a screen and would diplay a short warning about the oncoming storm.
The algorithm for detecting of storms would read the trend of the atmspheric pressure during last 6 or 12 hours and would interpret the results
## 2. Hardware description
Device is assembled out of DISCO-F429ZI development board and the small "shield" attached to it. The sheild is carrying the accelerometer and the barometer.
Following sensors are used in addition to the gyro already supplied by the board:
- [LPS28DFW](https://www.st.com/en/mems-and-sensors/lps28dfw.html#documentation)
- [MMA8653FC](https://www.nxp.com/products/sensors/accelerometers/2g-4g-8g-low-g-10-bit-digital-accelerometer:MMA8653FC)
#### Hardware block diagram
![Hardware block diagram](/Week6/hardware_block_diagram.png)
## 3. Software description
## 4. Describe the code in general
- Describe the parts you wrote in some detail (maybe 3-5 sentences per module)
- Describe code you re-used from other sources, including the licenses for those
## 5. Diagram(s) of the architecture
## 6. Build instructions
### 6.1 How to build the system (including the toolchain(s))
#### Hardware
#### Software
### 6.2 How you debugged and tested the system
## 7. Future
- What would be needed to get this project ready for production?
- How would you extend this project to do something more? Are there other features you’d like?
- How would you go about adding them?
## 8. Grading
- Self assessment of the project: for each criteria, choose a score (1, 2, 3) and explain your reason for the score in 1-2 sentences.
- Have you gone beyond the base requirements? How so?
