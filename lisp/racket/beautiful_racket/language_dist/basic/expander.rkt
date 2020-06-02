#lang br/quicklang
(require "struct.rkt" "run.rkt" "elements.rkt")
(provide (rename-out [b-module-begin #%module-begin])
    (all-from-out "elements.rkt"))

(define-macro (b-module-begin (b-program LINE ...))
    (with-pattern 
        ([((b-line NUM STATEMENT ...) ...) #'(LINE ...)]
        [(LINE-FUNC ...) (prefix-id "line-" #'(NUM ...))]
        [(VAR-ID ...) (find-property 'b-id #'(LINE ...))]
        [(IMPORT-NAME ...)
            (find-property 'b-import-name #'(LINE ...))])
    #'(#%module-begin 
        (require IMPORT-NAME ...)
        (define VAR-ID 0) ...
        LINE ...
        (define line-table 
            (apply hasheqv (append (list NUM LINE-FUNC) ...)))
        (void (run line-table)))))

;;; Used to lift vars and requireds to top of module.
(begin-for-syntax
    (require racket/list)
    (define (find-property which line-stxs) 
        (remove-duplicates 
            (for/list
                ([stx (in-list (stx-flatten line-stxs))]
                    #:when (syntax-property stx which))
                stx)
            #:key syntax->datum)))