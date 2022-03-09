#include "helloworld-lib.h"

int main() {
    int ret = helloworld("Thomas");
    printf("ret = %d (from helloworld)\n", ret);
    return(0);
}
