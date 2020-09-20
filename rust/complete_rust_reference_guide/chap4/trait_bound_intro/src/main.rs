use std::ops::Add;
use std::fmt::Display;

struct Game;
struct Enemy;
struct AntiHero;

trait Loadable {
    fn init(&self);
}

impl Loadable for Enemy {
    fn init(&self) {
        println!("Enemy loaded");
    }
}

impl Loadable for AntiHero {
    fn init(&self) {
        println!("AnitHero loaded");
    }
}

impl Game {
    fn load<T : Loadable>(&self, entity: T) {
        entity.init();
    }
}

fn add_stuff<T: Add>(fst: T, snd: T) -> T::Output {
    fst + snd
}

// Without generics
fn show_me(val: impl Display) {
    println!("{}", val);
}

// can return this way too
fn lispify(val: impl Display) -> impl Display {
    format!("({})", val)
}

// Weird Lazy Curry Trick
fn lazy_add<T: Add + Copy>(a: T, b: T) -> impl Fn() -> T::Output {
    move || a + b
}

fn main() {
    let game = Game;
    game.load(Enemy);
    game.load(AntiHero);

    let four = add_stuff(2, 2);
    println!("{}", four);
    show_me("Here's another way to do polymorphism");
    let add_later = lazy_add(1000, 2000);
    println!("{:?}", add_later());
    let write_lisp = lispify(format!("lambda {} {}", lispify("x"), lispify("x")));
    println!("{}", write_lisp);
}
