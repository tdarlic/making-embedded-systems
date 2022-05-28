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

## Speed of execution using profiler
I did not have time to setup the tools for the test board so I did all tests on GCC compiler on Debian Linux

Following setup was used:
```
gcc -Wall -pg code.c -o code_prof.out
```

This outputs compiled code and the profiler output which is then fed to `gprof` tool:
```
gprof -b code_prof.out gmon.out
```
__WARNING:__ As the profiler is used on computer it will certainly give totally different results
than profiler for ARM MCU

### Output of the profiler
Each value generated is printed out so that compiler does not optimize out
variable and the calculation is performed on 1M randomly generated array.
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

Slowest function is one just counting least significant bit followed
suprisingly by the function using lookup table and finally function using
counting least significant bit that is set.
The rest of the optimized fast functions are so fast that after 1M repeats
there are basically executed in no time
Maybe a [Valgrind](https://valgrind.org/) tool could be used to profile the
memory usage but I don't have a time for that now

## Code size using Linux GNU ARM GCC cross compiler
I've compiled a code to assembly using `-O1` compiler parameter as the assembly 
was too long to analyse using `-O0` parameter.

### Code length of each function 
| Function | Code length (in asm lines)|
| -------- | ----------- |
| countOnesA | 22 |
| countOnesB | 9 |
| countOnesC | 22 |
| countOnesD | 19 |
| countOnesE | 13 |
| countOnesF | 12 |

Code size calculated like this is not real representation of the real MCU code size this
should be calculated from map file but I'll use it here because of the lack of time 

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
Table could be generated at the start of the code and reused for each
repetition

Using a lookup table might prove faster in some setups but here it is
definitely not the fastest function. The reason might splitting the input into
4 bytes and testing them separately and then adding the result together. 
Full lookup table for 32 bit wide variable would be too big to fit in most of
MCUs. This implementation is just for demonstration.

### Pros
- Speed but profiler did not register that
### Cons
- Memory usage
- _Slow?_

## Counting least significant set bit (Function B)
```c
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
```
 This function just shifts the bits to right and counts n & (n - 1) always eliminates 
 the least significant 1.
 Each time the least significant 1 is eliminated the count is increased until the n is 0

 I would easily use this function in a project if couting set bits is not used
 often.

### Pros
- Simplicity so it is easy to understand
- It could be easily adjusted to be used on any word width
- Memory usage
- Code space, this is the shortest function in Linux ARM GCC assembly
### Cons
- The function proved to be slow

## MIT HAKMEM (Function C)
```c
uint8_t countOnesC(uint32_t x) {
    uint32_t uCount;
    uint32_t u = x;
    uCount = u - ((u >> 1) & 033333333333) - ((u >> 2) & 011111111111);
    return ((uCount + (uCount >> 3)) & 030707070707) % 63;
}
```
This function is copied from MIT HAKMEM set of functions and is often mentioned
in Hamming weight functions lists. It appears to be very fast and efficient. I
never tried to understand it fully so I just used it here by copying it
directly. 

### Pros
- Apparently very fast
- Memory usage
### Cons
- It is hard to understand
- It would need complicated adjustment to get it to work for wider words 

## Using magic numbers ver 1 (Function D)
```c
uint8_t countOnesD (uint32_t x){
    x = (x & (0x55555555)) + ((x >> 1) & (0x55555555));
    x = (x & (0x33333333)) + ((x >> 2) & (0x33333333));
    x = (x & (0x0f0f0f0f)) + ((x >> 4) & (0x0f0f0f0f));
    x = (x & (0x00ff00ff)) + ((x >> 8) & (0x00ff00ff));
    x = (x & (0x0000ffff)) + ((x >> 16) & (0x0000ffff));
    return x;
}
```
Calculating number of set bits sort of in parallel by "shifting" the set bits to right
Magic numbers used are 0x55555555, 0x33333333, 0x0f0f0f0f, 0x00ff00ff, 0x0000ffff

These numbers are representing growing parts of bytes which are "remembering"
set bits

### Pros
- Apparently very fast
- Memory usage
### Cons
- It is hard to understand without examining it in detail
- Needs carefull consideration to make it word for any bit width 

## Using magic numbers ver 2 (Function E)
```c
uint8_t countOnesE(uint32_t v)
{
    uint32_t c; // store the total here
    static const uint32_t S[] = {1, 2, 4, 8, 16}; // Magic Binary Numbers
    static const uint32_t B[] = {0x55555555, 0x33333333, 0x0F0F0F0F, 0x00FF00FF, 0x0000FFFF};

    c = v - ((v >> 1) & B[0]);
    c = ((c >> S[1]) & B[1]) + (c & B[1]);
    c = ((c >> S[2]) + c) & B[2];
    c = ((c >> S[3]) + c) & B[3];
    c = ((c >> S[4]) + c) & B[4];
    return c;
}
```
Same as function D but rewritten so it is easier to expand

### Pros
- Apparently very fast
- Memory usage
- It could be easily adjusted to be used on any word width
### Cons
- It is hard to understand without examining it in detail
- Slower than Function E using the same principle


## Simplest and stupidest function that first pops into my mind (Function F)
```c
uint8_t countOnesF(uint32_t v)
{
    uint8_t count = 0;
    for(uint8_t i = 0; i < 32; i++){
       if (v & 0x1){
           count++;
       }
       v = v >> 1;
    }
    return count;
}
```
This is the first function that poped into my mind when I've chosen the
algorithm. It adds 1 to count in case that least significant bit is set and
then shifts the number to right by one.
I would not use this ever but would be my first choice if asked on interview.

### Pros
- Memory usage
- It could be easily adjusted to be used on any word width
### Cons
- Very slow as it traverses all input 32 times and shifts
