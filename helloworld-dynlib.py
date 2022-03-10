#!/env python3.9

from ctypes import *

so_functions = CDLL("./dist/libhelloworld.so")

print(type(so_functions))
ret = so_functions.helloworld(b"Paul")

print(ret)