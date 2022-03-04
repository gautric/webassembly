#!/env python3.9

from ctypes import *

so_file = "./helloworld.so"
so_functions = CDLL(so_file)

print(type(so_functions))
so_functions.helloWorld(b"Paul")
 