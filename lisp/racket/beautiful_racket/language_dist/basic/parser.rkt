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

@b-statement : b-end 
    | b-print 
    | b-goto 
    | b-let 
    | b-input
    | b-if

b-rem : REM
b-end : /"end"
b-print : /"print" [b-printable] (/";" [b-printable])*
@b-printable : STRING | b-expr
b-goto : /"goto" b-expr
b-let : [/"let"] b-id /"=" (b-expr | STRING)
b-input : /"input" b-id

b-if : /"if" b-expr 
    /"then" (b-statement | b-expr) 
    [/"else" (b-statement | b-expr)]

@b-id : ID

;;; NOTE: Trippy cascading order of operations here.
;;; By matching outward in, and making operators optional,
;;; It will natually default ot order of operations.
;;; Or fall through to just a value.
b-expr : b-or-expr
b-or-expr : [b-or-expr "or"] b-and-expr
b-and-expr : [b-and-expr "and"] b-not-expr
b-not-expr : ["not"] b-comp-expr
b-comp-expr : [b-comp-expr ("="|"<"|">"|"<>")] b-sum
;;; Continues into numerical usage of the above trickery.
b-sum : [b-sum ("+"|"-")] b-product
b-product : [b-product ("*"|"/"|"mod")] b-neg
b-neg : ["-"] b-expt
b-expt : [b-expt "^"] b-value

@b-value : b-number | b-id | /"(" b-expr /")"
@b-number : INTEGER | DECIMAL


