# Week 7 homwork: Answer the interview questions

## I.3: What is an ISR?
ISR or interrupt service routine is a functionality of the microcontroller where a certain condition will make
the MCU stop executing the code it is executing and jump to the some other section of the code. This process is 
called the context switch and will take some time or processor cycles to be completed. This time needed to 
switch the context needs to be accounted for. Depending on the MCU there will be different implementation of the
interrupt routing both in hardware and in software. Generally, there will be a vector table wich holds the address
of the interrupt function to be executed after the interrupt was called. In software different MCU vendors
will have there own way of telling the compiler that this is particular ISR. Usually this is a prefix keyword 
to the ISR or there will be a function with the specific name.


## I.5: Why do we use the keyword volatile?
Volatile keyword tells to compiler not to optimize specific variable as it might be changed outside of the 
code that is currently being executed. For example if the specific variable will be changed in the ISR then
this variable will be declared as volatile. By declaring variable as volatile compiler knows that the variable
can change at any time. Volatile keyword is not limited to variables accessed by the interrupt routine only and
can be used in different setup.
