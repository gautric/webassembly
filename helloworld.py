#!/env python3.9

from ctypes import *

so_functions = CDLL("./libhelloworld.so")

print(type(so_functions))
ret = so_functions.helloWorld(b"Paul")

print(ret)