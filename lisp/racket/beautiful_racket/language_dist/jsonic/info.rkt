#lang info
(define collection "jsonic")
(define version "1.0")
(define scribblings '(("scribblings/jsonic.scrbl")))

;;example pinned dep: ("brag" #:version "2.0")

;;; example test config.
(define test-omit-paths '("jsonic-test.rkt"))
(define deps '("base"
    "beautiful-racket-lib"
    "brag-lib"
    "draw-lib"
    "gui-lib"
    "rackunit-lib"
    "syntax-color-lib"))
(define build-deps '("scribble-lib"))
