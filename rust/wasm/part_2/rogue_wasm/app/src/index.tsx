/** @jsx createElement */
import { createElement } from "@bikeshaving/crank";
import { renderer } from "@bikeshaving/crank/dom";
import { Element } from "@bikeshaving/crank";

const appContainer = document.getElementById("app");

function Greeting(): Element {
  return <div>Hello world</div>;
};

if (appContainer) {
  renderer.render(<Greeting />, appContainer);
}
