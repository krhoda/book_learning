#include <stdlib.h>
#include <stdbool.h>

int main(int argc, char* argv[argc+1]) {
    puts("Hello_World!");
    if (argc > 1) {
        while (true) {
            puts("some_programs_never_stop");
        }
    } else {
        do {
            puts("but_this_one_does");
        } while (false);
    }

    return EXIT_SUCCESS;
}