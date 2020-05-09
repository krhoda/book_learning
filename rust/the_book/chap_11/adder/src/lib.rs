#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }

    #[test]
    fn larger_can_hold_smaller() {
        let larger = Rectangle {
            width: 5,
            height: 5,
        };

        let smaller = Rectangle {
            width: 4,
            height: 4,
        };

        assert!(larger.can_hold(&smaller));
    }

    #[test]
    fn greeting_contains_name() {
        let result = greeting("pal");
        // Standard assert!
        // assert!(result.contains("pal"));

        // Custom message:
        assert!(
            result.contains("pal"),
            "Greeting did not contain name, value was {}",
            result
        );
    }

    #[test]
    #[should_panic]
    fn greater_than_100() {
        Guess::new(101);
    }

    #[test]
    fn sanity_check() -> Result<(), String> {
        if 2 + 2 == 5 {
            Ok(())
        } else {
            Err(String::from("two plus two does not equal four"))
        }
    }

    #[test]
    #[ignore]
    fn expensive_test() {
        // code that takes an hour to run
    }
}

pub fn add_two(x: i32) -> i32 {
    x + 2
}

#[derive(Debug)]
pub struct Rectangle {
    width: u32,
    height: u32,
}

// impl doesn't need to be made pub.
// TODO: find out why. Does it inherit from struct?
impl Rectangle {
    // Making this public makes the "dead code" warning go away, being a public interface and all.
    pub fn can_hold(&self, other: &Rectangle) -> bool {
        // Pass the test.
        self.width > other.width && self.height > other.height
        // Break the test:
        // self.width < other.width && self.height < other.height
    }
}

pub fn greeting(name: &str) -> String {
    format!("Hello {}!", name)
}

pub struct Guess {
    value: i32,
}

impl Guess {
    pub fn new(value: i32) -> Guess {
        if value < 1 || value > 100 {
            panic!("Guess value must be between 1 and 100, got {}.", value);
        }

        Guess { value }
    }
}
