use std::env;
use std::process;

use minigrep::Config;

fn main() {

    // Args is C Style.
    // 0 is the name of the program as it was invoked. Useful!
    // let args: Vec<String> = env::args().collect();
    // println!("{:?}", args);

    let config = Config::new(env::args()).unwrap_or_else(|err| {
        eprintln!("Problem parsing arugments: {}", err);
        process::exit(1);
    });

    if let Err(e) = minigrep::run(config) {
        eprintln!("Application error: {}", e);
        process::exit(1);
    }
}
