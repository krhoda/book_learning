use std::collections::HashMap;
use std::hash::Hash;
use std::thread;
use std::time::Duration;
// You got logical programming in my imperative programming!
// You got functional programming in my logical programming!
// You got imperative programming in my functional programming!
// Now we all have headaches.

// Closures are sort of Prolog/Occam style statements that take args and return values.
// -- if that means anything you.
// Check it out!

fn main() {
    let i = 10;
    let r = 7;
    generate_workout(i, r);
    vectorz();
    iterz();
}

fn generate_workout(intensity: u32, random_number: u32) {
    // let expensive_closure = |&num| {
    //     println!("Calculating slowly...");
    //     thread::sleep(Duration::from_secs(2));
    //     num
    // };

    let mut expensive_result = Cacher::new(|&num| {
        println!("Calculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    });

    if intensity < 25 {
        println!("Today, do {} pushups!", expensive_result.value(&intensity));

        println!("Next, do {} situps!", expensive_result.value(&intensity));
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_result.value(&intensity)
            );
        }
    }
}

struct Cacher<T, U, V>
where
    T: Fn(&U) -> V,
    U: Hash + Eq,
{
    calculation: T,
    cache_map: HashMap<U, V>,
}

impl<T, U, V> Cacher<T, U, V>
where
    T: Fn(&U) -> V,
    U: Hash + Eq,
    V: Clone,
{
    fn new(calculation: T) -> Cacher<T, U, V> {
        Cacher {
            calculation,
            cache_map: HashMap::new(),
        }
    }

    fn value(&mut self, arg: U) -> V
    where
        T: Fn(&U) -> V,
        U: Hash + Eq,
        V: Clone,
    {
        match self.cache_map.get(&arg) {
            Some(v) => v.clone(),
            None => {
                let v = (self.calculation)(&arg);
                self.cache_map.insert(arg, v.clone());
                v
            }
        }
    }
}
// Vector Fun.

fn vectorz() {
    let v1 = vec![1, 2, 3];
    let v1i = v1.iter();

    for val in v1i {
        println!("Got: {}", val);
    }

    let v2 = vec![1, 2, 3];
    let v2i = v2.iter();
    let v2sum: i32 = v2i.sum();
    println!("Sum: {}", v2sum);

    let v3 = vec![4, 5, 6];
    let mut v3i = v3.iter();

    assert_eq!(v3i.next(), Some(&4));
    assert_eq!(v3i.next(), Some(&5));
    assert_eq!(v3i.next(), Some(&6));
    assert_eq!(v3i.next(), None);

    println!("Still alive after Vectorz");
}

fn iterz() {
    let v1: Vec<i32> = vec![1, 2, 3];

    let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();

    assert_eq!(v2, vec![2, 3, 4]);
    println!("Lived through Iterz.")
}

#[test]
fn call_with_different_values() {
    let mut c = Cacher::new(|&a| a);

    let v1 = c.value(1);
    let v2 = c.value(12);

    assert_eq!(v1, 1);
    assert_eq!(v2, 12);

    let mut s = Cacher::new(|x: &String| x.len());

    let v3 = s.value(String::from("Hello"));
    let v4 = s.value(String::from("Goodbye"));

    assert_eq!(v3, 5);
    assert_eq!(v4, 7);
}

// Shoes and Tests from the book:

#[derive(PartialEq, Debug)]
struct Shoe {
    size: u32,
    style: String,
}

fn shoes_in_my_size(shoes: Vec<Shoe>, shoe_size: u32) -> Vec<Shoe> {
    // This is a concise mapping pattern
    shoes.into_iter()
        .filter(|s| s.size == shoe_size)
        .collect()
}

#[test]
fn filters_by_size() {
    let shoes = vec![
        Shoe { size: 10, style: String::from("sneaker") },
        Shoe { size: 13, style: String::from("sandal") },
        Shoe { size: 10, style: String::from("boot") },
    ];

    let in_my_size = shoes_in_my_size(shoes, 10);

    assert_eq!(
        in_my_size,
        vec![
            Shoe { size: 10, style: String::from("sneaker") },
            Shoe { size: 10, style: String::from("boot") },
        ]
    );
}

struct Counter {
    count: u32
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        self.count += 1;

        // Because...
        if self.count < 6 {
            Some(self.count)
        } else {
            None
        }
    }
}

#[test]
fn use_counter() {
    let mut counter = Counter::new();

    assert_eq!(counter.next(), Some(1));
    assert_eq!(counter.next(), Some(2));
    assert_eq!(counter.next(), Some(3));
    assert_eq!(counter.next(), Some(4));
    assert_eq!(counter.next(), Some(5));
    assert_eq!(counter.next(), None);
}

#[test]
fn use_counter_sum() {
    let sum: u32 = Counter::new()
    .zip(Counter::new().skip(1))
    .map(|(a, b)| a * b)
    .filter(|x| x % 3 == 0)
    .sum();

    assert_eq!(18, sum)
}