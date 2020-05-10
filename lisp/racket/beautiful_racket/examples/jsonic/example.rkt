#lang jsonic

[
    null,
    42,
    true,
    ["array", "of", "string"],
    {
        "key-1": null,
        "key-2": false,
        "key-3": {"subkey": 21}
    },
// now it's crazy! 
@$ (* 8 7) $@,
@$ (list "another" "array") $@,
@$ (hash 'key-1 (hash 'nested 77)) $@
]