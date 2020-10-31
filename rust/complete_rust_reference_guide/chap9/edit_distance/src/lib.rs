mod binding;

use crate::binding::levenshtein;
use std::ffi::CString;

pub fn levenshtein_safe(a: &str, b: &str) -> usize {
    let a = CString::new(a).unwrap();
    let b = CString::new(b).unwrap();

    let dist = unsafe { levenshtein(a.as_ptr(), b.as_ptr()) };
    dist
}