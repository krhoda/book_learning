fn main() {
    let w1 = 30;
    let h1 = 50;

    println!(
        "The area of the rectangle is {} square pixels.",
        area1(w1, h1)
    );

    let t1 = (w1, h1);
    println!("The area of the rectangle is {} square pixels.", area2(t1));

    let r1 = Rect {
        width: w1,
        height: h1,
    };
    println!("The area of the rectangle is {} square pixels.", area3(&r1));
    println!("DERIVING: {:?}", r1);
    println!("The area of the rectangle is {} square pixels.", r1.area());
    let r2 = Rect {
        width: 10,
        height: 40,
    };

    let r3 = Rect {
        width: 60,
        height: 45,
    };

    println!("Can r1 hold r2? {}", r1.can_hold(&r2));
    println!("Can r1 hold r3? {}", r1.can_hold(&r3));
    let sq1 = Rect::make_square(10);
    println!("Square is: {:?}", sq1);
    println!("Can r1 hold sq1? {}", r1.can_hold(&sq1));
}

fn area1(width: u32, height: u32) -> u32 {
    width * height
}

fn area2(dimensions: (u32, u32)) -> u32 {
    let (width, height) = dimensions;
    width * height
}

fn area3(r: &Rect) -> u32 {
    &r.width * &r.height
}

#[derive(Debug)]
struct Rect {
    width: u32,
    height: u32,
}

impl Rect {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rect) -> bool {
        self.width > other.width && self.height > other.height
    }

    fn make_square(size: u32) -> Rect {
        Rect {
            width: size,
            height: size,
        }
    }
}
