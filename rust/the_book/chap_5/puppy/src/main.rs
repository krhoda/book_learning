fn main() {
    println!("Hello, world!");

    // let brave_pup = Puppy {
    //     name: String::from("Socks"),
    //     breed: String::from("Mutt"),
    //     tail_length: 4,
    //     afraid_of_vacuum: false,
    // };
    // is the same as
    let brave_pup = new_puppy(String::from("Socks"), String::from("Mutt"), 4);
    println!("{}", brave_pup.name);
    describe_puppy(&brave_pup);

    let beagle_uno = new_puppy(String::from("Milton"), String::from("Beagle"), 7);
    describe_puppy(&beagle_uno);

    let beagle_dos = Puppy {
        name: String::from("Millie"),
        ..beagle_uno
    };

    // Can no longer do this...
    // describe_puppy(&beagle_uno);
    // beagle_uno has moved...

    describe_puppy(&beagle_dos);
    // Or here, unless Puppy struct supported copying.
    // describe_puppy(&beagle_uno);
}

fn describe_puppy(p: &Puppy) {
    let mut fear_string = String::from("flees the vacuum cleaner with great whining!");
    if !&p.afraid_of_vacuum {
        fear_string = String::from("attacks the vacuum cleaner at every opportunity!");
    }

    println!(
        "{} is an adorable {} with a tail length of {} indeterminate tail-units and {}",
        &p.name, &p.breed, &p.tail_length, fear_string
    )
}

fn new_puppy(name: String, breed: String, tail_length: u64) -> Puppy {
    let is_afraid = if breed == "Mutt" { false } else { true };
    // Demo some shorthand
    // We, of course, could have named is_afraid afraid_of_vacuum and gone all the way.
    Puppy {
        name,
        breed,
        tail_length,
        afraid_of_vacuum: is_afraid,
    }
}

struct Puppy {
    name: String,
    breed: String,
    tail_length: u64,
    afraid_of_vacuum: bool,
}
