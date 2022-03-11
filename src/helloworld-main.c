#include "helloworld-lib.h"

int main(int argc, char* argv[]) {
    int ret = 0;

    if(argc == 2 ) {
        ret = helloworld(argv[1]);
    } else {
        ret = helloworld("Thomas");    
    }

    printf("ret = %d (from helloworld)\n", ret);
    return(0);
}
