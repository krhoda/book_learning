#[derive(Debug)]
struct Items(u32);

#[derive(Debug)]
enum Food {
    Pizza,
    Salad
}

#[derive(Debug)]
enum PaymentMode {
    Bitcoin,
    Credit
}

#[derive(Debug)]
struct Order {
    count: u8,
    item: Food,
    payment: PaymentMode
}

#[derive(Debug)]
struct Container {
    items_count: u32
}

// fn args destructuring:
fn increment_item(Container {ref mut items_count}: &mut Container) {
    *items_count += 1;
}

fn calculate_cost(Container {items_count}: &Container) -> u32 {
    let rate = 67;
    rate * items_count
}

fn main() {
    let precomputed = {
        // declare intermediate values.
        let a = 21;
        let b = 20;
        let c = 1;
        
        // create and return final value.
        a + b + c

        // implicitly drop intermediate values.
    };

    println!("{}", precomputed);

    // Let/If assignment gets around pre-delaration.
    let result = if true {
        let a = 1;
        let b = 2;
        let c = 4;
        a + b + c
    } else {
        1
    };

    println!("{}", result);

    let bad_idea: String;
    
    // would err, linter would catch;
    // println!("{}", bad_idea);

    // NOTE: you can mutate it once.
    bad_idea = "please assign on declaration".to_string();
    println!("{}", bad_idea);

    let mut items = Items(2);

    // read pointer syntax equivilant.
    {
        let items_ptr = &items;
        let ref items_ref = items;
        assert_eq!(items_ptr as *const Items, items_ref as *const Items);
    }

    println!("{}", &items.0);

    // mut pointer syntax equivilant
    {
        let ref mut items_mut_ptr = items;
        items_mut_ptr.0 += 20;
    }

    println!("{}", &items.0);

    let x = &mut items;
    x.0 += 20;

    println!("{}", x.0);

    // invocation of non-borrowed items...
    println!("{}", &items.0);
    // ... causes an implicit drop of x to occur.
    // thus this is now illegal.
    // println!("{}", x.0);

    let mut food_order = Order {
        count: 2,
        item: Food::Salad,
        payment: PaymentMode::Credit
    };

    // Destructuring can use a type to discard the wrapper.
    // Can mutably borrow on right side
    // .. rest operator;
    let Order { count, .. } = &mut food_order;

    println!("{}", count);
    *count += 2;
    println!("{:?}", food_order);

    // Can selectively reference on left side
    // NOTE: Must selective reference for match branches
    let Order {ref payment, ref mut item, ..} = food_order;

    println!("{:?}, {:?}", payment, &item);

    *item = Food::Pizza;

    println!("{:?}", food_order);

    // Enum desctructuring and conditional assignment
    let is_bitcoin = if let PaymentMode::Bitcoin = food_order.payment {
        true
    } else {
        false
    };

    println!("Is bitcoin? {:?}", is_bitcoin);

    let mut container = Container {
        items_count: 10
    };

    increment_item(&mut container);
    let total_cost = calculate_cost(&container);

    println!("{}", total_cost);

    // loop expressions, break is return
    // how Lispy.
    {
        let mut i = 0;
        let counter = loop {
            i += 1;
            if i == 10 {
                break i;
            }
        };

        println!("{}", counter);
    }
    
}
