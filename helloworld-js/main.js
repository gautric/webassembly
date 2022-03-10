
// emcc ../src/helloworld-lib.c  -o helloworld-lib.js -s MODULARIZE -s EXPORTED_RUNTIME_METHODS=ccall
// node main.js
var Module = require('./helloworld-lib.js');

Module().then((instance) => {
  instance._helloworld("ptr"); // direct calling works
  instance.ccall("version"); // using ccall etc. also work
  console.log(instance._helloworld("ptr")); // values can be returned, etc.
});