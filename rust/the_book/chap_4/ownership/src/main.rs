fn main() {
    // Mutable string:
    let mut s = String::from("Hello,");
    s.push_str(" world!");

    // this works...
    let x = "hello";
    let x1 = x;
    // ...but x can no longer be used.
    println!("{}, world!", x1);

    // This would fail:
    // let s1 = s;
    // println!("{}", s)
    // Because s was moved.

    // Copy contents:
    let s1 = s.clone();
    // Both are still valid.
    println!("#1: {}\n#2: {}", s, s1);

    // However ints are a little special:
    let a = 3;
    let b = a;
    println!("a = {} b = {}", a, b);
    // 'a wasn't moved, b was pointed to a const (as was 'a).

    demo_diff();

    textbook_example();

    now_with_refs();
    dice_n_slice();
}

fn demo_diff() {
    let s = String::from("sup");
    let n = 555;
    // s and n enter scope.

    pass_with_ownership(s);
    // s has left scope by being passed.

    // this would fail:
    // println!("I still have s: {}", s);

    pass_by_value(n);
    // n was copied and remains in scope.
    println!("I still have n: {}", n);
}

fn pass_with_ownership(some_string: String) {
    println!("{}", some_string);
}

fn pass_by_value(some_int: i32) {
    println!("{}", some_int);
}

fn now_with_refs() {
    let s = String::from("hello");
    let s_len = calc_len(&s);
    // s is not mutable, but remains available.
    println!("s: {}, s_len: {}", s, s_len);

    // Create a mutable DEEP copy.
    let mut mut_s = s.clone();
    println!("{}? {}?", s, mut_s);
    add_world(&mut mut_s);
    println!("{}? {}?", s, mut_s);

    // mut is the key!
    let r1 = &mut_s;
    let r2 = &mut_s;

    // This is now illegal:
    // let r3 = &mut mut_s;
    // That would jeopardize 'rs 1 and 2.
    println!("{}... {}...", r1, r2);

    // yet, if we never re-introduce r1 and r2...
    let mut r3 = &mut mut_s;
    r3.push_str(" Hello again");
    add_world(&mut r3);

    println!("{}", r3);

    // And if we never re-introduce r3 ...
    println!("{}", mut_s);

    // thus don't return explicit references..
    // ... because you already are!
    // pass by copy || (borrow && mutate && conclude)
}

fn calc_len(s: &String) -> usize {
    s.len()
}

fn add_world(s: &mut String) {
    s.push_str(", world!");
}

fn dice_n_slice() {
    let mut s = String::from("Hello World!");
    let word = first_word_index(&s);
    println!("{}", word);

    let hw = String::from("hello world");
    let hello = &hw[..5];
    let world = &hw[6..];
    let hw2 = &hw[..];
    println!("{}! {}! {}! {}!", hw, hello, world, hw2);
    println!(
        "{}, {}, {}, {}!",
        first_word(&hw),
        first_word(&hello),
        first_word(&hw2),
        first_word(&world)
    );

    let hello = first_word(&hw);
    // this would make the following println! illegal:
    // hw.clear()
    println!("{}!!!", hello);
}

fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    for (i, &rune) in bytes.iter().enumerate() {
        if rune == b' ' {
            return &s[..i];
        }
    }

    return &s[..];
}

fn first_word_index(s: &String) -> usize {
    let bytes = s.as_bytes();
    for (i, &rune) in bytes.iter().enumerate() {
        if rune == b' ' {
            return i;
        }
    }

    return s.len();
}

// c & P from the book:
fn textbook_example() {
    // Thanks Rust book:

    let s1 = gives_ownership();
    // gives_ownership moves its return
    // value into s1

    let s2 = String::from("hello");
    // s2 comes into scope

    let s3 = takes_and_gives_back(s2);
    // s2 is moved into
    // takes_and_gives_back, which also
    // moves its return value into s3

    // Thus this works ...
    println!("s1: {}", s1);
    // ... this doesn't ...
    // println!("s2: {}", s2);
    // ... but this does
    println!("s3: {}", s3);
}

// C & P from the book:
fn gives_ownership() -> String {
    // gives_ownership will move its
    // return value into the function
    // that calls it

    let some_string = String::from("hello"); // some_string comes into scope

    some_string
    // some_string is returned and
    // moves out to the calling
    // function
}

// C & P from the book:
// takes_and_gives_back will take a String and return one
fn takes_and_gives_back(a_string: String) -> String {
    // a_string comes into
    // scope

    a_string // a_string is returned and moves out to the calling function
}
