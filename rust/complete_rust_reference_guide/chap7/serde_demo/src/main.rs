use serde_derive::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
struct Foo {
    a: String,
    b: u64
}

impl Foo {
    fn new(a: &str, b: u64) -> Self {
        Self {
            a: a.to_string(),
            b
        }
    }
}

fn main() {
    println!("Hello, world!");
    let jfoo = serde_json::to_string(&Foo::new("Tada", 123)).unwrap();
    println!("{:?}", jfoo);
    let vfoo: Foo = serde_json::from_str(&jfoo).unwrap();
    println!("{:?}", vfoo);
}
