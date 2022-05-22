# Week 8 homwork: Resource constraints

## Printing resource constraints
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
Heap: value: 8, address: 0x20000638
Stack address: beginning: 0x2002fec0, end: 0x20030000
Initialized global variable:value: 12, address: 0x20000000
Unintialized global variable: value: 0, address: 0x200001d4
Static variable inside a function: value: 2, address: 0x20000004
Variable inside a function: value: 1, address: 0x2002febc
```

### Helper function used
Following definition of the global variable `_end` is defined in the linker script:
```
  /* User_heap_stack section, used to check that there is enough "RAM" Ram  type memory left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM
```
Following definition of the global variable `_estack` is defined in the linker script:
```
  /* Highest address of the user mode stack */
  _estack = ORIGIN(RAM) + LENGTH(RAM); /* end of "RAM" Ram type memory */
```
Function `__get_MSP()` is defined in `cmsis_armcc.c`:
```c
/**
  \brief   Get Main Stack Pointer
  \details Returns the current value of the Main Stack Pointer (MSP).
  \return               MSP Register value
 */
__STATIC_INLINE uint32_t __get_MSP(void)
{
  register uint32_t __regMainStackPointer     __ASM("msp");
  return(__regMainStackPointer);
}
```

### Excerpt from the MAP file:
```

Memory Configuration

Name             Origin             Length             Attributes
CCMRAM           0x0000000010000000 0x0000000000010000 xrw
RAM              0x0000000020000000 0x0000000000030000 xrw
FLASH            0x0000000008000000 0x0000000000200000 xr
*default*        0x0000000000000000 0xffffffffffffffff

.........

                0x0000000020030000                _estack = (ORIGIN (RAM) + LENGTH (RAM))
                0x0000000000000200                _Min_Heap_Size = 0x200
                0x0000000000000400                _Min_Stack_Size = 0x400

.........

.data           0x0000000020000000      0x21c load address 0x000000000800aadc
                0x0000000020000000                . = ALIGN (0x4)
                0x0000000020000000                _sdata = .
 *(.data)
 *(.data*)
 .data.initGlobalVar
                0x0000000020000000        0x4 ./Core/Src/consoleCommands.o
                0x0000000020000000                initGlobalVar
 .data.staticVar.0
                0x0000000020000004        0x4 ./Core/Src/consoleCommands.o

.........

 .bss           0x00000000200000b0      0x3d0
                0x00000000200000b0                _sbss = .
                0x00000000200000b0                __bss_start__ = _sbss
 *(.bss)

.........
 .bss.uninitGlobalVar
                0x00000000200001d4        0x4 ./Core/Src/consoleCommands.o
                0x00000000200001d4                uninitGlobalVar


```
### Analysis of the variable places in map file
- [x] Heap address is on the expected place at the end of the RAM
- [x] Stack is at the end of the RAM and it grows "backwards" towards lower address space
- [x] Initialized global variable is at the beginning of the .data section address 0x20000000
- [x] Uninitialized global variable is placed on the stack address 0x200001d4 at .bss section
- [x] Static varible inside a function is placed on the stack  0x20000004 
- [ ] Normal variable inside a function was not located in the map file but it was located on the stack on address 0x2002febc


## Swap initialized and uninitialized variables in the linker file
Below is the printout after replacing .bss and .data sections in the `STM32F429ZITX_FLASH.ld` file.
For some reason there are two linker files but the one that is compiled is one ending with `_flash.ld`
```
Heap: value: 8, address: 0x20000638
Stack address: beginning: 0x2002fec0, end: 0x20030000
Initialized global variable:value: 12, address: 0x200003d0
Unintialized global variable: value: 0, address: 0x20000124
Static variable inside a function: value: 2, address: 0x200003d4
Variable inside a function: value: 1, address: 0x2002febc
```
After changing the linker file it is obvious that 
- Initialized global variable has moved: 0x20000000 --> 0x200003d0
- Uninitialized global variable has moved: 0x200001d4 --> 0x20000124
- Static varible inside the function has moved: 0x20000004 --> 0x200003d4

## Printing all variables from map file starting with double underscores "dunders"
Following command was used to print out all double underscore variables:
`cat mes-resource-constraints.map| grep \ __` 

Output:
```
                0x0000000008000290                __aeabi_uldivmod
                0x00000000080002c0                __udivmoddi4
                0x0000000008000590                __aeabi_ldiv0
                0x0000000008000590                __aeabi_idiv0
                0x0000000008003b2c                __errno
                0x0000000008003b38                __libc_init_array
                0x0000000008004094                __sflush_r
                0x000000000800426c                __sfmoreglue
                0x0000000008004298                __sfp_lock_acquire
                0x00000000080042a4                __sfp_lock_release
                0x00000000080042b0                __sinit_lock_acquire
                0x00000000080042bc                __sinit_lock_release
                0x00000000080042c8                __sinit
                0x0000000008004338                __sfp
                0x0000000008004402                __retarget_lock_init_recursive
                0x0000000008004404                __retarget_lock_acquire_recursive
                0x0000000008004406                __retarget_lock_release_recursive
                0x0000000008004408                __swhatbuf_r
                0x0000000008004454                __smakebuf_r
                0x00000000080044d4                __malloc_lock
                0x00000000080044e0                __malloc_unlock
                0x00000000080044ec                __ssputs_r
                0x00000000080047d2                __sfputs_r
                0x0000000008004d80                __sread
                0x0000000008004da2                __swrite
                0x0000000008004dda                __sseek
                0x0000000008004dfe                __sclose
                0x0000000008004e08                __swbuf_r
                0x0000000008004ed0                __swsetup_r
                0x0000000008005720                __sf_fake_stderr
                0x0000000008005740                __sf_fake_stdin
                0x0000000008005760                __sf_fake_stdout
                0x00000000080057b4                __exidx_start = .
                0x00000000080057bc                __exidx_end = .
                0x0000000020000000                __bss_start__ = _sbss
                0x00000000200003c0                __malloc_free_list
                0x00000000200003c4                __malloc_sbrk_start
                0x00000000200003c8                __lock___malloc_recursive_mutex
                0x00000000200003c9                __lock___sfp_recursive_mutex
                0x00000000200003ca                __lock___sinit_recursive_mutex
                0x00000000200003d0                __bss_end__ = _ebss
```
First part of the output describes the FLASH functions addresses but last 7 define addresses in RAM: beginning and end of .bss section
