
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

LD_LIBRARY_PATH=${PWD}

# docker run -ti -v `pwd`:/app ubuntu  /bin/bash
# apt-get update && apt-get install -y build-essential  python3.9 

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
	gcc -c -Wall -Werror -fPIC helloworld-lib.c
	gcc -shared -o libhelloworld.so helloworld-lib.o
	
dynamicmain: dynamiclib
	gcc -L. -Wall -o dynamicmain helloworld-main.c -lhelloworld

dynamicrun: dynamicmain
	./dynamicmain

python: dynamiclib
	python3.9 helloworld.py 