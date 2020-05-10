#lang br/quicklang
(require brag/support racket/contract)

(define (make-tokenizer port)
    (define (next-token)
        (define jsonic-lexer 
                (lexer 
                ;;; Skip new lines or comments. 
                ;;; OH YEAH, THIS IS JSONC!
                [(from/to "//" "\n") (next-token)]
                ;; match embedded s-expressions.
                [(from/to "@$" "$@")
                    (token 'SEXP-TOK (trim-ends "@$" lexeme "$@"))]
                [any-char (token 'CHAR-TOK lexeme)]))
        (jsonic-lexer port))
        next-token)

(define (jsonic-token? x)
    (or (eof-object x) (token-struct? x)))

(provide (contract-out [make-tokenizer (input-port? . -> . (-> jsonic-token?))])