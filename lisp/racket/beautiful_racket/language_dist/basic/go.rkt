#lang br
(require "struct.rkt" "line.rkt")
(provide b-end b-goto b-gosub b-return b-for b-next)

(define (b-end) 
    (raise (end-program-signal)))
(define (b-goto expr) 
    (raise (change-line-signal expr)))

(define return-ccs empty)

(define (b-gosub num-expr)
    (let/cc here-cc
        (push! return-ccs here-ccs)
        (b-goto num-expr)))

(define (b-return)
    (when (empty? return-css)
        (raise-line-error "return without gosub"))
    (define top-cc (pop! return-css))
    (top-cc (void)))

;;; LOOP-ID->loop-cc allowing next to call for and on and on.
(define next-funcs (make-hasheq))

(define-macro-cases b-for
    [(_ LOOP-ID START END) #'(b-for LOOP-ID START END 1)]
    ;;; Set the next continuation by checking for termination
    ;;; BEFORE evaluation.
    [(_ LOOP-ID START END STEP) 
        #'(b-let LOOP-ID 
            (let/cc loop-cc 
                (hash-set! next-funcs
                    'LOOP-ID
                    (lambda () 
                        (define next-val (+ LOOP-ID STEP))
                        (if (next-val 
                                . in-in-closed-interval? . 
                                START
                                END)
                            (loop-cc next-val)
                            (hash-remove! next-funcs
                                'LOOP-ID))))
                START))])

(define (in-closed-interval? x start end)
    ((if (< start end) <= >=) start x end))

(define-macro (b-next LOOP-ID)
    #'(begin
        (unless (hash-has-key? next-funcs 'LOOP-ID)
            (raise-line-error (format 
                    "`next ~a` without for" 
                    'LOOP-ID)))
        (define func (hash-ref next-funcs 'LOOP-ID))
        (func)))