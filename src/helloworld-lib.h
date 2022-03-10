#include <stdio.h>
#include <stdlib.h>

#ifndef helloWorld_h__
#define helloWorld_h__

#define HELLOWORLD_ENV "HELLOWORLD_ENV"

#define export __attribute__( ( visibility( "default" ) ) 

extern int helloworld(const char * name);

extern int version();

extern int add(int i);
 
#endif  // helloWorld_h__

