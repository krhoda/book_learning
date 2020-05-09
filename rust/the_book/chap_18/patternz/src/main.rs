fn main() {
    let x = String::from("wolf");
    match_puppy(&x);

    let x = String::from("dog");
    match_puppy(&x);

    let x = String::from("pup");
    match_puppy(&x);

    let x = String::from("cat");
    match_puppy(&x);

    check_for_seven(Some(7));
    check_for_seven(Some(17));
    check_for_seven(None);

    let mut queue = vec![1, 1, 1, 1, 1, 42];

    while let Some(x) = queue.pop() {
        println!("Queue held {}", x)
    }

    let queue2 = vec![1, 1, 1, 1, 1, 42];

    for (index, value) in queue2.iter().enumerate() {
        println!("{} is at index {}", value, index)
    }

    let x = 'c';

    match x {
        'a'..='j' => println!("early ASCII letter"),
        'k'..='z' => println!("late ASCII letter"),
        _ => println!("something else"),
    }

    let p = Point { x: 0, y: 7 };

    let Point { x: a, y: b } = p;
    assert_eq!(0, a);
    assert_eq!(7, b);

    match p {
        Point { x, y: 0 } => println!("On the x axis at {}", x),
        Point { x: 0, y } => println!("On the y axis at {}", y),
        Point { x, y } => println!("On neither axis: ({}, {})", x, y),
    }

    let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => println!("The Quit variant has no data to destructure."),
        Message::Move { x, y } => {
            println!("Move in the x direction {} and in the y direction {}", x, y);
        }
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => {
            println!("Change the color to red {}, green {}, and blue {}", r, g, b)
        }
    }

    let num = Some(4);

    match num {
        Some(x) if x < 5 => println!("less than five: {}", x),
        Some(x) => println!("{}", x),
        None => (),
    }

    let num = Some(6);

    match num {
        Some(x) if x < 5 => println!("less than five: {}", x),
        Some(x) => println!("{}", x),
        None => (),
    }
}

struct Point {
    x: i32,
    y: i32,
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn match_puppy(x: &str) {
    match x {
        "wolf" => println!("Howl"),
        "dog" | "pup" => println!("Sniff"),
        _ => println!("WAS NOT PASSED A PUPPY"),
    }
}

fn check_for_seven(x: Option<u32>) {
    match x {
        Some(7) => println!("Seven confirmed"),
        Some(x) => println!("This isn't a seven, it's a {}", x),
        None => println!("WHERE IS THE SEVEN?"),
    }
}
