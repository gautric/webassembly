
#include "helloworld-lib.h"

int fourtyTwo = 42;

#ifdef __cplusplus
    extern "C" {
#endif

EMSCRIPTEN_KEEPALIVE int helloworld(const char * name) {
    printf("Call 'helloworld' %s \n", name);

    printf("HELLOWORLD_ENV = %s \n", getenv(HELLOWORLD_ENV));

    return fourtyTwo;
}

EMSCRIPTEN_KEEPALIVE int version() {
  return fourtyTwo;
}

EMSCRIPTEN_KEEPALIVE int add(int i) {
  return fourtyTwo + i;
}

#ifdef __cplusplus
}
#endif