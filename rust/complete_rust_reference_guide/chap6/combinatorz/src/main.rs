use std::fmt::Debug;

fn humor_panic<T: Debug>(x: T) {
    panic!("I do not understand {:?}, apparently", x);
}

fn main() {
    let mut g_r: Result<i64, String> = Ok(1);
    let b_r: Result<i64, String> = Err("This is bad".to_string());
    let mut g_o: Option<i64> = Some(1);
    let b_o: Option<i64> = None;

    // .map / .map_err
    {
        // Map operates on a success value,
        let res1 = g_r.as_ref().map(|x| x + x);
        match res1 {
            Ok(x) => println!("This will print two: {}", x),
            _ => humor_panic("map"),
        }

        // NOTE: Only for Result.
        let _ = b_r
            .as_ref()
            .map_err(|x| println!("Will be a negative statement: {}", x));
    }

    // .and_then
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

    // .unwrap_or 
    {
        let my_four = b_o.as_ref().unwrap_or(&4);
        assert_eq!(my_four, &4);

        // Returns inner value type for both Option and Result
        let my_one = g_r.as_ref().unwrap_or(&4);
        let my_other_one = g_o.as_ref().unwrap_or(&4);
        assert_eq!(my_one, my_other_one);
    }

    // .unwrap_or_else, like unwrap_or but computed dynamically
    {
        let my_four = b_o.as_ref().unwrap_or_else(|| &(2 * 2));

        // if result, takes unwrapped err as first arg
        let my_other_four = b_r.as_ref().unwrap_or_else(|_| &(2 * 2));
        assert_eq!(my_four, my_other_four);

        let my_one = g_r.as_ref().unwrap_or_else(|_| &(2 * 2));
        assert_eq!(my_one, &1);
    }

    // .or / .or_else return unwrapped values:
    {
        let my_four = b_o.as_ref().or(Some(&4));
        assert_eq!(my_four, Some(&4));

        // Returns inner value type for both Option and Result
        let my_one : Result<&i64, String> = g_r.as_ref().or(Ok(&4));
        let my_other_one = g_o.as_ref().or(Some(&4));
        match my_one {
            Ok(x) => {
                match my_other_one {
                    Some(y) => {
                        assert_eq!(x, y);
                    }
                    _ => panic!("My other one wasn't what I thought: {:?}", my_other_one)
                }
            }
            _ => panic!("My one wasn't what I thought: {:?}", my_one)
        }
    }

    {
        let my_four = b_o.as_ref().or_else(|| Some(&(2 * 2)));
        assert_eq!(my_four, Some(&4));

        // Returns inner value type for both Option and Result
        // if result, takes unwrapped err as first arg
        let my_one : Result<&i64, String> = g_r.as_ref().or_else(|_| Ok(&4));
        let my_other_one = g_o.as_ref().or_else(|| Some(&4));
        match my_one {
            Ok(x) => {
                match my_other_one {
                    Some(y) => {
                        assert_eq!(x, y);
                    }
                    _ => panic!("My other one wasn't what I thought: {:?}", my_other_one)
                }
            }
            _ => panic!("My one wasn't what I thought: {:?}", my_one)
        }
    }

    // convert
    let b_o2 = b_r.as_ref().ok();
    assert_eq!(None, b_o2);

    let b_r2 : Result<i64, String> = b_o.ok_or("This is bad".to_string());
    assert_eq!(&b_r2, &b_r);

    let b_r3 : Result<i64, String> = b_o.ok_or_else(|| "This is bad".to_string());
    assert_eq!(b_r2, b_r3);

    {
        let x = g_o.as_mut().unwrap();
        let y = g_r.as_mut().unwrap();
        *x = 2;
        *y = 2;
    }

    assert_eq!(g_o.unwrap(), 2);
    assert_eq!(g_r.unwrap(), 2);
}