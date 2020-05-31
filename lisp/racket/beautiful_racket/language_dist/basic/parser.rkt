#lang brag

;;; Everything busts without this at the top.
b-program : [b-line] (/NEWLINE [b-line])*

;;; NOTE: THE Following 
;;; b-line : b-line-num [b-statement (":" b-statement)*]
;;; Expands to:
;;; b-line : b-line-num 
    ;;; | b-line-num b-statement
    ;;; | b-line-num b-statement (":" b-statement)+

;;; Subtly different from the above by making the statements all optional.
b-line : b-line-num [b-statement] (/":" [b-statement])* [b-rem]
@b-line-num : INTEGER
@b-statement : b-end | b-print | b-goto | b-let | b-input
b-rem : REM
b-end : /"end"
b-print : /"print" [b-printable] (/";" [b-printable])*
@b-printable : STRING | b-expr
b-goto : /"goto" b-expr
b-let : [/"let"] b-id /"=" (b-expr | STRING)
b-input : /"input" b-id
@b-id : ID

;;; Aliasing to allow conversion between BASIC and Racket Math.
b-expr : b-sum
b-sum : b-number (/"+" b-number)*
@b-number : INTEGER | DECIMAL | b-id


