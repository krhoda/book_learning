;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname chapter_1_2_5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)


; (write-file "sample.dat" "212")
; (read-file "sample.dat")
(write-file 'stdout
            (string-append
             (read-file "sample.dat")
             "\n"))

(define (C f)
  (* 5/9 (- f 32)))
(C 32)
(C 212)
(C -40)

(define (convert in out)
  (write-file out
    (string-append
     (number->string
      (C (string->number (read-file in))))
     "\n")))

(convert "sample.dat" 'stdout)
(convert "sample.dat" "out.dat")
(read-file "out.dat")

(define (number->square s)
  (square s "outline" "red"))

; (define (my-fib n)
;  (if (< n 2) n
;      (+ (my-fib (- n 1)) (my-fib (- n 2)))))

(big-bang 100
    [to-draw number->square]
    [on-tick sub1]
    [stop-when zero?])