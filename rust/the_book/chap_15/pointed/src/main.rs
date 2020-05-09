use std::cell::RefCell;
use std::ops::Deref;
use std::rc::{Rc, Weak};

enum Lisp {
    Cons(i32, Rc<Lisp>),
    Nil,
}

struct Cardboard<T>(T);

impl<T> Cardboard<T> {
    fn new(x: T) -> Cardboard<T> {
        Cardboard(x)
    }
}

impl<T> Deref for Cardboard<T> {
    type Target = T;
    fn deref(&self) -> &T {
        &self.0
    }
}

impl<T> Drop for Cardboard<T> {
    fn drop(&mut self) {
        println!("Drop that box");
    }
}

use crate::Lisp::{Cons, Nil};

fn main() {
    let b = Box::new(5);
    println!("b = {}", b);

    let _l = Cons(1, Rc::new(Cons(2, Rc::new(Cons(3, Rc::new(Nil))))));

    let x1 = 5;
    let y1 = &x1;

    assert_eq!(5, x1);
    assert_eq!(5, *y1);

    let x2 = 5;
    let y2 = Box::new(x2);

    assert_eq!(5, x2);
    assert_eq!(5, *y2);

    let x3 = 5;
    let y3 = Cardboard::new(x3);

    assert_eq!(5, x3);
    assert_eq!(5, *y3);

    let c = Cardboard::new(String::from("Cardboard"));
    greeter(&c);

    let d = Cardboard::new(String::from("Drop Me."));
    drop(d);

    println!("Main continues.");

    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    println!("count after creating a = {}", Rc::strong_count(&a));
    let _b = Cons(3, Rc::clone(&a));
    println!("count after creating b = {}", Rc::strong_count(&a));
    {
        let _c = Cons(4, Rc::clone(&a));
        println!("count after creating c = {}", Rc::strong_count(&a));
    }
    println!("count after c goes out of scope = {}", Rc::strong_count(&a));
    odd_mutation();
    mem_leak_demo();
    run_branches();
}

fn greeter(name: &str) {
    println!("Hello, {}!", name);
}

#[derive(Debug)]
enum List {
    LCons(Rc<RefCell<i32>>, Rc<List>),
    LNil,
}

use crate::List::{LCons, LNil};

fn odd_mutation() {
    let value = Rc::new(RefCell::new(5));

    let a = Rc::new(LCons(Rc::clone(&value), Rc::new(LNil)));

    let b = LCons(Rc::new(RefCell::new(6)), Rc::clone(&a));
    let c = LCons(Rc::new(RefCell::new(10)), Rc::clone(&a));

    *value.borrow_mut() += 10;

    println!("a after = {:?}", a);
    println!("b after = {:?}", b);
    println!("c after = {:?}", c);
}

use crate::BList::{BCons, BNil};

#[derive(Debug)]
enum BList {
    BCons(i32, RefCell<Rc<BList>>),
    BNil,
}

impl BList {
    fn tail(&self) -> Option<&RefCell<Rc<BList>>> {
        match self {
            BCons(_, item) => Some(item),
            BNil => None,
        }
    }
}

fn mem_leak_demo() {
    let a = Rc::new(BCons(5, RefCell::new(Rc::new(BNil))));

    println!("a initial rc count = {}", Rc::strong_count(&a));
    println!("a next item = {:?}", a.tail());

    let b = Rc::new(BCons(10, RefCell::new(Rc::clone(&a))));

    println!("a rc count after b creation = {}", Rc::strong_count(&a));
    println!("b initial rc count = {}", Rc::strong_count(&b));
    println!("b next item = {:?}", b.tail());

    if let Some(link) = a.tail() {
        *link.borrow_mut() = Rc::clone(&b);
    }

    println!("b rc count after changing a = {}", Rc::strong_count(&b));
    println!("a rc count after changing a = {}", Rc::strong_count(&a));

    // Uncomment the next line to see that we have a cycle;
    // it will overflow the stack
    // println!("a next item = {:?}", a.tail());
}

#[derive(Debug)]
struct Node {
    children: RefCell<Vec<Rc<Node>>>,
    parent: RefCell<Weak<Node>>,
    value: i32,
}


fn run_branches() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!("Leaf -> Parent = {:?}", leaf.parent.borrow().upgrade());

    let branch = Rc::new(Node {
        value: 5,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });

    // Weak just wraps in maybe.
    *leaf.parent.borrow_mut() = Rc::downgrade(&branch);
    println!("Leaf -> Parent = {:?}", leaf.parent.borrow().upgrade());
}
