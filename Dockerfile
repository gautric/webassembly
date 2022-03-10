FROM emscripten/emsdk:latest

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake git python3.9 

RUN curl https://wasmtime.dev/install.sh -sSf | bash

ENV WASI_VERSION=14
ENV WASI_VERSION_FULL=${WASI_VERSION}.0
ENV WASI_SDK_PATH=/src/wasi-sdk-${WASI_VERSION_FULL}

RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz && tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz && rm wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

RUN pip3 install wasmer wasmer_compiler_cranelift 