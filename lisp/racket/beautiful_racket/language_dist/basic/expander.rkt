#lang br/quicklang
(require "struct.rkt" "run.rkt" "elements.rkt" "setup.rkt")
(provide (rename-out [b-module-begin #%module-begin])
    (all-from-out "elements.rkt"))

(define-macro (b-module-begin (b-program LINE ...))
    (with-pattern 
        ([((b-line NUM STATEMENT ...) ...) #'(LINE ...)]
        [(LINE-FUNC ...) (prefix-id "line-" #'(NUM ...))]
        [(VAR-ID ...) (find-property 'b-id #'(LINE ...))]
        [(IMPORT-NAME ...)
            (find-property 'b-import-name #'(LINE ...))]
        [(EXPORT-NAME ...)
            (find-property 'b-export-name #'(LINE ...))])
    #'(#%module-begin 
        (module configure-runtime 
            br
            (require basic/setup)
            (do-setup!))
        (require IMPORT-NAME ...)
        (provide EXPORT-NAME ...)
        (define VAR-ID 0) ...
        LINE ...
        (define line-table 
            (apply hasheqv (append (list NUM LINE-FUNC) ...)))
            (parameterize 
                ([current-output-port (basic-output-port)])
        (void (run line-table))))))

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