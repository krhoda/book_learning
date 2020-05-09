;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname chapter_3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; (require 2htdp/batch-io)
(require 2htdp/image)
; (require 2htdp/universe)

; Number -> Number
; computes the area of a square with side len
; or 0 if invalid input
(check-expect (area-of-square 7) 49)
(check-expect (area-of-square "dog") 0)

(define (area-of-square len)
  (if (not (number? len)) 0
    (sqr len)))

; String -> 1String
; returns the first character of a string.
; returns empty strings for empty/invalid input
(check-expect (string-first "hello") "h")
(check-expect (string-first "")  "")
(check-expect (string-first #false) "")

(define (string-first s)
  (if (not (string? s)) ""
      (if (string=? s "") ""
          (substring s 0 1))))

; String -> 1String
; returns the last character of a string.
; returns empty strings for empty/invalid input
(check-expect (string-last "hello") "o")
(check-expect (string-last "") "")
(check-expect (string-last #false) "")

(define (string-last s)
  (if (not (string? s)) ""
      (if (string=? s "") ""
          (substring s (- (string-length s) 1) (string-length s)))))

; Image -> Number
; computes area in pixels of given image
; returns 0 if invalid input.
(check-expect (image-area (square 5 "solid" "red")) 25)
(check-expect (image-area "dog") 0)

(define (image-area img)
  (if (not (image? img)) 0
      (* (image-height img) (image-width img))))


; String -> String
; returns the tail of a string
; returns an empty string if given invalid input or strings less than 2 length
(check-expect (string-rest (square 5 "solid" "red")) "")
(check-expect (string-rest "") "")
(check-expect (string-rest "dog") "og")

(define (string-rest s)
  (if (not (string? s)) ""
      (if (> 2 (string-length s)) ""
          (substring s 1))))

; String -> String
; returns string without the last character
; returns an empty string if given invalid input or strings less than 2 length
(check-expect (string-remove-last (square 5 "solid" "red")) "")
(check-expect (string-remove-last "") "")
(check-expect (string-remove-last "do") "d")

(define (string-remove-last s)
  (if (not (string? s)) ""
      (if (> 2 (string-length s)) ""
          (substring s 0 (- (string-length s) 1)))))
