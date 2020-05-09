#lang brag
;;; GRAMMAR:
bf-program : (bf-op | bf-loop)*
bf-op : ">" | "<" | "+" | "-" | "." | ","
;;; Though valid apparently this is problematic.
;;; bf-loop : "[" bf-program "]"
bf-loop : "[" (bf-op | bf-loop)* "]"