;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname chapter_1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(+ 1 1)
(+ (sqr 2) (sqr 3))
(string-append "hello" " " "world")

(string-append "bools" ":")
(or #false #true)
(and #true #true)
(not #true)

(string-append "comparisons" ":")
(> 1 2)
(< 1 2)
(not (= 100 2))

(string-append "tinker" " !!!")
(>= 10 10)
(<= -1 0)
(string=? "design" "tinker")
(string=? "major" "major")

(string-append "Behold -- " "the power of line breaks")

(and (or (string=? "hello world" "good morning")
         (= (string-length "hello world")
            (string->number "11")))
     (>= (+ (string-length "hello world") 60) 80))

(circle 10 "solid" "red")
(string-append "My Japanese " "Flag!")
(overlay (circle 5 "solid" "red")
         (rectangle 35 25 "solid" "white"))

(string-append "The Ugly Book " "Example")
(place-image (circle 5 "solid" "green")
             50 80
             (empty-scene 100 100))
(string-append "Let's get func" " y!")
(define (y x) (* x x))
(+ (y 2) (y 3))

(define (blue-balloon height)
  (place-image (circle 10 "solid" "blue") 50 height (empty-scene 100 60)))
(blue-balloon 0)
(blue-balloon 30)
(blue-balloon 60)
(animate blue-balloon)

(define (sign x)
  (cond [(> x 0) 1]
        [(= x 0) 0]
        [(< x 0) -1]))
(sign 5)
(sign 0)
(sign -5)

(define (book-blue-balloon.v2 height circ)
  (cond
    [(<= height 60)
     (place-image circ 50 height
                  (empty-scene 100 60))]
    [(> height 60)
     (place-image circ 50 60
                  (empty-scene 100 60))]))

(define (book-blue-balloon.v3 height circ)
    (cond
    [(<= height (- 60 (/ (image-height circ) 2)))
     (place-image circ 50 height
                  (empty-scene 100 60))]
    [(> height (- 60 (image-height circ) 2))
     (place-image circ 50 (- 60 (/ (image-height circ) 2))
                  (empty-scene 100 60))]))

(define (blue-balloon.v2 height)
  (book-blue-balloon.v2 height (circle 10 "solid" "blue")))
(define (blue-balloon.v3 height)
  (book-blue-balloon.v3 height (circle 10 "solid" "blue")))

(animate blue-balloon.v2)
(animate blue-balloon.v3)

(define CIRC (overlay (circle 10 "solid" "blue")
                      (rectangle 40 4 "solid" "blue")))
(define WIDTH 400)
(define CENTER-WIDTH (/ WIDTH 2))
(define HEIGHT 200)
(define BACKGROUND (rectangle WIDTH HEIGHT "solid" "green"))
(define FOREGROUND-HEIGHT 10)
(define FOREGROUND (rectangle WIDTH FOREGROUND-HEIGHT "solid" "red"))
(define FOREGROUND-CENTER-HEIGHT (- (image-height BACKGROUND)
                                    (/ FOREGROUND-HEIGHT 2)))
(define BACKDROP (place-image FOREGROUND
                              CENTER-WIDTH
                              FOREGROUND-CENTER-HEIGHT
                              BACKGROUND))
(define RESTING-HEIGHT (- HEIGHT FOREGROUND-HEIGHT
                          (/ (image-height CIRC) 2)))

(define (blue-balloon.v4 d)
  (cond
      [(<= d RESTING-HEIGHT)
       (place-image CIRC CENTER-WIDTH d BACKDROP)]
      [(> d RESTING-HEIGHT)
       (place-image CIRC CENTER-WIDTH RESTING-HEIGHT BACKDROP)]))
(animate blue-balloon.v4)

(define V 3)
(define (distance t)
  (* V t))
(define (blue-balloon.v5 t)
  (cond
      [(<= (distance t) RESTING-HEIGHT)
       (place-image CIRC CENTER-WIDTH (distance t) BACKDROP)]
      [(> (distance t) RESTING-HEIGHT)
       (place-image CIRC CENTER-WIDTH RESTING-HEIGHT BACKDROP)]))
(animate blue-balloon.v5)