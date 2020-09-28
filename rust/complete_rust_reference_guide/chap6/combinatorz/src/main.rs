fn main() {
    let g_r: Result<i64, String> = Ok(1);
    let b_r: Result<i64, String> = Err("This is bad".to_string());
    let g_o: Option<i64> = Some(2);
    let b_o: Option<i64> = None;

    let _ = g_r
        .as_ref()
        .map(|x| println!("Will be positive one: {}", x));
    // NOTE: Only for Result.
    let _ = b_r
        .as_ref()
        .map_err(|x| println!("Will be a negative statement: {}", x));

    {
        // Works for both result and Option
        // Takes success value, maps in.
        let my_two = g_r.as_ref().and_then(|x| Ok(x + x));
        match my_two {
            Ok(x) => println!("This will print: {}", x),
            Err(x) => println!("This won't: {}", x),
        }

        // Returns failure value
        let my_negative_statement = b_r.as_ref().and_then(|x| Ok(x + x));
        match my_negative_statement {
            Err(x) => println!("This will print: {}", x),
            Ok(x) => println!("This won't: {}", x),
        }

        let my_not_two = b_o.as_ref().and_then(|x| Some(x));
        match my_not_two {
            None => println!("This will print in response to None"),
            Some(x) => println!("This won't print: {}", x),
        }
    }
}
