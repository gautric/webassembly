#include <stdio.h>
#include <stdlib.h>

#ifndef helloWorld_h__
#define helloWorld_h__


#ifdef __EMSCRIPTEN__
    #include <emscripten.h>
#else
    // Provide empty #define  
    #define EMSCRIPTEN_KEEPALIVE 
#endif

#define HELLOWORLD_ENV "HELLOWORLD_ENV"

#define WASM_EXPORT __attribute__((visibility("default")))

EMSCRIPTEN_KEEPALIVE WASM_EXPORT extern int helloworld(const char * name);

EMSCRIPTEN_KEEPALIVE WASM_EXPORT extern int version();

EMSCRIPTEN_KEEPALIVE WASM_EXPORT extern int add(int i);
 
#endif  // helloWorld_h__

