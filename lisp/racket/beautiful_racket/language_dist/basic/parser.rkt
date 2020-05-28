#lang brag

;;; NOTE: THE Following 
;;; b-line : b-line-num [b-statement (":" b-statement)*]
;;; Expands to:
;;; b-line : b-line-num 
    ;;; | b-line-num b-statement
    ;;; | b-line-num b-statement (":" b-statement)+

;;; Subtly different from the above by making the statements all optional.
b-line : b-line-num [b-statement] (":" [b-statement])* [b-rem]

b-program : [b-line] (NEWLINE [b-line])*

b-line-num : INTEGER

b-statement : b-end | b-print | b-goto

b-rem : REM

b-end : "end"

;;; TODO: WORK FROM HERE:

b-print : "print" [b-printable]
b-printable :
b-goto :