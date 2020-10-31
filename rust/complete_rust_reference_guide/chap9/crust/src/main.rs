use std::os::raw::{c_char, c_uint};
use std::ffi::CString;

extern "C" {
    fn mystrlen(str: *const c_char) -> c_uint;
}

fn main() {
    let c_string = CString::new("C by way of Rust").expect("OH NO");
    let count = unsafe {
        mystrlen(c_string.as_ptr())
    };

    println!("Length of c_string as computed by a turing machine: {}", count);

    println!("and again: {}", safe_mystrlen("Alonzo Church").unwrap());
}

fn safe_mystrlen(str: &str) -> Option<u32> {
    let c_string = match CString::new(str) {
        Ok(c) => c,
        Err(_) => return None
    };

    unsafe {
        Some(mystrlen(c_string.as_ptr()))
    }
}