use std::io::stdin;

macro_rules! scanline {
    ($x:expr) => ({
        stdin().read_line(&mut $x).unwrap();
        $x = $x.trim().to_string();
    });

    () => ({
        let mut s = String::new();
        stdin().read_line(&mut s).unwrap();
        s.trim().to_string()
    });
}

fn main() {
    let mut input = String::new();
    println!("Gimme something to echo");
    scanline!(input);
    println!("Echoing {:?}", input);
    println!("Gimme else something to echo");
    let s = scanline!();
    println!("Echoing {:?}", s);
}

