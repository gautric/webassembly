FROM emscripten/emsdk:latest

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y build-essential cmake git python3.9 

RUN curl https://wasmtime.dev/install.sh -sSf | bash

