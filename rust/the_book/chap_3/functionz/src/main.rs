fn main() {
    let a: i32 = 3;
    echo_int32(a);

    let b: i32 = 9;
    let c = rusty_add(a, b);
    echo_int32(c);

    let dynamic_assign = true;
    let which = if dynamic_assign { 1 } else { 0 };

    let where_is = if which > 0 { true } else { false };

    println!("this makes sense {}", where_is);
    let four = rusty_add(rusty_add(which, which), rusty_add(which, which));
    println!("4 = {}", four);
    let mut accumulator = 0;

    let accumlated_and_doubled = loop {
        accumulator += 1;

        if accumulator == 10 {
            break accumulator * 2; // note the implicit return
        }
    };

    println!(
        "Loops are values? {}",
        accumlated_and_doubled == (accumulator * 2),
    );

    let mut decrementer = 10;
    while decrementer > 0 {
        println!("{}", decrementer);
        decrementer = dec(decrementer);
    }

    println!("End decrementer.\nStart fib interator");

    let my_array = [1, 2, 4, 6, 10, 16];
    for fib in my_array.iter() {
        println!("{}", fib);
    }

    rocket_countdown();
}

fn rocket_countdown() {
    println!("START COUNTDOWN:");
    for n in (1..11).rev() {
        println!("{}", n);
    }
    println!("LIFT OFF!");
}

fn echo_int32(x: i32) -> i32 {
    println!("{}", x);
    x
}

fn rusty_add(x: i32, y: i32) -> i32 {
    if x == 0 {
        y
    } else {
        rusty_add(dec(x), inc(y))
    }
}

fn inc(x: i32) -> i32 {
    x + 1
}

fn dec(x: i32) -> i32 {
    x - 1
}
