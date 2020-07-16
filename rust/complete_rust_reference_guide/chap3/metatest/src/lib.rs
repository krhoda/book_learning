#![feature(test)]

extern crate test;

use test::Bencher;

/// Single line Item Doc Strings should look like this.
///   ```
///   let x = metatest::sum(2, 1);
///   assert_eq!(x, 3);
///   ```
pub fn sum(a: i8, b: i8) -> i8 {
    a + b
}

/** Multi line Item Doc Strings should look 
 * like
 * this
 * TODO: Learn how to do doc tests here?
 */
pub fn unsum(a: i8, b: i8) -> i8 {
    a - b
}

pub fn do_nothing_slowly() {
    print!(".");
    for _ in 1..10_000_000 {};
}

pub fn do_nothing_fast() {
}

#[bench]
fn bench_nothing_slowly(b: &mut Bencher) {
    b.iter(|| do_nothing_slowly());
}

#[bench]
fn bench_nothing_fast(b: &mut Bencher) {
    b.iter(|| do_nothing_fast());
}

#[cfg(test)]
mod tests {
    fn sum_inputs_outputs() -> Vec<((i8, i8), i8)> {
        vec![((1, 1), 2), ((0, 0), 0), ((2, -2), 0)]
    }

    #[test]
    fn test_sums() {
        for (input, output) in sum_inputs_outputs() {
            assert_eq!(crate::sum(input.0, input.1), output);
        }
    }
}
