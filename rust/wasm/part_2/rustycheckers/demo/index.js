console.log("0");

fetch('./rustycheckers.wasm').then((response) => {
	console.log("I");
	return response.arrayBuffer()
}).then((bytes) => {
	console.log("II");
	return WebAssembly.instantiate(bytes, {
		env: {
			notify_piecemoved: (fx, fy, tx, ty) => {
				console.log(`Peice moved from ${fx},${fy} to ${tx},${ty}`);
			},
			notify_piececrowned: (fx, fy, tx, ty) => {
				console.log(`Peice moved from ${fx},${fy} to ${tx},${ty}`);
			}
		},
	})
}).then((results) => {
	console.log("III");
	let x = results.instance.exports;
	console.log("At start, current turn is ${x.get_current_turn()}");

	let piece = x.get_piece(0, 7);
	console.log(`Piece at 0,7 is ` + piece);

	let res = x.move_piece(0, 5, 1, 4);
	console.log(`1st move result: ${res}`);
	console.log("After 1 move turn: ${x.get_current_turn()}");

	let bad = x.move_piece(1, 4, 2, 3);
	console.log(`Illegal move result: ${bad}`);
	console.log("After Illegal move turn: ${x.get_current_turn()}");
}).catch(console.error);
