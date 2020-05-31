#lang br
(require "struct.rkt" "line.rkt")
(provide b-end b-goto)

(define (b-end) 
    (raise (end-program-signal)))
(define (b-goto expr) 
    (raise (change-line-signal expr)))