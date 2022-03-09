#include <stdio.h>

#ifndef helloWorld_h__
#define helloWorld_h__

#define export __attribute__( ( visibility( "default" ) ) 

extern int helloworld(const char * name);

extern int version();
 
#endif  // helloWorld_h__

