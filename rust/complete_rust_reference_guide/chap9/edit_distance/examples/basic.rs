use edit_distance::levenshtein_safe;

fn main() {
    let a = "foo";
    let b = "fooo";
    let x = levenshtein_safe(a, b);
    println!("X = {}", &x);
    assert_eq!(1, x);
}