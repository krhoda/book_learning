use std::collections::HashMap;

fn main() {
    println!("Hello, vectors!");
    let mut v: Vec<i32> = Vec::new();
    v.push(4);
    v.push(5);
    v.push(6);
    print_int_vec(&v);

    let mut v = vec![1, 2, 3];
    print_int_vec(&v);
    v.push(4);
    v.push(5);

    let x: &i32 = &v[2];
    // cannot:
    // v.push(7)
    // as x is borrow and about to be used:
    println!("{}", x);

    // get style:
    match v.get(2) {
        Some(x) => println!("{}", x),
        None => println!("nuthin!"),
    }

    match v.get(100) {
        Some(x) => println!("{}", x),
        None => println!("nuthin!"),
    }

    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];

    print_spread_vec(&row);

    // Strings aren't indexed by char, they are indexed by byte:
    let my_string = String::from("hello");
    let my_bytes = &my_string[0..1];
    println!("{}", my_bytes);

    // Use char to get at the UTF8 glyph. Works with ASCII.
    for my_char in my_string.chars() {
        println!("{}", my_char);
    }

    // Erlang style:
    for my_byte in my_string.bytes() {
        println!("{}", my_byte);
    }

    let mut scores = HashMap::new();
    scores.insert(String::from("Blues"), 10);
    scores.insert(String::from("Greens"), 11);

    let teams = vec![String::from("Blue"), String::from("Green")];
    let next_scores = vec![10, 11];
    let mut final_scores: HashMap<_, _> = teams.iter().zip(next_scores.iter()).collect();

    let reds = String::from("Red");
    let x = 9;

    // Explicit Borrows are Required:
    final_scores.insert(&reds, &x);

    let mut sample_map = HashMap::new();
    let sample_key = "north";
    let sample_value = "pole";

    // But not there ...
    sample_map.insert(sample_key, sample_value);

    // Insert consumes the value, but above, they must be borrowed ...?
    // Either can be borrowed though:
    sample_map.insert(&reds, &reds);

    // .entry() provides chain-able safe access.

    // Create if does not exist.
    sample_map.entry("Yellow").or_insert("100");
    // Do not create if does.
    sample_map.entry("Red").or_insert("RED");

    println!("{:?}", sample_map);

    let text = "hello strange cyberpunk future";
    let mut hello_map = HashMap::new();

    for word in text.split_whitespace() {
        let count = hello_map.entry(word).or_insert(0);
        *count += 1;
    }

    println!("{:?}", hello_map);
}

fn print_int_vec(v: &Vec<i32>) {
    for i in v {
        print!("{},", i)
    }

    println!("")
}

fn print_spread_vec(v: &Vec<SpreadsheetCell>) {
    for i in v {
        match i {
            SpreadsheetCell::Int(x) => print!("{},", x),
            SpreadsheetCell::Float(x) => print!("{},", x),
            SpreadsheetCell::Text(x) => print!("{},", x),
        }
    }

    println!("")
}

enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}
