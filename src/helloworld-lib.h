#include <stdio.h>
#include <stdlib.h>

#ifndef helloWorld_h__
#define helloWorld_h__

#define HELLOWORD_ENV "HELLOWORD_ENV"

#define export __attribute__( ( visibility( "default" ) ) 

extern int helloworld(const char * name);

extern int version();
 
#endif  // helloWorld_h__

