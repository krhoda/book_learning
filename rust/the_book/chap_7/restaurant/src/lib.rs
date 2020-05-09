#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}

// NOTE: Lots of C&P here.
mod front_of_house1 {
    pub mod hosting {
        pub fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}

pub fn eat_at_restaurant1() {
    // Abs. Path:
    // crate::front_of_house1::hosting::add_to_waitlist();

    // Relative path
    front_of_house1::hosting::add_to_waitlist();
}

fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        // super leaps up a scope, in this case to crate
        super::serve_order();
    }

    fn cook_order() {}
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    pub enum Appetizer {
        Soup,
        Salad,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}

pub fn eat_at_restaurant() {
    // Order a breakfast in the summer with Rye toast
    let mut meal = back_of_house::Breakfast::summer("Rye");
    // Change our mind about what bread we'd like
    meal.toast = String::from("Wheat");
    println!("I'd like {} toast please", meal.toast);

    // The next line won't compile if we uncomment it; we're not allowed
    // to see or modify the seasonal fruit that comes with the meal
    // meal.seasonal_fruit = String::from("blueberries");

    let order1 = back_of_house::Appetizer::Soup;
    let order2 = back_of_house::Appetizer::Salad;
}

mod front_of_house2 {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

// pub is used to "re-export" use statements
// TODO: Understand better.
pub use crate::front_of_house2::hosting;

pub fn eat_at_restaurant2() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}

// DO AS I SAY --
// -- NOT THIS:
use crate::front_of_house2::hosting::add_to_waitlist;

pub fn unidomatic_eat_at_restaurant() {
    add_to_waitlist();
    add_to_waitlist();
    add_to_waitlist();
}

// this is better.
use crate::front_of_house2::hosting::add_to_waitlist as add_it;
pub fn eat_it() {
    add_it();
}

// this is legal
use crate::{
    self as this_is_this, back_of_house as x_back_of_house, front_of_house1 as x_front_of_house1,
};

pub fn list_demo() {
    let x = x_back_of_house::Appetizer::Soup;
    let y = x_front_of_house1::hosting::add_to_waitlist();
}

// this is legal too:
// use crate::*;
