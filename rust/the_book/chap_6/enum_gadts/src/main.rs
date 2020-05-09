fn main() {
    println!("Hello, world!");

    let home = IpAddrKind::V4(new_ipv4((127, 0, 0, 1)));
    let loopback = IpAddrKind::V6(new_ipv6(String::from("::1")));

    // OO approach
    home.gen_print();
    loopback.gen_print();

    // Functional approach
    print_ip(home);
    print_ip(loopback);
    // Remember! home and loop back are consumed here. They could be borrowed, if to be reused.

    let three = Some(3);
    let nuthin = None;

    // Option<i32> behaves like i32...
    is_it_three(three);
    is_it_three(nuthin);

    // ... are still available for pass-by-value
    is_it_four(three);
    is_it_four(nuthin);

    // This is illegal because nuthin has now been type-cast to Option<i32>
    // yo(nuthin);

    let sup = Some(String::from("sup"));
    let nix = None;

    yo(sup); // sup is consumed here
    yo(nix); // nix is consumed here, as it is cast to Option<String>

    // can pass None literal as much as we want though:
    yo(None);
    yo(None);
}

fn yo(maybe_sup: Option<String>) {
    match maybe_sup {
        Some(_) => println!("Not much yo"),
        _ => println!("Rude!"),
    }
}

fn is_it_three(maybe_three: Option<i32>) {
    if let Some(3) = maybe_three {
        println!("THREE");
        return;
    }

    println!("NOT THREE");
}

fn is_it_four(maybe_four: Option<i32>) {
    if let Some(4) = maybe_four {
        println!("FOUR");
        return;
    }

    println!("NOT FOUR");
}

struct IpV4 {
    addr: (u8, u8, u8, u8),
}

impl IpV4 {
    fn print_out(&self) {
        let (fst, snd, thd, frt) = self.addr;
        println!("{}.{}.{}.{}", fst, snd, thd, frt)
    }
}

fn new_ipv4(addr: (u8, u8, u8, u8)) -> IpV4 {
    IpV4 { addr }
}

struct IpV6 {
    addr: String,
}

impl IpV6 {
    fn print_out(&self) {
        println!("{}", self.addr)
    }
}

fn new_ipv6(addr: String) -> IpV6 {
    IpV6 { addr }
}

enum IpAddrKind {
    V4(IpV4),
    V6(IpV6),
}

impl IpAddrKind {
    fn gen_print(&self) {
        match self {
            IpAddrKind::V4(x) => x.print_out(),
            IpAddrKind::V6(x) => x.print_out(),
            // _ => (), is a catch-all-do-nothing if needing to calm a compiler.
        }
    }
}

// this can take either type:
fn print_ip(ip_kind: IpAddrKind) {
    // Quasi-Generic Dispatch.
    // Typeclasses, Interfaces, Reflect, etc.
    match ip_kind {
        IpAddrKind::V4(x) => x.print_out(),
        IpAddrKind::V6(x) => x.print_out(),
    }
}
