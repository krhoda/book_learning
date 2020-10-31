/* automatically generated by rust-bindgen */

pub type wchar_t = ::std::os::raw::c_int;
#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct max_align_t {
    pub __clang_max_align_nonce1: ::std::os::raw::c_longlong,
    pub __bindgen_padding_0: u64,
    pub __clang_max_align_nonce2: f64,
}
#[test]
fn bindgen_test_layout_max_align_t() {
    assert_eq!(
        ::std::mem::size_of::<max_align_t>(),
        32usize,
        concat!("Size of: ", stringify!(max_align_t))
    );
    assert_eq!(
        unsafe {
            &(*(::std::ptr::null::<max_align_t>())).__clang_max_align_nonce1 as *const _ as usize
        },
        0usize,
        concat!(
            "Offset of field: ",
            stringify!(max_align_t),
            "::",
            stringify!(__clang_max_align_nonce1)
        )
    );
    assert_eq!(
        unsafe {
            &(*(::std::ptr::null::<max_align_t>())).__clang_max_align_nonce2 as *const _ as usize
        },
        16usize,
        concat!(
            "Offset of field: ",
            stringify!(max_align_t),
            "::",
            stringify!(__clang_max_align_nonce2)
        )
    );
}
extern "C" {
    pub fn levenshtein(a: *const ::std::os::raw::c_char, b: *const ::std::os::raw::c_char)
        -> usize;
}
extern "C" {
    pub fn levenshtein_n(
        a: *const ::std::os::raw::c_char,
        length: usize,
        b: *const ::std::os::raw::c_char,
        bLength: usize,
    ) -> usize;
}
