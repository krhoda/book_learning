#lang br/quicklang

(define-macro (bf-module-begin PARSE-TREE)
    #'(#%module-begin PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

;;; Functional Expander:

;;; This is a helper to line-up the types between functions.
;;; (arr -> ptr -> (arr, ptr)) -> (arr, ptr) -> (arr, ptr)
;;; If you will.
(define (fold-funcs apl bf-funcs)
    (for/fold ([current-apl apl])
        ([bf-func (in-list bf-funcs)])
        (apply bf-func current-apl)))

(define-macro (bf-program OP-OR-LOOP-ARG ...)
    #'(begin 
        (define first-apl (list (make-vector 30000 0) 0))
        (void (fold-funcs first-apl (list OP-OR-LOOP-ARG ...)))))
(provide bf-program)

(define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]")
    #'(lambda (arr ptr)
        (for/fold ([current-apl (list arr ptr)])
            ([i (in-naturals)]
                #:break (zero? (apply current-byte
                                    current-apl)))
            (fold-funcs current-apl (list OP-OR-LOOP-ARG ...)))))
(provide bf-loop)

(define-macro-cases bf-op 
    [(bf-op ">") #'gt]
    [(bf-op "<") #'lt]
    [(bf-op "+") #'plus]
    [(bf-op "-") #'minus]
    [(bf-op ".") #'period]
    [(bf-op ",") #'comma])
(provide bf-op)


;;; Get Current Cell
(define (current-byte arr ptr) (vector-ref arr ptr))

;;; Set Current Cell
;;; Pure but slow
;;; (define (set-current-byte arr ptr val)
;;;     (define new-arr (vector-copy arr))
;;;     (vector-set! new-arr ptr val)
;;;     new-arr)

;;; Faster, mutable: (Needs a persistent data structure):
(define (set-current-byte arr ptr val)
    (vector-set! arr ptr val) arr)

;;; Forward and Back.
(define (gt arr ptr) (list arr (add1 ptr)))
(define (lt arr ptr) (list arr (sub1 ptr)))

;;; Incremement
(define (plus arr ptr)
    (list (set-current-byte arr ptr (add1 (current-byte arr ptr)))
    ptr))

;;; Decrement
(define (minus arr ptr)
    (list (set-current-byte arr ptr (sub1 (current-byte arr ptr)))
    ptr))

;;; Output
(define (period arr ptr)
    (write-byte (current-byte arr ptr))
    (list arr ptr))

;;; Input
(define (comma arr ptr)
    (list (set-current-byte arr ptr (read-byte)) ptr))

;;; Imperative Expander: 

;;; (define-macro (bf-program OP-OR-LOOP-ARG ...)
;;;     #'(void OP-OR-LOOP-ARG ...))
;;; (provide bf-program)

;;; (define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]" )
;;;     #'(until (zero? (current-byte))
;;;         OP-OR-LOOP-ARG ...))
;;; (provide bf-loop)

;;; (define-macro-cases bf-op
;;;     [(bf-op ">") #'(gt)]
;;;     [(bf-op "<") #'(lt)]
;;;     [(bf-op "+") #'(plus)]
;;;     [(bf-op "-") #'(minus)]
;;;     [(bf-op ".") #'(period)]
;;;     [(bf-op ",") #'(comma)])
;;; (provide bf-op)

;;; Our Turing Machine
;;; (define arr (make-vector 30000 0))
;;; (define ptr 0)

;;; Operations on our Turing Machine

;;; Get / Set Current Cell
;;; (define (current-byte) (vector-ref arr ptr))
;;; (define (set-current-byte! val) (vector-set! arr ptr val))

;;; Forward and Back.
;;; (define (gt) (set! ptr (add1 ptr)))
;;; (define (lt) (set! ptr (sub1 ptr)))

;;; Inc and Dec
;;; (define (plus) (set-current-byte! (add1 (current-byte))))
;;; (define (minus) (set-current-byte! (sub1 (current-byte))))

;; I/O
;;; (define (comma) (set-current-byte! (read-byte)))
;;; (define (period) (write-byte (current-byte)))