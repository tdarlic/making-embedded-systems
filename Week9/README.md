# Week 9 homwork: Multiple implementations
Algorithm: How many bits are one in a given 32-bit uint?

## This is known as Hamming weight and further explanations can be found in [Wikipedia](https://en.wikipedia.org/wiki/Hamming_weight):

Below are some links detailing the algorithms that I used:
- https://web.archive.org/web/20151229003112/http://blogs.msdn.com/b/jeuge/archive/2005/06/08/hakmem-bit-count.aspx
- http://aggregate.ee.engr.uky.edu/MAGIC/#Population%20Count%20(Ones%20Count)
- https://graphics.stanford.edu/%7Eseander/bithacks.html#CountBitsSetParallel
- https://gurmeet.net/puzzles/fast-bit-counting-routines/

## Code
- ![Main code](/Week9/code.c)
- ![Code generating lookup table](/Week9/gentable.c)

## Use compiler and profiler
I did not have time to setup the tools for the test board so I did all tests on GCC compiler on Debian Linux

Following setup was used:
```
gcc -Wall -pg code.c -o code_prof.out
```

This outputs compiled code and the profiler output which is then fed to `gprof` tool:
```
gprof -b code_prof.out gmon.out
```

### Output of the profiler
Each value generated is printed out so that compiler does not optimize out
variable
```
Flat profile:

Each sample counts as 0.01 seconds.
  %   cumulative   self              self     total           
 time   seconds   seconds    calls  ns/call  ns/call  name    
 45.09      0.31     0.31  1000000   306.63   306.63  countOnesF
 38.44      0.57     0.26                             main
  8.87      0.63     0.06  1000000    60.32    60.32  countOnesA
  7.39      0.68     0.05  1000000    50.27    50.27  countOnesB
  0.74      0.68     0.01  1000000     5.03     5.03  countOnesE
  0.00      0.68     0.00  1000000     0.00     0.00  countOnesC
  0.00      0.68     0.00  1000000     0.00     0.00  countOnesD

			Call graph


granularity: each sample hit covers 2 byte(s) for 1.46% of 0.68 seconds

index % time    self  children    called     name
                                                 <spontaneous>
[1]    100.0    0.26    0.42                 main [1]
                0.31    0.00 1000000/1000000     countOnesF [2]
                0.06    0.00 1000000/1000000     countOnesA [3]
                0.05    0.00 1000000/1000000     countOnesB [4]
                0.01    0.00 1000000/1000000     countOnesE [5]
                0.00    0.00 1000000/1000000     countOnesC [6]
                0.00    0.00 1000000/1000000     countOnesD [7]
-----------------------------------------------
                0.31    0.00 1000000/1000000     main [1]
[2]     44.9    0.31    0.00 1000000         countOnesF [2]
-----------------------------------------------
                0.06    0.00 1000000/1000000     main [1]
[3]      8.8    0.06    0.00 1000000         countOnesA [3]
-----------------------------------------------
                0.05    0.00 1000000/1000000     main [1]
[4]      7.4    0.05    0.00 1000000         countOnesB [4]
-----------------------------------------------
                0.01    0.00 1000000/1000000     main [1]
[5]      0.7    0.01    0.00 1000000         countOnesE [5]
-----------------------------------------------
                0.00    0.00 1000000/1000000     main [1]
[6]      0.0    0.00    0.00 1000000         countOnesC [6]
-----------------------------------------------
                0.00    0.00 1000000/1000000     main [1]
[7]      0.0    0.00    0.00 1000000         countOnesD [7]
-----------------------------------------------

Index by function name

   [3] countOnesA              [7] countOnesD              [1] main
   [4] countOnesB              [5] countOnesE
   [6] countOnesC              [2] countOnesF
```

The slowest function is function B using set bit elimination but the
interesting fact is that the second slowest is one using a lookup table.
The rest of the optimized fast functions are so fast that after 1M repeats
there are basically executed in no time

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
