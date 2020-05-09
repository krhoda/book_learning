fn main() {
    let num_list = vec![1, 3, 100, 7, 42];

    let mut largest = num_list[0];

    for num in &num_list {
        if num > &largest {
            largest = *num;
        }
    }
    println!("Hello, largest number: {}", largest);

    largest = get_largest(&num_list);
    println!("Hello, largest number: {}", largest);

    let pt1 = Point { x: 4, y: 15 };
    let pt2 = Point { x: -1, y: 4.5 };
    println!("Pt1: {}, {}\nPt2: {}, {}", pt1.x, pt1.y, pt2.x, pt2.y);

    let twt1 = Tweet {
        username: String::from("puppy"),
        content: String::from("woof"),
        reply: false,
        retweet: false,
    };

    notify(twt1);

    // force fallback
    notify(pt1.x);

    largest = gen_largest(&num_list);
    println!("Hello, largest number: {}", largest);

    let x = gen_largest(&["a", "z", "b"]);
    println!("Hello, largest letter: {}", x);

    let a = String::from("Hello");
    let b = String::from("Hola");
    let c = longest_with_an_announcement(&a, &b, "Yo!");
    println!("c: {}", c)
}

fn get_largest(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

// Generic Point:
struct Point<T, U> {
    x: T,
    y: U,
}

trait Summary {
    // Fall back with no custom impl.
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}

impl Summary for i32 {
    // will use fallback
}

struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

fn notify(item: impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

fn gen_largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

// Worth noting:
// fn some_function<T, U>(t: T, u: U) -> i32
// where T: Display + Clone,
//       U: Clone + Debug
// {...}

use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}

// Explicit lifetimes to help compiler:
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn longest_with_an_announcement<'a, T>(x: &'a str, y: &'a str, ann: T) -> &'a str
where
    T: Display,
{
    println!("Announcement! {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
