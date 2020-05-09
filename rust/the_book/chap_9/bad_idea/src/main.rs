use std::fs::File;
use std::io;
use std::io::ErrorKind;
use std::io::Read;

fn main() {
    println!("Hello, world!");
    // Uncomment to kill the program:
    // panic!("It died here");

    // Same idea:
    // let v = vec![1, 2, 3];
    // v[99]; // Runtime err.
    let f = File::open("doesnt_ex.txt");
    match f {
        // Ok wraps the file.
        // If I wanted to return, I could assign from the match.
        Ok(_) => println!("HOW?"),
        // You can nest matches on err types.
        Err(error) => println!("I bet it's not found: {}", error),
    }

    // This is ideomatic:
    let mut nf = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("Problem creating the file: {:?}", error);
            })
        } else {
            panic!("Problem opening the file: {:?}", error);
        }
    });

    let mut s = String::new();

    // Cast to result
    let r = match nf.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    };

    // Match to user.
    match r {
        Ok(x) => println!("r says \n{}", x),
        Err(e) => println!("{}", e),
    }

    // equivilant:
    let r = read_username_from_file();
    match r {
        Ok(x) => println!("r says \n{}", x),
        Err(e) => println!("{}", e),
    }
}

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();

    File::open("hello.txt")?.read_to_string(&mut s)?;

    Ok(s)
}

// A valid main:
// fn main() -> Result<(), Box<dyn Error>> {
//     let f = File::open("hello.txt")?;
//     Ok(())
// }
