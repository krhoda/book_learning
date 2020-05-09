;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise_1_3_7b) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; GUAGE PROG
(require 2htdp/image)
(require 2htdp/universe)

(define STARTING-HAPPY 30)
(define MAX-HAPPY 100)
(define MIN-HAPPY 0)
(define BACKGROUND-HEIGHT
  (+ MAX-HAPPY (/ MAX-HAPPY 10)))
(define BACKGROUND-WIDTH
  (/ BACKGROUND-HEIGHT 2))
(define BACKGROUND
  (rectangle
  BACKGROUND-WIDTH
  BACKGROUND-HEIGHT
  "solid"
  "black"))
(define GAUGE-X
  (/ BACKGROUND-WIDTH 2))
(define GAUGE-WIDTH
  (/ BACKGROUND-WIDTH 4))

; Number -> Image
; Takes the current happiness meter
; Displays the bar
(check-expect (make-gauge 100) MAKE-GAUGE-T1)
(check-expect (make-gauge 30) MAKE-GAUGE-T2)
(define (make-gauge y)
  (rectangle
    GAUGE-WIDTH
    y
    "solid"
    "red"))

; WorldState -> Image
; Takes the current happiness meter
; Displays the bar
(check-expect (show-gauge 11) SHOW-GAUGE-T1) 
(check-expect (show-gauge 95) SHOW-GAUGE-T2) 
(define (show-gauge ws)
  (place-image
   (make-gauge ws)
   GAUGE-X
   BACKGROUND-HEIGHT
   BACKGROUND))

; WorldState -> Number
; Takes the float and decrements it by 1/10th.
(check-expect (diminish 0) 0)
(check-expect (diminish 1) 0.9)
(check-expect (diminish 100) 99.9)
(define (diminish x)
  (if (< (- x 0.1) 0) 0
      (- x 0.1)))

; WorldState, Keypress -> Number
; Takes the float and keypress,
; If correct keypress, in/decrease
(define (alter ws keypress)
  (cond
    [(key=? keypress "up") (increase-third ws)]
    [(key=? keypress "down") (decrease-fifth ws)]
    [else ws]))

; WorldState -> Number
; Takes float increases unless would max.
(check-expect (increase-third 3) 4)
(check-expect (increase-third MAX-HAPPY) MAX-HAPPY)
(define (increase-third ws)
  (if (> (+ ws (/ ws 3)) MAX-HAPPY) MAX-HAPPY
      (if (= ws 0) (/ MAX-HAPPY 10)
         (+ ws (/ ws 3)))))

; WorldState -> Number
; Takes float, decreases unless would min.
(check-expect (decrease-fifth 100) 80)
(check-expect (decrease-fifth MIN-HAPPY) MIN-HAPPY)
(define (decrease-fifth ws)
  (if (< (- ws (/ ws 5)) MIN-HAPPY) MIN-HAPPY
      (if (< (- ws (/ ws 5)) 0) MIN-HAPPY
         (- ws (/ ws 5)))))

; MAIN
(define (main ws)
  (big-bang ws
    [on-tick diminish]
    [on-key alter]
    [to-draw show-gauge]))
(main 50)

; Test Structs:
(define MAKE-GAUGE-T1
  (rectangle
    GAUGE-WIDTH
    100
    "solid"
    "red"))
(define MAKE-GAUGE-T2
  (rectangle
    GAUGE-WIDTH
    30
    "solid"
    "red"))
(define SHOW-GAUGE-T1
  (place-image
   (make-gauge 11)
   GAUGE-X
   BACKGROUND-HEIGHT
   BACKGROUND))
(define SHOW-GAUGE-T2
  (place-image
   (make-gauge 95)
   GAUGE-X
   BACKGROUND-HEIGHT
   BACKGROUND))