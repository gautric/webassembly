import fs from 'fs';
import {WASI} from 'wasi';
import { argv, env } from 'process';

const wasi = new WASI({
  args: [argv[0], "Marie"],
  env: {
    'HELLOWORLD_ENV': "env_Passed_WASI"
  },
  preopens: {
    '.': '.'
  }
});

const importObject = {
  wasi_snapshot_preview1 : wasi.wasiImport,
  imports: {
    // imported_func: function(arg) {
    //   console.log(arg);
    // },
    wasi_unstable: () => {}
  }
};

const wasm = await WebAssembly.compile(fs.readFileSync('./dist/helloworld-main.wasm'));

const instance = await WebAssembly.instantiate(wasm, importObject);

wasi.start(instance);


