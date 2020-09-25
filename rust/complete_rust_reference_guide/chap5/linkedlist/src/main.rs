use std::rc::Rc;
use std::rc::Weak;
use std::cell::RefCell;

#[derive(Debug)]
struct LinkedList<T> {
    head: Option<Rc<LinkedListNode<T>>>
}

#[derive(Debug)]
struct LinkedListNode<T> {
    next: Option<Rc<LinkedListNode<T>>>,
    // Use RefCell to allow downgrading
    // Otherwise, reference cycles will occur.
    prev: RefCell<Option<Weak<LinkedListNode<T>>>>,
    data: T
}

impl<T> LinkedList<T> {
    fn new() -> Self {
        LinkedList { head: None }
    }

    fn append(&mut self, data: T) -> Self {
        let new_node = Rc::new(LinkedListNode {
            // Add data.
            data: data,
            // Shift list to back.
            next: self.head.clone(),
            // Set None to the head's prev.
            prev: RefCell::new(None)
        });

        match self.head.clone() {
            Some(node) => {
                // Make previous a mutable reference for current head.
                let mut prev = node.prev.borrow_mut();
                // Set current head's previous entry to the new entry
                *prev = Some(Rc::downgrade(&new_node));
            },
            _ => {}
        }

        LinkedList {
            // Set new node at head.
            head: Some(new_node)
        }
    }
}

fn main() {
    let list_of_nums = LinkedList::new().append(1).append(2).append(3);
    let list_of_strs = LinkedList::new().append("I").append("II").append("III");
    println!("Hello, world!");

    println!("Nums: {:?}", list_of_nums);
    println!("Strs: {:?}", list_of_strs)
}
