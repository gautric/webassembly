
#include "helloworld-lib.h"

#ifdef __EMSCRIPTEN__
    #include <emscripten.h>
#endif

#ifdef __cplusplus
    extern "C" {
#endif

#ifdef __EMSCRIPTEN__
    EMSCRIPTEN_KEEPALIVE
#endif
int helloworld(const char * name) {
    printf("Call 'helloworld' %s \n", name);
    return 42;
}

#ifdef __EMSCRIPTEN__
    EMSCRIPTEN_KEEPALIVE
#endif
int version() {
  return 42;
}

#ifdef __cplusplus
}
#endif