fn give_me<T>(val: T) {
    let _ = val;
}

struct GenStruct<T>(T);

impl<T> GenStruct<T> {
    pub fn new(x: T) -> Self {
        GenStruct(x)
    }
}

fn main() {
    let a = "generics";
    let b = 1024;
    let z = GenStruct::new(b);
    give_me(a);
    give_me(b);
    give_me(z);

    // providing a type
    let v1: Vec<u8> = Vec::new();

    // or calling method
    let mut v2 = Vec::new();
    v2.push(2);    // v2 is now Vec<i32>

    // or using turbofish
    let v3 = Vec::<u8>::new();    // not so readable
}
