
WASMTIME_SDK=${HOME}/Source/wasm/wasi-sdk-14.0
EMSDK=${HOME}/Source/wasm/emsdk

EM_CONFIG=${EMSDK}/.emscripten
EMSDK_NODE=${EMSDK}/node/14.18.2_64bit/bin/node
EMSDK_PYTHON=${EMSDK}/python/3.9.2_64bit/bin/python3
SSL_CERT_FILE=${EMSDK}/python/3.9.2_64bit/lib/python3.9/site-packages/certifi/cacert.pem
EMCC=${EMSDK}/upstream/emscripten

WASMTIME_HOME=~/.wasmtime
CLANG=${WASMTIME_SDK}/bin/clang 

CSOURCE=$(SOURCE:=.c)
PDFOBJECT=$(SOURCE:=.pdf)

all: staticlib staticmain dynamiclib  

clean: 
	rm -f *.a *.o *.so staticmain main

objlib: helloworld-lib.c helloworld-lib.h
	gcc -Wall -c helloworld-lib.c

staticlib: objlib
	ar -cvq helloworld-lib.a helloworld-lib.o

staticmain: staticlib helloworld-main.c
	gcc -Wall -o staticmain helloworld-main.c helloworld-lib.a

dynamiclib: 
	gcc -c -fPIC helloworld-lib.c
#	gcc helloworld-lib.o -fPIC -shared -o helloworld.so
	gcc -shared -Wl,-soname,libhelloworld.so -o libhelloworld.so helloworld-lib.o
#	nm -D  libhelloworld.so

dynamicmain: dynamiclib
#	gcc -Wall -L -o dynamicmain helloworld-main.c 
#	LD_LIBRARY_PATH=${PWD} gcc -L -v helloworld-main.c -lhelloworld -o dynamicmain

	LD_LIBRARY_PATH=${PWD} gcc  -fPIC  -I. -L. -lhelloworld helloworld-main.c  -o dynamicmain

# docker run -ti -v `pwd`:/app ubuntu  /bin/bash
# apt-get update && apt-get install -y build-essential  python3.9 

