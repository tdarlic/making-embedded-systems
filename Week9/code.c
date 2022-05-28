/* ***********************************************************************************
 * The code below is written as a part of the excercise for Embedded Systems Course  * 
 * Author: Tomislav Darlic                                                           *
 * 28 May 2022                                                                       *
 * ***********************************************************************************/

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

/**
 * Counts number of bits that are set to one in 32 bit word
 * This function uses the lookup table
 * The table is only computed for each byte in order to save space
 * and sanity
 * The table is generated with the help of alhorithm used in 
 * countOnesB function
 * @param x uint32_t 32 bit wide word to be counted
 * @return uint8_t Number of bits set to 1
 */
uint8_t countOnesA(uint32_t x)
{
    // 4 variables to store count for each byte
    uint32_t ca, cb, cc, cd = 0;
    const unsigned char table[] = {
    0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,
    2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,1,2,2,3,2,3,3,4,
    2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,
    4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,
    2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,
    4,5,5,6,4,5,5,6,5,6,6,7,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,
    4,5,5,6,5,6,6,7,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,4,5,5,6,5,6,6,7,5,6,6,7,
    6,7,7,8
    };
    // Split each byte into separate variable
    ca = (x & 0xFF000000) >> 24;
    cb = (x & 0x00FF0000) >> 16;
    cc = (x & 0x0000FF00) >> 8;
    cd = (x & 0x000000FF);

    // Sum the counts for all bytes
    return table[ca] + table[cb] + table[cc] + table[cd];
}

/**
 * Counts number of bits that are set to one in 32 bit word
 * This function just shifts the bits to right and count 
 * n & (n - 1) always eliminates the least significant 1 
 * Each time the least significant 1 is eliminated the count
 * is increased until the n is 0
 * @param x uint32_t 32 bit wide word to be counted
 * @return uint8_t Number of bits set to 1
 */
uint8_t countOnesB(uint32_t x)
{
    uint32_t count = 0;
    uint32_t n = x;

    while (n != 0){
        // Eliminate the least significant one and increase count
        n = n & (n - 1); 
        count++;
    }

    return count;
}

/**
 * Counts number of bits that are set to one in 32 bit word
 * This function is copied directly from MIT HAKMEM:
 * https://web.archive.org/web/20151229003112/http://blogs.msdn.com/b/jeuge/archive/2005/06/08/hakmem-bit-count.aspx
 * I did not venture into detailing how exactly the function works but it appears to be correct 
 * To avoid confusion it needs to be noted that all numbers used below for and-ing the numbers are octal 
 * @param x uint32_t 32 bit wide word to be counted
 * @return uint8_t Number of bits set to 1
 */
uint8_t countOnesC(uint32_t x) {
    uint32_t uCount;
    uint32_t u = x;
    uCount = u - ((u >> 1) & 033333333333) - ((u >> 2) & 011111111111);
    return ((uCount + (uCount >> 3)) & 030707070707) % 63;
}

/**
 * Counts number of bits that are set to one in 32 bit word
 * This function counts set bits in parralel using the "magic" numbers:
 * 0x55555555, 0x33333333, 0x0f0f0f0f, 0x00ff00ff, 0x0000ffff
 * It works by counting bits "in parralel", each set bit is
 * "shifted" to the right until the correct number remains in least significant byte
 * @param x uint32_t 32 bit wide word to be counted
 * @return uint8_t Number of bits set to 1
 */
uint8_t countOnesD (uint32_t x){
    x = (x & (0x55555555)) + ((x >> 1) & (0x55555555));
    x = (x & (0x33333333)) + ((x >> 2) & (0x33333333));
    x = (x & (0x0f0f0f0f)) + ((x >> 4) & (0x0f0f0f0f));
    x = (x & (0x00ff00ff)) + ((x >> 8) & (0x00ff00ff));
    x = (x & (0x0000ffff)) + ((x >> 16) & (0x0000ffff));
    return x;
}

/**
 * Counts number of bits that are set to one in 32 bit word
 * This function counts set bits in parralel using the "magic" numbers:
 * 0x55555555, 0x33333333, 0x0f0f0f0f, 0x00ff00ff, 0x0000ffff
 * Principle of operation is the same as the countOnesD but it uses 
 * format that can be easiliy adapted to 64 bit numbers
 * @param x uint32_t 32 bit wide word to be counted
 * @return uint8_t Number of bits set to 1
 */
uint8_t countOnesE(uint32_t v)
{
    unsigned int c; // store the total here
    static const int S[] = {1, 2, 4, 8, 16}; // Magic Binary Numbers
    static const int B[] = {0x55555555, 0x33333333, 0x0F0F0F0F, 0x00FF00FF, 0x0000FFFF};

    c = v - ((v >> 1) & B[0]);
    c = ((c >> S[1]) & B[1]) + (c & B[1]);
    c = ((c >> S[2]) + c) & B[2];
    c = ((c >> S[3]) + c) & B[3];
    c = ((c >> S[4]) + c) & B[4];
    return c;
}

int main(void) {
    uint32_t test = 0xAAAAAAAA;
    uint8_t r;
    // insert code here: 
    printf("Testing counting bits set to one in: 0x%04X\n", test);
    
    r = countOnesA(test);
    printf("countOnesA result: %i\n", r);

    r = countOnesB(test);
    printf("countOnesB result: %i\n", r);

    r = countOnesC(test);
    printf("countOnesC result: %i\n", r);

    r = countOnesD(test);
    printf("countOnesD result: %i\n", r);

    r = countOnesE(test);
    printf("countOnesE result: %i\n", r);
}
