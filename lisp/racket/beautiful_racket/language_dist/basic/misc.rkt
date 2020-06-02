#lang br
(require "struct.rkt" "expr.rkt")
(provide b-rem b-print b-let b-input b-import)

(define (b-rem x) (void))

(define (b-print . vals) 
    (displayln (string-append* (map ~a vals))))

(define-macro (b-let ID VAL)
    #'(set! ID VAL))

(define-macro (b-input ID)
    #'(b-let ID (let* ([str (read-line)]
                [num (string->number (string-trim str))])
            (or num str))))

(define-macro (b-import NAME) #'(void))