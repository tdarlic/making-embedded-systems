# Week 4 homework: Final project plan and state machine

## Fist idea: Digital sextant

The original device I intended to make on this device was a digital sextant but not sure can I pull that off 
in a limited time that I have. Digital sextant would use the RTC and external battery. It's time would be 
synchronized with the internet clock and the user would then point the PCB to known navigation star and 
press the button, this would create single LOP (line of position). By creating several line of positions
the device would then calculate position of the user. 
The height of the star (angle in the eye of the observer from horizont to the star) would be calculated 
with the accelerometer. This is not ideal but good enough for demostration purposes. I presume that I could
get within 1° of angle accuracy which is about 60 nautical miles for single LOP. 
The tricky part here is to load the ephemeris data into the device and make sure it is calculating correctly. 

## Second idea: Digital barometer and storm warning
The other idea I have is to create a digital barometer using LPS28DFWTR Dual full-scale absolute barometer 
Details of the barometer can be found on following link:
[LPS28DFW](https://www.st.com/en/mems-and-sensors/lps28dfw.html)

I've ordered several barometers and plan to make a PCB which would plug into the development board and provide
some power and connection to barometer. I would use the screen for intitial setup and tracking. The device would
sleep most of the time and would wake up every few minutes, take a reading of the barometer and then go back to sleep.
In case that the storm is approaching the device would then flash a warning light every dozen seconds.
Device should also display value and basic data when picked up and also would show graph when device is tilted
on a side. 


## State machine table for the digital barometer
| States           | Action           | Events  |                  |                  |                 |                  |                 | 
|------------------|------------------|---------|------------------|------------------|-----------------|------------------|-----------------|
|                  |                  | Timer   | Move             | Tilt-Portrait    | Tilt-Landscpe   | Button           | Warning         | 
| ON               | initialize       | x       | x                | x                | x               | x                | x               | 
| SLEEP            | sleep            | MEASURE | DISPLAY_PRESSURE | DISPLAY_PRESSURE | DISPLAY_TREND   | DISPLAY_PRESSURE | DISPLAY_WARNING | 
| MEASURE          | measure          | ERROR   | DISPLAY_PRESSURE | DISPLAY_PRESSURE | DISPLAY_TREND   | DISPLAY_PRESSURE | DISPLAY_WARNING | 
| DISPLAY_PRESSURE | display_pressure | MEASURE | DISPLAY_PRESSURE | DISPLAY_PRESSURE | DISPLAY_TREND   | DISPLAY_PRESSURE | DISPLAY_WARNING | 
| DISPLAY_TREND    | display_trend    | MEASURE | DISPLAY_TREND    | DISPLAY_PRESSURE | DISPLAY_TREND   | DISPLAY_TREND    | DISPLAY_WARNING | 
| DISPLAY_WARNING  | display_warning  | MEASURE | DISPLAY_WARNING  | DISPLAY_WARNING  | DISPLAY_WARNING | DISPLAY_WARNING  | DISPLAY_WARNING | 
| ERROR            | reset            | ON      | x                | x                | x               | x                | x               | 

### Description of the states
- ON               - Initial state, all variables are reset and device started
- SLEEP            - State in which device loops with screen off waiting for the timer or movement/input
- MEASURE          - Measuring, this can be done in the background with ADC trough the timer
- DISPLAY_PRESSURE - Standard display pressure mode in which the device is displaying pressure in portrait mode
- DISPLAY_TREND    - Display pressure trend (graph) in last 6 hours in portait mode
- DISPLAY_WARNING  - Warning: pressure trend has shown that the storm might be approacing
- ERROR            - Some of the parameters of pressures is out of bounds, reset the device
