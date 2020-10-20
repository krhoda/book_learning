/** @jsx createElement */
import { Children, Context, createElement, Element } from '@bikeshaving/crank';
import { renderer } from '@bikeshaving/crank/dom';
import * as pb from 'post-buffer';

import { makeEchoWorker } from 'workers';

const appContainer = document.getElementById('app');
const worker = makeEchoWorker();

function* Greeting(
  this: Context,
  { name }: { name: string }
): Generator<Element> {
  let handler = (e: Event) => {
    e.preventDefault();

    let [success, err] = pb.postBuffer({ hello: 'world' }, worker);
    if (!success) {
      console.error(`${err}`);
    }
  };

  while (true) {
    yield (<button onclick={handler}>Hello {name}</button>);
  }
}

function App(): Element {
  let sideprops = { hitpoints: 0, moves: 0 };
  return (
    <div className="main-container">
      <div className="row">
        <Header></Header>
      </div>
      <div className="row">
        <Main></Main>
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

function Main(): Element {
  return <div className="row-cell main">Will be the main panel</div>;
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
