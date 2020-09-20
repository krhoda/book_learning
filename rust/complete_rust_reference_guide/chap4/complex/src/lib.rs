use std::ops::Add;
use std::convert::From;
use std::fmt::{Formatter, Display, Result};

#[derive(Default)]
pub struct Complex<T> {
    re: T,
    im: T
}

impl<T> Complex<T> {
    fn new(re: T, im: T) -> Self {
        Self { re, im }
    }
}

impl<T: Add<T, Output=T>> Add for Complex<T> {
    type Output = Complex<T>;
    fn add(self, rhs: Complex<T>) -> Self::Output {
        Complex {re: self.re + rhs.re, im: self.im + rhs.im}
    }
}

impl<T> From<(T, T)> for Complex<T> {
    fn from(value: (T, T)) -> Complex<T> {
        Complex {re: value.0, im: value.1 }
    }
}

impl<T: Display> Display for Complex<T> {
    fn fmt(&self, f: &mut Formatter) -> Result {
        write!(f, "{} + {}i", self.re, self.im)
    }
}

#[cfg(test)]
mod tests {
    use super::Complex;
    #[test]
    fn complex_basics() {
        let fst = Complex::new(3,5);
        let snd = Complex::<i32>::default();

        assert_eq!(fst.re, 3);
        assert_eq!(fst.im, 5);
        assert_eq!(snd.re, snd.im)
    }

    #[test]
    fn complex_addition() {
        let a = Complex::<i32>::new(1, -2);
        let b = Complex::<i32>::default();
        let c = a + b;

        assert_eq!(c.re, 1);
        assert_eq!(c.im, -2);

        let x = Complex::<i32>::new(111, 222);
        let y = Complex::<i32>::new(222, 111);
        let z = x + y;

        assert_eq!(z.re, 333);
        assert_eq!(z.im, 333);
    }

    #[test]
    fn complex_from() {
        let a = (111, 222);
        let complex = Complex::from(a);

        assert_eq!(complex.re, 111);
        assert_eq!(complex.im, 222);
    }

    #[test]
    fn complex_display() {
        let my_im =Complex::new(111, 222);
        println!("{}", my_im);
    }
}