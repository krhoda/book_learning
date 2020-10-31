struct MyType;

unsafe trait UnsafeTrait {
    unsafe fn unsafe_func(&self);
    fn safe_func(&self) {
        println!("All Good!")
    }
}

trait SafeTrait {
    unsafe fn watch_out(&self);
}

unsafe impl UnsafeTrait for MyType {
    unsafe fn unsafe_func(&self) {
        println!("Whew, that was close");
    }
}

impl SafeTrait for MyType {
    unsafe fn watch_out(&self) {
        println!("Another near miss!");
    }
}

fn main() {
    let my_type = MyType;
    // note, even though this comes from
    // a trait labeled unsafe, since
    // the function is not labeled unsafe
    // we can call if outside an unsafe block
    my_type.safe_func();
    unsafe {
        my_type.unsafe_func();
        my_type.watch_out();
    }
}
