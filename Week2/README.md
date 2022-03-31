# Week 2 homework

## 1. Portenta H7 investigation

### 1.1 MCU

Main processor is dual core STM32H747. 

This processor is described as:
_High-performance and DSP with DP-FPU, Arm Cortex-M7 + Cortex-M4 MCU with 2MBytes of Flash memory, 1MB RAM, 480 MHz CPU, Art Accelerator, L1 cache_

Below are MCU (STM32H747XI) distinctive characteristics from datasheet:
* Dual core:
    * 32-bit Arm Cortex-M7 core with double precision FPU and L1 cache: 16 Kbytes of data and 16 Kbytes of instruction cache; frequency up to 480 MHz, MPU
    * 32-bit Arm 32-bit Cortex-M4 core with FPU, Adaptive real-time accelerator (ART Accelerator™) for internal Flash memory and external memories, frequency up to 240 MHz
* 2 Mbytes of Flash memory
* 1 Mbyte of RAM
* UFBGA or WLCSP package which makes it hard/impossible to probe pins that are not fanned out
* 1.62 to 3.6 V application supply and I/Os
* Up to 35 communication peripherals (will not be listing all here) but practically any imaginable is here I2C(s), USART, SPI, SPDIFRX, SWPMI, SD/SDIO/MMC, CAN, USB, Ethernet
* 3 16bit ADCs with max 32 channels (max 3.6 MSPS)
* 12 bit DAC (1 MHz)
* 2 opamps and 2 comparators
* Graphics
* 22 timers
* RTC with millisecond resolution


### 1.2 Board

Board itself has following (detailed listing is really long so I will mention just distinctive items):
* External flash and SDRAM
* USB-C (Host / Device, DisplayPort out, High / Full Speed, Power delivery)
* CAN, Ethernet, UART, SPI, I2S(C), MIPI, PWM, GPIO etc…
* ATECC608 Microchip Crypto chip with 16 key capacity
* Programmable PMIC with LiIon charger
* 2 board to board connectors on the bottom of the PCB
* Certification - web page lists EU, FCC and RoHs but no details are given, for EU probably self certificate is issued


### 1.3 Price and availability

At this moment stock for the MCU is practically non-existent and most respectable distributors are giving 40 weeks to 1 year lead time. Median price for this MCU is about €19. 
Development board are available from reputable distributors but in quantities less than 1k at the time of writing this document. Price for this board directly from Arduino is €89.90.
Median price from distributors is approximately €95. 


### 1.4 Application notes

Portenta web page lists interesting project done with this board:
[https://blog.arduino.cc/2022/01/19/diy-jet-engine-powered-by-a-portenta-h7/](https://blog.arduino.cc/2022/01/19/diy-jet-engine-powered-by-a-portenta-h7/)

STM web page lists numerous application notes but following I find most interesting:
* AN3126 Audio and waveform generation using the DAC in STM32 products - this app note describes how to generate audio waveforms with buffered output. 
* AN4989 STM32 microcontroller debug toolbox - showing details of debug ecosystems and how to compile debug code and how to step through the code. App note includes also printf debugging. 

---

## 2. Discovery kit with STM32F429ZI investigation

### 2.1 MCU

Board has STM32F429ZIT6 microcontroller with following characteristics:
* LQFP144 package
* 2 Mbytes of Flash memory
* 256 Kbytes of RAM
* Ethernet
* 14 Timers
* Peripherals: SPI, I2S, I2C, UART, USART, USB, CAN
* LCD-TFT
* 114 GIO
* 24 12bit ADC channels 2.4 MSPS
* 2 x 12it DAC 
* RTC
* Random number generator
* CRC calculation unit
* CPU freq up to 180MHz
* 3 boot modes (flash, memory, SRAM)
* Power supply 1.7 to 3.6 V

### 2.2 Board

Apart of the MCU the board is supplied with:
* 2.4" QVGA TFT LCD with touch screen
* I3G4250D, ST MEMS motion sensor 3-axis digital output gyroscope
* 6 leds
* 2 pushbuttons (user and reset)
* 64-Mbit SDRAM
* On-board ST-LINK/V2-B
* 2 external oscillators (main and RTC - 32KHz is not soldered as per datasheet)
* 2 extension headers for connecting to prototype boards 

### 2.3 Price and availability

It appears that the MCU is not readily available as expected. Lead time given from Mouser, Farnell and Digikey are more than 1 year. It appears that the price for the chip in 100s is approximately €20.
Development board is available from reputable distributors and it appears that there are at least 30 boards available with each distributor. Price of the board is approximately €29 in single quantities.

### 2.4 Application notes
There are several interesting application notes:
* AN4776 General-purpose timer cookbook for STM32 microcontrollers
* AN4861 LCD-TFT display controller (LTDC) on STM32 MCUs
* AN4759 Using the hardware real-time clock (RTC) and the tamper management unit (TAMP) with STM32 microcontrollers