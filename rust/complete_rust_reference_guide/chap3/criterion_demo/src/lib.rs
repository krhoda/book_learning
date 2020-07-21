pub fn slow_fib(nth: usize) -> u64 {
    if nth <= 1 {
        nth as u64
    } else {
        slow_fib(nth - 1) + slow_fib(nth - 2)
    }
}

pub fn fast_fib(nth: usize) -> u64 {
    let (mut a, mut b, mut c) = (0, 1, 0);
    for _ in 1..nth {
        c = a + b;
        a = b;
        b = c;
    }
    c
}