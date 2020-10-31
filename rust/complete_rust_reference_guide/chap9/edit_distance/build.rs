use std::path::PathBuf;

fn main() {
    println!("cargo:rustc-rerun-if-changed=.");
    println!("cargo:rustc-link-search=.");
    println!("cargo:rustc-link-lib=levenshtein");

    cc::Build::new()
        .file("lib/levenshtein.c")
        .out_dir(".")
        .compile("levenshtein.o");

    println!("HERE");
    let bindings = bindgen::Builder::default()
        .header("lib/levenshtein.h")
        .generate()
        .expect("Unable to generate building");

    println!("HERE!");
    let out_path = PathBuf::from("./src/");
    bindings
        .write_to_file(out_path.join("binding.rs"))
        .expect("Couldn't Write Bindings!");

    println!("HERE!?");
}
