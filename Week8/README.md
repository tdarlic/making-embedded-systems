# Week 8 homwork: Resource constraints

## Printing resource constraints
Stack address was printed out using STM32 `__get_MSP()` function. I am not sure are we allowed to use this. 
I made use of the console library created in week 5 homework. New command was created `ConsoleCommandResourceConstraints()`:
```c
/**
 * This command was created for Week 8 exercise
 */
static eCommandResult_T ConsoleCommandResourceConstraints(const char buffer[]){
	static uint32_t staticVar = 2;
	uint32_t variableInFunction = 1;
	char strbuf[100];
	// empty the string buffer
	memset(strbuf, 0x00, 100);
    // on linux console color the output with \e[31m and \e[0m
    ConsoleIoSendString(STR_ENDLINE);
    // Print heap pointer address
    uint32_t * pHeap = malloc(1);
    *pHeap = 8;
    sprintf(strbuf, "Heap: value: %i, address: %p", (int) *pHeap, &pHeap);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

    // Print stack pointer address
    // Using __get_MSP() function from cmsis_armcc.h not sure am I suppose to use it
    uint32_t stack = __get_MSP();
    sprintf(strbuf, "Stack address: %x", stack);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

    // Print initialized global variable
    sprintf(strbuf, "Initialized global variable:value: %i, address: %p", (int) initGlobalVar, &initGlobalVar);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

    // Print uninitialized global variable
	memset(strbuf, 0x00, 100);
    sprintf(strbuf, "Unintialized global variable: value: %i, address: %p", (int) uninitGlobalVar, &uninitGlobalVar);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

    // Print static variable inside a function
	memset(strbuf, 0x00, 100);
    sprintf(strbuf, "Static variable inside a function: value: %i, address: %p", (int)  staticVar, &staticVar);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

    // Print variable inside a function
	memset(strbuf, 0x00, 100);
    sprintf(strbuf, "Variable inside a function: value: %i, address: %p", (int)  variableInFunction, &variableInFunction);
    ConsoleIoSendString(strbuf);
    ConsoleIoSendString(STR_ENDLINE);

	return COMMAND_SUCCESS;
}
```
### Printout from the console:
```
Heap: value: 8, address: 0x2002ff5c
Stack address: 2002ff50
Initialized global variable:value: 12, address: 0x20000000
Unintialized global variable: value: 0, address: 0x20000340
#Static variable inside a function: value: 2, address: 0x20000004
Variable inside a function: value: 1, address: 0x2002ffc4
```
### Excerpt from the MAP file:

