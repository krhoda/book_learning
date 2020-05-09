import React, {useEffect, useReducer} from "react";
import ReactDOM from "react-dom";

const doSomeWasm = () => {
	window.rogueWASM.big_computation();
}

const App = () => {
	const wasmReducer = (state, action) => {
		if (action.type === 'init') {
			return true;
		}
	};

	let [wasmLoaded, wasmDispatch] = useReducer(wasmReducer, false);

	console.log('WASM LOADED IS');
	console.log(wasmLoaded)

	useEffect(() => {
		document.addEventListener("ROGUEWASM::READY", () => {wasmDispatch(true)})
	})

	let loaded = <p>Loading...</p>;
	if (wasmLoaded) {
		loaded = <button onClick={doSomeWasm}>WASM NOW!</button>;
	}

	return (
		<div>
			<h1>Hi there</h1>
			{loaded}
		</div>
	);
};

ReactDOM.render(<App />, document.getElementById("root"));
