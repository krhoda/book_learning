#[macro_use]
extern crate criterion;
extern crate criterion_demo;

use criterion_demo::{fast_fib, slow_fib};
use criterion::Criterion;

fn fibonacci_benchmark(c: &mut Criterion) {
    c.bench_function("fibonacci 8", |b| b.iter(|| slow_fib(8)));
}

criterion_group!(fib_bench, fibonacci_benchmark);
criterion_main!(fib_bench);