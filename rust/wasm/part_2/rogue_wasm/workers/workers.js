import Echo from './src/echo.worker';
import Greeter from './src/wasm_greet.worker';

function makeEchoWorker() {
  return new Echo();
}

function makeGreeterWorker() {
  return new Greeter();
}

export { makeEchoWorker, makeGreeterWorker };
