fn main() {
    let mut v = vec![1, 2, 3];
    println!("After creation {:?}", &v);
    for i in v.iter() {
        println!("{:?}", i);
    }
    println!("After .iter(), by read ref {:?}", &v);

    for i in v.iter_mut() {
        *i = *i + 1;
    }
    println!("After .iter_mut(), by read ref {:?}", &v);

    let z: Vec<i32> = v.into_iter().map(|x| x * x).collect();
    println!("After .into_iter(), vector is consumed, now is z: {:?}", z);

    let primes = Primes::new(100);
    for i in primes.iter() {
        println!("{}", i);
    }

    let mut a = String::from("Yo");
    // Type Fn
    let fn_closure = || {
        println!("Using var by ref {}", a);
    };

    fn_closure();
    println!("Var is still in outer scope {}", a);

    // Type FnMut
    let mut fn_mut_closure = || {
        a.push_str("lo");
    };

    fn_mut_closure();
    println!("Var in outer scope after mut closure {}", a);

    // Type FnOnce
    let consume = |x: String| {
        println!("Moving and dropping {}", x)
    };

    consume(a);
    // a is now dropped.
    
    let c_one = Circle { rad: 4.2 };
    let c_two = Circle { rad: 75.2 };
    // Usage of nested Consts:
    println!("Area of circle one: {}", c_one.area());
    println!("Area of circle two: {}", c_two.area());
}

trait Circular {
    const PI: f64 = 3.14;
    fn area(&self) -> f64;
}

struct Circle {
    rad: f64
}

impl Circular for Circle {
    fn area(&self) -> f64 {
        Circle::PI * self.rad * self.rad
    }
}

struct Primes {
    limit: usize,
}

impl Primes {
    fn iter(&self) -> PrimesIter {
        PrimesIter {
            index: 2,
            computed: compute_primes(self.limit),
        }
    }

    fn new(limit: usize) -> Primes {
        Primes { limit }
    }
}

struct PrimesIter {
    index: usize,
    computed: Vec<bool>
}

impl Iterator for PrimesIter {
    type Item = usize;
    fn next(&mut self) -> Option<Self::Item> {
        loop {
            self.index += 1;
            if self.index > self.computed.len() -1 {
                return None;
            } else if self.computed[self.index] {
                return Some(self.index);
            } else {
                continue;
            }
        }
    }
}

fn compute_primes(limit: usize) -> Vec<bool> {
    let mut sieve = vec![true; limit];
    let mut m = 2;
    while (m * m) < limit {
        if sieve[m] {
            for i in (m * 2..limit).step_by(m) {
                sieve[i] = false;
            }
        }
        m += 1;
    }
    sieve
}