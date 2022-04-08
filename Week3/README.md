# Week 3 homework: Make Blinky

## 1. Make blinky

Blinky is made with STM32 CubeIDE 1.9. The STM32 429 Disco board is selected in the board selector and code generator is allowed to generate the code for the board

Following setup was used to make a Blinky:
* PC with Linux Mint 20.3 Cinnamon edition
* STM32 CubeIDE 1.9 and default drivers

STM32 Cube IDE code generator was used to create all code and minimum user code was then typed to have a working example.
STM32 code generator generates all pin and port name aliases in `main.h` and following aliases were used for green LED
```c
#define LD3_Pin GPIO_PIN_13
#define LD3_GPIO_Port GPIOG
```

Green LED is connected to the PG13 which is pin number 128 on the MCU. 

Once we know that it is pretty easy to get the LED blink by just appying the HAL code directly:
```c
  while (1)
  {
	  HAL_GPIO_TogglePin(LD3_GPIO_Port, LD3_Pin);
	  HAL_Delay(500);
  }
```

The dev board is then connected to the USB port via cable and can be flashed directly from the IDE.
In the example above the green LED is toggling every 500ms.

## 2. Button interrupt 
As the Disco board has one more LED I will use that one for button interrupt.
User button on Disco board is connected to the PA0 port which is pin number 34 on MCU. 

In order to have the interrupt working we first need to setup the NVIC to interrupt on that particular pin. 
This was acomplished also trough the STM32 CubeIDE code configurator. 
Pin name in the code configurator is PA0/WKUP and is setup as below:
* GPIO mode: External interrupt Mode with Rising edge trigger detection
* Pull up and Pull down disabled
* Next in the NVIC part of the GPIO setup the EXTI line0 external interrupt was enabled.
* Finally, in the NVIC setup Generate IRQ handler and Call HAL handler were enabled
PA0 port has following aliases in _main.h_:
```c
#define B1_Pin GPIO_PIN_0
#define B1_GPIO_Port GPIOA
```
To have the interrupt working we need to have a callback implemented. This callback starts is setup by HAL in `stm32f4xx_hal_gpio.h` which defines following IRQ handler:
```c
/**
  * @brief  This function handles EXTI interrupt request.
  * @param  GPIO_Pin Specifies the pins connected EXTI line
  * @retval None
  */
void HAL_GPIO_EXTI_IRQHandler(uint16_t GPIO_Pin)
{
  /* EXTI line interrupt detected */
  if(__HAL_GPIO_EXTI_GET_IT(GPIO_Pin) != RESET)
  {
    __HAL_GPIO_EXTI_CLEAR_IT(GPIO_Pin);
    HAL_GPIO_EXTI_Callback(GPIO_Pin);
  }
}
```
So this function is called on GPIO interrupt and it checks is particual GPIO IRQ set and if it is then calls `HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)` function defined in same file.
This function is defined with `__weak` attribute so we can define our normal function under the same name so that function will be linked instead into the same compile unit.
`HAL_GPIO_EXTI_Callback(int16_t GPIO_Pin)` function is defined in `stm32f4xx_it.c` which finally contains code for the interrupt:
```c
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin){
	if (GPIO_Pin == B1_Pin){
        HAL_GPIO_TogglePin(LD4_GPIO_Port, LD4_Pin);
	}
}
```
It appears that button on my dev board is designed rather well as it extremely rarely causes glithces undebounced. Probably because it is debounced on the board itself by C11 100nF capacitor. 

## 3. Button debounce
For the button debouncing I will use most primitive interrupt metod. Logic goes like this:
1. Interrupt on button GPIO transition
2. Check what was the last time this interrupt was called
3. If sufficient time has elapsed since the last button interrupt then triger new button toggle in code
4. Exit the interrupt and resume normal code execution

To acomplish this following was added to the `HAL_GPIO_EXTI_Callback` function:
1. Global variable `delayTime` which was set to 100, this is our setting in ms for debounce (usually 50ms in unnoticable)
2. Local static variable `lastButtonTime` which is used to remember last time interupt was triggered

Finally the debounce interrupt looks like this:
```c
volatile uint16_t delayTime= 100;
//.....
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin){
	static uint32_t lastButtonTime = 0;

	if (GPIO_Pin == B1_Pin){
		if ((HAL_GetTick() - lastButtonTime) > delayTime){
			HAL_GPIO_TogglePin(LD4_GPIO_Port, LD4_Pin);
			lastButtonTime = HAL_GetTick();
		}
	}
}
```

This debounce method is primitive and in undebounced button can couse MCU to interupt multuple times this makinf the code call IRQ unnecessary. 
There are several methods that could be used here to improve on the code. One is to disable this particular interrupt in the interrupt itself and start a timer who's interrupt will in turn switch back original interrupt on after it expires. 

## 4. Stepping trough the code!
Stepping trough the code can be done live using debugger or with `Ctrl`+`Click` on the function names. I'll give just the short explanation here. 
1. The code is setup in startup code in file `startup_stm32f429zitx.s`. This all happens before our code takes over
2. After taking over from startup function `main()` in `main.c` takes over and then following functions are run
    - Initializes all interrupts, system tick, NVIC and also the flash interface with `HAL_Init()` 
    - Configues the system clock with `SystemClock_Config()`
    - Initializes all peripherals with `MX_GPIO_Init()`
    - All 3 of above functions can be found in `stm32f4xx_hal.c`. These functions in turn then call individual periperal code. For example RCC setup is done from `stm32f4xx_hal_rcc`
3. All of the files above then call CMSIS Cortex-M1 Core Peripheral Access Layer Header File in Drivers/CMSIS folder and these files will address the particular peripherals registers individually
4. Finally, the direct registers addresses and mapping is located in ST/STM32F4xx directory in `stm32f4xx.h`  and `stm32f429xx.h` files

## 5. Further investigation
### What are the hardware registers that cause the LED to turn on and off? (From the processor manual, don’t worry about initialization.)

This is short description of registers involved in setting up the green LED

As described above below is description of green LED addresses from `main.h`:
```c
#define LD3_Pin GPIO_PIN_13
#define LD3_GPIO_Port GPIOG
```
Following register are involved in turining the LED on and off:
GPIO port used in this case is `GPIOG` and the address is defined in line 1254 in `stm32f429xx.h` file
```c
#define GPIOG ((GPIO_TypeDef *) GPIOG_BASE)
```

Individual pin address is described in higher level file `stm32f4xx_hal_gpio.h` on line 98:
```c
#define GPIO_PIN_13 ((uint16_t)0x2000)
```
Following registers are avilable for GPIO setup:
* GPIO port mode register (GPIOx_MODER)
* GPIO port output type register (GPIOx_OTYPER) (push-pull or open drain)
* GPIO port pull-up/pull-down register

The register which causes the LED to be switched on or off is GPIO port output data register `(GPIOG_ODR)`.
Pin 13 in this registers controls the our Green LED pin

### What are the registers that you read in order to find out the state of the button?
Button is defined as below
```c
#define B1_Pin GPIO_PIN_0
#define B1_GPIO_Port GPIOA
```
So in order to find out the state of the button we can read the register GPIO port A input data register `(GPIOA_IDR)`

### Can you read the register directly and see the button change in a debugger or by printing out the value of the memory at the register’s address?
This can easily be done in debugger. We can stop the executoion at any time and then read the contents of the memory at `(GPIOA_IDR)`
![Debug screen showing input data registers](/Week3/images/debug_screen.png)
