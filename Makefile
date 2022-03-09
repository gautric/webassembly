 
EM_CONFIG=${EMSDK}/.emscripten
EMSDK_NODE=${EMSDK}/node/14.18.2_64bit/bin/node
EMSDK_PYTHON=${EMSDK}/python/3.9.2_64bit/bin/python3
SSL_CERT_FILE=${EMSDK}/python/3.9.2_64bit/lib/python3.9/site-packages/certifi/cacert.pem
EMCC=${EMSDK}/upstream/emscripten/emcc

WASMTIME_HOME=~/.wasmtime

CSOURCE=$(SOURCE:=.c)
PDFOBJECT=$(SOURCE:=.pdf)

BUILD_DIR=build
DIST_DIR=dist

ifeq ($(shell uname -s),Darwin)
	WASI_SDK_PATH=${HOME}/Source/wasm/wasi-sdk-14.0
	EMSDK=${HOME}/Source/wasm/emsdk
endif

CLANG=${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot

CC = gcc
AR = ar
EMAR = emar rcv
RANLIB = emranlib
CFLAGS = -Wall -Wconversion -O3 -fPIC -Wemcc
#CFLAGS = -Wall -Wconversion -fPIC -Wemcc
EMCCFLAGS = -Wemcc -s ASSERTIONS=2 -s "EXPORT_NAME=\"helloworld\"" -s MODULARIZE=1 -s DISABLE_EXCEPTION_CATCHING=0 -s NODEJS_CATCH_EXIT=0  -s WASM=1 -s ALLOW_MEMORY_GROWTH=1  -s SIDE_MODULE=1
EMCCFLAGS = -Wemcc -s MODULARIZE -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s EXPORTED_FUNCTIONS=helloworld -s EXPORT_NAME=helloworld -s EXPORTED_RUNTIME_METHODS=ccall -s DEFAULT_LIBRARY_FUNCS_TO_INCLUDE=helloworld

LD_LIBRARY_PATH=/app:${PWD}

all: staticmain dynamicmain  

mkdir:
	@mkdir -p $(DIST_DIR)
	@mkdir -p $(BUILD_DIR)

check: staticrun dynamicrun noderun pythonrun wasmtimerun

clean: 
	rm -rf *.a *.o *.so *.wasm staticmain dynamicmain main $(BUILD_DIR) $(DIST_DIR)

objlib: helloworld-lib.c helloworld-lib.h mkdir
	$(CC) -Wall -c helloworld-lib.c -o $(BUILD_DIR)/helloworld-lib.o

staticlib: objlib
	$(AR) -cvq $(BUILD_DIR)/helloworld-lib.a $(BUILD_DIR)/helloworld-lib.o

staticmain: staticlib helloworld-main.c mkdir
	$(CC) -Wall  helloworld-main.c $(BUILD_DIR)/helloworld-lib.a -o $(DIST_DIR)/staticmain

staticrun: staticmain
	$(DIST_DIR)/staticmain

#https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
dynamiclib: helloworld-lib.c helloworld-lib.h helloworld-main.c
	$(CC) -c -Wall -Werror -fPIC helloworld-lib.c
	$(CC) -shared  $(BUILD_DIR)/helloworld-lib.o -o $(DIST_DIR)/libhelloworld.so
	
dynamicmain: dynamiclib mkdir
	$(CC) -L$(DIST_DIR) -Wall -o $(DIST_DIR)/dynamicmain helloworld-main.c -lhelloworld

dynamicrun: dynamicmain
	LD_LIBRARY_PATH=/app/$(DIST_DIR):$(DIST_DIR) $(DIST_DIR)/dynamicmain

pythonrun: dynamiclib
	python helloworld.py

wasi: mkdir 
	${CLANG} helloworld-main.c helloworld-lib.c -o $(DIST_DIR)/helloworld-main.wasm

noderun: wasi
	${EMSDK_NODE} --no-warnings  --experimental-wasi-unstable-preview1 helloworld-wasi.js 

wasmtimerun: wasi
	wasmtime $(DIST_DIR)/helloworld-main.wasm

wasibuildlib: helloworld-lib.c 
	${CLANG} -s ENVIRONMENT=node -s WASM=0 helloworld-lib.c -s LINKABLE=1 -s EXPORT_ALL=1 -o helloworld-lib.js

wasibuild: helloworld-main.c helloworld-lib.c 
	${CLANG} helloworld-main.c helloworld-lib.c  -o helloworld-main.wasm
	${CLANG} helloworld-lib.c  -o helloworld-lib.wasm

emcc: 
#	${EMCC}/emcc -O2 helloworld-lib.c -c -o helloworld-lib.o
	${EMCC}  helloworld-lib.c  -s LINKABLE=1 -s EXPORT_ALL=1  -o helloworld-lib.js
#	${EMCC}/emcc   -O2 helloworld-main.c -c -o helloworld-main.o
#	${EMCC}/emcc  helloworld-lib.o -o helloworld-lib.js

	${EMSDK_NODE} helloworld-main.js

emcc2:
	${EMCC}  test.c  -s LINKABLE=1 -s EXPORT_ALL=1  -o test.js
	${EMSDK_NODE} main.js

embedded:
	docker run -ti -v `pwd`:/app --workdir /app  makebuntu  'make container'

container:
	docker build -t makebuntu .

wasmlib: helloworld-lib.h helloworld-lib.c
	@mkdir -p $(BUILD_DIR)
	$(EMCC) $(CFLAGS) -c helloworld-lib.c -o $(BUILD_DIR)/helloworld-lib.o
	$(EMAR) $(BUILD_DIR)/helloworld-lib.a $(BUILD_DIR)/helloworld-lib.o
	$(RANLIB) $(BUILD_DIR)/helloworld-lib.a

wasm: wasmlib
	@mkdir -p $(DIST_DIR);
	$(EMCC) $(CFLAGS) $(BUILD_DIR)/helloworld-lib.a -o $(DIST_DIR)/helloworld-lib.wasm $(EMCCFLAGS)
#	$(EMCC) $(CFLAGS) $(BUILD_DIR)/helloworld-lib.a -o $(DIST_DIR)/main.js $(EMCCFLAGS)
#	cp ./liblinear.d.ts $(BUILD_DIR)/liblinear.d.ts
#	$(EMCC) source.c -s SIDE_MODULE=1 -o target.wasm


wasmlib2: helloworld-lib.h helloworld-lib.c
	$(EMCC) $(CFLAGS)  helloworld-lib.c -o $(DIST_DIR)/helloworld-lib.js $(EMCCFLAGS)
