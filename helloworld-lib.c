
#include "helloworld-lib.h"

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

__attribute__((used))

int helloWorld(const char * name) {
    printf("Call 'helloWorld' %s \n", name);
    return 42;
}

#ifdef __cplusplus
}
#endif