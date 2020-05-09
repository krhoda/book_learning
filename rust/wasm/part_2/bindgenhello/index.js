const wasm = import('./bindgenhello');
wasm.then((h) => {
	return h.hello("world!");
}).catch(console.error);
