#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789"))

(define basic-lexer
    (lexer-srcloc
        ;;; Catch meaningful whitespace first...
        ["\n", (token 'NEWLINE lexeme)]
        ;;; ...Then the rest
        [whitespace (token lexeme #:skip? #t)]
        ;;; Comments
        [(from/stop-before "rem" "\n") (token 'REM lexeme)]
        ;;; Operators:
        [(:or "print" "goto" "end" "+" ":" "l")
            (token lexeme lexeme)]
        ;; TODO: Digits:
        ))

(provide basic-lexer)