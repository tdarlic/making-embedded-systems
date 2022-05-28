#include <stdio.h>
#include <stdint.h>


#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  (byte & 0x80 ? '1' : '0'), \
  (byte & 0x40 ? '1' : '0'), \
  (byte & 0x20 ? '1' : '0'), \
  (byte & 0x10 ? '1' : '0'), \
  (byte & 0x08 ? '1' : '0'), \
  (byte & 0x04 ? '1' : '0'), \
  (byte & 0x02 ? '1' : '0'), \
  (byte & 0x01 ? '1' : '0') 

int main(void){
    printf("Generating table\n");
    uint32_t count = 0;
    uint32_t n = 0;
    for (uint16_t i = 0; i < 256; i++){
        count = 0;
        n = i;
        while(n != 0){
          n = n & (n-1);
          count++;
        }
        // Line below generates the test patters so that it can be visually checked
        // printf("Number %i - "BYTE_TO_BINARY_PATTERN" - Count: %i\n", i, BYTE_TO_BINARY(i), count);
        // Line below generates the values in a list so it can be inserted directly into the array in code
        printf("%i,", count);
    }
}
