// node main.js
var Module = require('./helloworld-lib-module.js');

Module().then((instance) => {
  instance._helloworld("Thomas"); // direct calling works
  instance.ccall("version"); // using ccall etc. also work
  console.log(instance._helloworld("Marie")); // values can be returned, etc.
});