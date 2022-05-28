# Week 9 homwork: Multiple implementations
Algorithm: How many bits are one in a given 32-bit uint?

## This is known as Hamming weight and further explanations can be found in [Wikipedia](https://en.wikipedia.org/wiki/Hamming_weight):

Below are some links detailing the algorithms that I used:
https://web.archive.org/web/20151229003112/http://blogs.msdn.com/b/jeuge/archive/2005/06/08/hakmem-bit-count.aspx
http://aggregate.ee.engr.uky.edu/MAGIC/#Population%20Count%20(Ones%20Count)
https://graphics.stanford.edu/%7Eseander/bithacks.html#CountBitsSetParallel
https://gurmeet.net/puzzles/fast-bit-counting-routines/

## Code
![Main code](/Week9/code.c)
![Code generating lookup table](/Week9/gentable.c)

## Use compiler and profiler
I did not have time to setup the tools for the test board so I did all tests on GCC compiler on Debian Linux
Following setup was used:
`gcc -Wall -pg code.c -o code_prof.out`
This outputs compiled code and the profiler output which is then fed to `gprof` tool:
`gprof -b code_prof.out gmon.out`

## Descriptions and comments

### Lookup table (Function A)
```c
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
```
This function uses lookup table. This table is generated with the code used ![here](/Week9/gentable.c)
Using a lookup table might prove faster 
