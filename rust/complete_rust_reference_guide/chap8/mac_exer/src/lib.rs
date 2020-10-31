#[macro_export]
macro_rules! hello {
    ($recip:tt) => {
        format!("HELLO {}", $recip)
    };
}

// #[macro_export]
// macro_rules! make_list {
//     ($($v:tt),*) => {
//         {
//             let mut str_vec = vec!["<ul>".to_string()];
//             $(
//                 str_vec.push(format!("<li>{}</li>", $v));
//             )*
//             str_vec.push("</ul>".to_string());
//             str_vec.join("")
//         }
//     }
// }
#[macro_export]
macro_rules! make_list {
    ($($v:literal),*) => {
        concat!("<ul>",
                $( "<li>", $v, "</li>", )*
                "</ul>")
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let p = hello!("puppies");
        let d = hello!("dogs");
        assert_eq!(d, "HELLO dogs");
        assert_eq!(p, "HELLO puppies");

        let onetwothree = make_list!(1, 2, 3);
        let abc = make_list!("a", "b", "c");
        assert_eq!("<ul><li>1</li><li>2</li><li>3</li></ul>", onetwothree);
        assert_eq!("<ul><li>a</li><li>b</li><li>c</li></ul>", abc);
    }
}
