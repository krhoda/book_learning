#[macro_export]
macro_rules! map {
    ($( $k:expr => $v:expr ),*) => {
        {
            let mut map = std::collections::HashMap::new();

            $(
                map.insert($k, $v);
            )*

            map
        }
    };
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let a = map! {
            "one" => 1,
            "two" => 2
        };

        assert_eq!(a["one"], 1);
        assert_eq!(a["two"], 2);
    }
}
