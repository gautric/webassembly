
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

    printf("HELLOWORD_ENV = %s \n", getenv(HELLOWORD_ENV));

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