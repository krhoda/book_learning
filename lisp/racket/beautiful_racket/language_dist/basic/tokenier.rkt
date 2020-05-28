#lang br
(require "lexer.rkt" brag/support)

;;; TODO: Understand deeper the path param here.
;;; Is it for reporting which file the err is from or nowhere if the REPL?
(define (make-tokenizer ip [path #f])
    (port-count-lines! ip)
    (lexer-file-path path)
    (define (next-token) (basic-lexer ip))
    next-token)

(provide make-tokenizer)