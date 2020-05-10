#lang br
(require brag/support syntax-color/racket-lexer)

(define jsonic-lexer
    (lexer 
        [(eof) (values lexeme 'eof #f #f #f)]
        [(:or "@$" "$@") 
            (values lexeme 'parenthesis
                (if (equal? lexeme "@$") '|(| '|)|)
                (pos lexeme-start) (pos lexeme-end))]
        [(from/to "//" "\n")
            (values lexeme 'comment #f 
                (pos lexeme-start) (pos lexeme-end))]
        [any-char 
            (values lexeme 'string #f
                (pos lexeme-start) (pos lexeme-end))]))

(define (color-jsonic port offset racket-coloring-mode?)
    ;;; Check for coloring of JSON or Racket...
    (cond
        ;;; If JSON keep going until...
        [(or (not racket-coloring-mode?)
            ;;; ... a delimiter is seen, then switch!
            (equal? (peek-string 2 0 port) "$@"))
            (define-values (str cat paren start end)
                (jsonic-lexer port))
            (define switch-to-racket-mode (equal? str "@$"))
            (values str cat paren start end 0 switch-to-racket-mode)]
        ;;; Otherwise evaluate the S-expression
        [else
            (define-values (str cat paren start end)
                (racket-lexer port))
            (values str cat paren start end 0 #t)]))

(provide color-jsonic)
