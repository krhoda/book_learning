/** @jsx createElement */
import { Children, Context, createElement, Element } from '@bikeshaving/crank';
import { renderer } from '@bikeshaving/crank/dom';
import * as ROT from 'rot-js';

import { Engine } from '../../wasm-functions/pkg/wasm_functions_bg.js';

const appContainer = document.getElementById('app');
const display = new ROT.Display();
const engine = new Engine(display);

console.log("!!!");
console.log(engine);

function App(): Element {
  let sideprops = { hitpoints: 0, moves: 0 };
  return (
    <div className="main-container">
      <div className="row">
        <Header></Header>
      </div>
      <div className="row">
        <Main display={display}></Main>
        <Side {...sideprops}></Side>
      </div>
    </div>
  );
}

function Header(): Element {
  return (
    <div class="row-cell header-text">
      <h1>Rogue WebAssembly</h1>
    </div>
  );
}

function Main({ display }: { display: ROT.Display }): Element {
  let targetID = 'main-panel';

  setTimeout(() => {
    let target = document.getElementById(targetID);
    if (target) {
      let dispElm = display.getContainer();
      if (dispElm) {
        target.appendChild(dispElm);
      }
      // TODO: could throw err here.
    }
    // TODO: could throw err here.
  }, 1000);

  return <div className="row-cell main" id={targetID}></div>;
}

function Side({
  hitpoints,
  moves
}: {
  hitpoints: number;
  moves: number;
}): Element {
  return (
    <div className="row-cell stats">
      <div className="row-cell header-text">
        <h2>Stats</h2>
      </div>
      <div>
        <b>Hitpoints: {hitpoints}</b> / 30
      </div>
      <div>
        <b>Moves: {moves}</b>
      </div>
    </div>
  );
}

if (appContainer) {
  renderer.render(<App />, appContainer);
}
