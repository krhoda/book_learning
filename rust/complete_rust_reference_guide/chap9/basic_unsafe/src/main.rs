fn get_value(i: *const i32) -> i32 {
    // unsafe is required to de-reference
    unsafe { *i }
}

// can mark a whole func as unsafe ...
unsafe fn also_get_value(i: *const i32) -> i32 {
    *i
}

fn main() {
    let foo = &1024 as *const i32;
    let foo2 = &1024 as *const i32;
    // this looks safe but isn't
    let bar = get_value(foo);

    // ...but we need an unsafe block here.
    // that seems preferable to hiding it inside of get_value
    let baz = unsafe { also_get_value(foo2) };

    println!("{}", bar);
    println!("{}", baz);

    // Blow it up by passing a non-pointer.
    let y = get_value(4 as *const i32);

    // will segfault before printing this.
    println!("{}", y);

    // this would also blow up, but at least it's labeled.
    let _x = unsafe { also_get_value(4 as *const i32) };
}
