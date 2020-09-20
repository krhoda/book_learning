fn give_me<T>(val: T) {
    let _ = val;
}

struct GenStruct<T>(T);

impl<T> GenStruct<T> {
    pub fn new(x: T) -> Self {
        GenStruct(x)
    }
}

trait Vehicle {
    fn get_price(&self) -> u64;
}

trait Car: Vehicle {
    fn model(&self) -> String;
}

struct FordPinto {
    model: String,
    is_safe: bool
}

impl FordPinto {
    fn new(model: &str) -> Self {
        Self { model: model.to_string(), is_safe: false }
    }
}

impl Vehicle for FordPinto {
    fn get_price(&self) -> u64 {
        2
    }
}

impl Car for FordPinto {
    fn model(&self) -> String {
        self.model.clone()
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

    let my_pinto = FordPinto::new("Ford Pinto Mk.1");
    println!(
        "{} is priced at ${}, is that even safe? {}",
        my_pinto.model(), 
        my_pinto.get_price(),
        my_pinto.is_safe
    )
}
