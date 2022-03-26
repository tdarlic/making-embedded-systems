# Week 1 homework
## Navigation buoy light monitor 

This device would be mounted on a navigation light buoy and would monitor position and movement on the buoy and could probably calculate the state of the sea from the movement of the buoy. It would also have an non-invasive measurement of the characteristics of the light of the buoy and some other parameters on systems that those buoys usually have and are often available trough CAN or maybe RS485.There would be alarms set off in case of impact, detachment from mooring position (GPS), change in characteristics of the light, heavy list of the buoy, or maybe presence of the large object in vicinity of the buoy.
The buoys usually have a solar power and batteries so the device would have an DC-DC converter and the power monitoring for the complete buoy. A radio modem (NBIoT, LoRA, GSM or similar) would provide updates to the server monitoring multiple buoys.

### Hardware Block Diagram
![Hardware block diagram](/Week1/images/Hardware_block_diagram.drawio.png)

### Hierarchy of control diagram
![Hierarchy of control diagram](/Week1/images/Hierarchy_of_control_diagram.png)

### Layered software diagram
![Layered software diagram](/Week1/images/Layered_software_diagram.png)
