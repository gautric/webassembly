
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

all: staticmain dynamicmain  

clean: 
	rm -f *.a *.o *.so staticmain main

objlib: helloworld-lib.c helloworld-lib.h
	gcc -Wall -c helloworld-lib.c

staticlib: objlib
	ar -cvq helloworld-lib.a helloworld-lib.o

staticmain: staticlib helloworld-main.c
	gcc -Wall -o staticmain helloworld-main.c helloworld-lib.a

#https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
dynamiclib: 	
	gcc -c -Wall -Werror -fPIC helloworld-lib.c
	gcc -shared -o libhelloworld.so helloworld-lib.o
	
dynamicmain: dynamiclib
	gcc -L. -Wall -o dynamicmain helloworld-main.c -lhelloworld

dynamicrun: dynamicmain
	./dynamicmain

python: dynamiclib
	python3.9 helloworld.py 

wasi: 
	${WASMTIME_SDK}/bin/clang   helloworld-main.c helloworld-lib.c -o helloworld-main.wasm

node: wasi
	${EMSDK_NODE} --no-warnings  --experimental-wasi-unstable-preview1 helloworld-wasi.js 

emcc: 
#	${EMCC}/emcc -O2 helloworld-lib.c -c -o helloworld-lib.o
	${EMCC}/emcc  helloworld-lib.c  -s LINKABLE=1 -s EXPORT_ALL=1  -o helloworld-lib.js
#	${EMCC}/emcc   -O2 helloworld-main.c -c -o helloworld-main.o
#	${EMCC}/emcc  helloworld-lib.o -o helloworld-lib.js

	${EMSDK_NODE} helloworld-main.js



test: 
	${EMCC}/emcc  test.c  -s LINKABLE=1 -s EXPORT_ALL=1  -o test.js
	${EMSDK_NODE} main.js


