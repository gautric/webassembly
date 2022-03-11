
#include "helloworld-lib.h"

#ifdef __cplusplus
    extern "C" {
#endif

EMSCRIPTEN_KEEPALIVE int helloworld(const char * name) {
    printf("Call 'helloworld' %s \n", name);

    printf("HELLOWORLD_ENV = %s \n", getenv(HELLOWORLD_ENV));

    return 42;
}

EMSCRIPTEN_KEEPALIVE int version() {
  return 42;
}

EMSCRIPTEN_KEEPALIVE int add(int i) {
  return 42 + i;
}

#ifdef __cplusplus
}
#endif