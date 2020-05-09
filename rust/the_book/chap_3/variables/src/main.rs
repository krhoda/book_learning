fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);

    x = 6;
    println!("x is now {}, take that haskell!", x);

    const WEIRD_SYNTAX: u32 = 1_000_000;
    println!("I feel like ${} bux.", WEIRD_SYNTAX);

    println!("Shadow powers, or how I won the obfuscated Rust competition");

    let y = 1;
    let y = y + 7;
    println!("y: {}", y);

    let y = y < 7;
    println!("yyyyyyyyyyyyyy: {}", y);

    let y = 2;
    let y = y + y;
    let y = y == 5;
    let y = !y;

    if y {
        println!("y not: {}", y);
    }

    let c = 'z';
    let z = 'ℤ';

    println!("{}{}{}{}{}{}{}", z, c, z, c, z, c, z);

    let tup: (i32, f64, u8) = (500, 6.4, 1);

    let (_, _, y) = tup;

    println!("Ah hell yeah: #{} fun of elixir", y);

    let y = tup.0;

    println!("It's 500 isn't it? {}", y);

    let y = [1, 2, 3];
    println!("0: {} 1: {} 2: {}", y[0], y[1], y[2]);
    let y: [i32; 3] = [10, 20, 30];
    println!("0: {} 1: {} 2: {}", y[0], y[1], y[2]);
    let y = [100; 3];
    println!("0: {} 1: {} 2: {}", y[0], y[1], y[2]);
}
