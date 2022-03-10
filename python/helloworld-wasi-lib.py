from wasmer import engine, Store, wasi, Module, Instance
from wasmer_compiler_cranelift import Compiler
import os

__dir__ = os.path.dirname(os.path.realpath(__file__))

store = Store(engine.Universal(Compiler))
module = Module(store, open('./dist/helloworld-lib-std.wasm', 'rb').read())
wasi_version = wasi.get_version(module, strict=True)
import_object = wasi.StateBuilder('lib').finalize().generate_import_object(store, wasi_version)


instance = Instance(module, import_object)

# export function
version = instance.exports.version
helloworld = instance.exports.helloworld
add = instance.exports.add

# use function
assert version() == 42
# Need pass a String
helloworld(0)

print(add(42))