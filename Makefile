
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

all: nativelib nativemain

nativelib: helloworld-lib.c helloworld-lib.h
	gcc -Wall -c helloworld-lib.c
	ar -cvq helloworld-lib.a helloworld-lib.o


nativemain: nativelib helloworld-main.c
	gcc -Wall -o main helloworld-main.c helloworld-lib.a

