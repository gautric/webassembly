// node main.js
Module = require('./helloworld-lib.js');

Module.onRuntimeInitialized = () => {
  var helloworld = Module.cwrap('helloworld', 'number', ['string']);
  console.log(helloworld('Marie'));
}


