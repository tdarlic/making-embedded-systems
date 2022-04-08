# Week 3 homework: Make Blinky

## 1. Make blinky

Blinky is made with STM32 CubeIDE 1.9. The STM32 429 Disco board is selected in the board selector and code generator is allowed to generate the code for the board

Following setup was used to make a Blinky:
* PC with Linux Mint 20.3 Cinnamon edition
* STM32 CubeIDE 1.9 and default drivers

STM32 Cube IDE code generator was used to create all code and minimum user code was then typed to have a working example.
STM32 code generator generates all pin and port name aliases in _main.h_ and following aliases were used for green LED
```
#define LD3_Pin GPIO_PIN_13
#define LD3_GPIO_Port GPIOG
```

Green LED is connected to the PG13 which is pin number 128 on the MCU. 

Once we know that it is pretty easy to get the LED blink by just appying the HAL code directly:
```
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
```
#define B1_Pin GPIO_PIN_0
#define B1_GPIO_Port GPIOA
```
To have the interrupt working we need to have a callback implemented. This callback starts is setup by HAL in *stm32f4xx_hal_gpio.h* which defines following IRQ handler:
```
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
So this function is called on GPIO interrupt and it checks is particual GPIO IRQ set and if it is then calls *HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)* function defined in same file.
This function is defined with *__weak* attribute so we can define our normal function under the same name so that function will be linked instead into the same compile unit.
*HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)* function is defined in *stm32f4xx_it.c* which finally contains code for the interrupt:
```
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin){
	if (GPIO_Pin == B1_Pin){
        HAL_GPIO_TogglePin(LD4_GPIO_Port, LD4_Pin);
	}
}
```
It appears that button on my dev board is designed rather well as it extremely rarely causes glithces undebounced. Probably because it is debounced on the board itself by C11 100nF capacitor. 

## 3. Button debounce
For the button debouncing I will use most primitive interrupt metod. Logic goes like this:
1. Interrupt on button line transition
2. Check what was the last time this interrupt was called
3. If sufficient time has elapsed since the last button interrupt then triger new button toggle in code
4. Exit the interrupt and resume normal code execution

To acomplish this following was added to the *HAL_GPIO_EXTI_Callback* function:
1. Global variable `delayTime` which was set to 100, this is our setting in ms for debounce (usually 50ms in unnoticable)
2. Local static variable `lastButtonTime` which is used to remember last time interupt was triggered
```
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
