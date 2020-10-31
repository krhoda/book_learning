#include <stdio.h>
#include <stdlib.h>

/* Upper / Lower iteration limits centered around 1.0 */
// I do NOT understand the hexidecimal, other than it is hexidecimal.
// I also do NOT understand the naming convention.
static double const eps1m01 = 1.0 - 0x1P-01;
static double const eps1p01 = 1.0 + 0x1P-01;
static double const eps1m24 = 1.0 - 0x1P-24;
static double const eps1p24 = 1.0 + 0x1P-24;

int main(int argc, char* argv[argc+1]) {
    for (int i = 1; i < argc; ++i) {
        // TODO: work from here
    }
}