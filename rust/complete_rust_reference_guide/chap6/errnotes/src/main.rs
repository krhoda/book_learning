use std::collections::HashMap;
use std::fs::File;
use std::io::Read;
use std::path::Path;


fn main() {
    file_results();
    map_panic();
    println!("Hello, world!");
}

fn file_results() {
    let path = Path::new("data.txt");
    let mut file = match File::open(&path) {
        Ok(file) => file,
        Err(err) => panic!("Error while opening file: {}", err),
    };

    let mut s = String::new();
    // Will panic if "data.txt doesn't exist"
    let _ = file.read_to_string(&mut s);
    println!("Message: {}", s);
}

fn map_panic() {
    let mut m = HashMap::new();
    m.insert("one", 1);
    m.insert("two", 2);
    // works:
    let contrived_two = m.get("one").unwrap() + 1;
    let contrived_three = m.get("two").unwrap() + 1;
    assert_eq!(contrived_two, 2);
    assert_eq!(contrived_three, 3);

    // Just panic!
    // let inc_val = m.get("three").unwrap() + 1;
    // Same but says something useful
    let inc_val = m.get("three").expect("WHERE IS THREE?") + 1;
    println!("This will never print: {}", inc_val);
}
