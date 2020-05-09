#lang br/quicklang

(define (read-syntax path port)
    (define src-lines (port->lines port))
    (define src-datums (format-datums '(handle ~a) src-lines))
    (define module-datum `(module 
                            stacker-mod 
                            "stacker.rkt" 
                            ,@src-datums))
    ;;;  , used to unquote the list
    ;;;  @ used to merge the list
    (datum->syntax #f module-datum))

(provide read-syntax)

;;; HANDLE-EXPR is a patter var ... makes it match on a per-line basis
(define-macro (stacker-module-begin HANDLE-EXPR ...)
    ;;; #' casts to syntax object available in this scope.
    #'(#%module-begin 
        HANDLE-EXPR ...
        (display (first stack))))

(provide (rename-out [stacker-module-begin #%module-begin]))
                        
(define stack empty)

(define (pop-stack!)
    (define arg (first stack))
    (set! stack (rest stack))
    arg)

(define (push-stack! arg)
    (set! stack (cons arg stack)))

(define (handle [arg #f])
    (cond 
        [(number? arg) (push-stack! arg)]
        [(or (equal? + arg) (equal? * arg))
            (define op-result (arg (pop-stack!) (pop-stack!)))
            (push-stack! op-result)]))
(provide handle)
(provide + *)