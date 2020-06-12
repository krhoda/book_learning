#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

;;; Racket forbidden identifiers for imports
(define-lex-abbrev racket-id-kapu
    (:or whitespace (char-set "()[]{}\",'`;#|\\")))

(define-lex-abbrev reserved-terms 
    (:or 
        "print"
        "goto"
        "end"
        "+"
        "-"
        "*"
        "/"
        "^"
        "mod"
        "("
        ")"
        ":"
        ";"
        "let"
        "="
        "input"
        "if"
        "then"
        "else"
        "<"
        ">"
        "<>"
        "and"
        "or"
        "not"
        "gosub"
        "return"
        "for"
        "to"
        "step"
        "next"
        "def"
        ","
        "import"
        "export"))

(define basic-lexer
    (lexer-srcloc
        ;;; Catch meaningful whitespace first...
        ["\n" (token 'NEWLINE lexeme)]
        ;;; ...Then the rest
        [whitespace (token lexeme #:skip? #t)]
        ;;; Comments:
        [(from/stop-before "rem" "\n") (token 'REM lexeme)]
        ;;; Racket imports:
        [(:seq "[" (:+ (:~ racket-id-kapu)) "]")
            (token 'RACKET-ID
                (string->symbol (trim-ends "[" lexeme "]")))]

        ;;; Keywords:
        [reserved-terms (token lexeme lexeme)]
        ;;; User defined vars:
        [(:seq alphabetic (:* (:or alphabetic numeric "$")))
            (token 'ID (string->symbol lexeme))]
        ;;; One digit:
        [digits (token 'INTEGER (string->number lexeme))]
        ;;; A sequence of possible floats numbers
        ;;; matches .456, 123.456, and 123:
        [(:or (:seq (:? digits) "." digits)
                (:seq digits "."))
            (token 'DECIMAL (string->number lexeme))]
        ;;; Strings:
        [(:or (from/to "\"" "\"") (from/to "'" "'"))
            (token 'STRING
                ;;; Drop the quotes.
                (substring lexeme 
                    1
                    (sub1 (string-length lexeme))))]))

(provide basic-lexer)