use into_map_derive::IntoMap;

#[derive(IntoMap)]
struct User {
    name: String,
    id: usize, 
    active: bool
}

fn main() {
    let u = User { name: "Puppy".to_string(), id: 35, active: false };
    let map = u.into_map();

    println!("Hello, {:?}!", map);
}
