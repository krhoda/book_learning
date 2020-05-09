;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname chapter_1_2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)

(define (dist-from-origin x y)
  (sqrt (+ (sqr x) (sqr y))))
(dist-from-origin 1 2)
(dist-from-origin 10 10)

(define (cvolume x)
  (* x x x))
(define (csurface x)
  (* (sqr x) 6))

(cvolume 10)
(csurface 10)

(define (string-first s)
  (if (string=? s "") #false
      (substring s 0 1)))

(define (string-last s)
  (if (string=? s "") #false
      (substring s
                 (- (string-length s) 1))))

(string-first "my string")
(string-first "")
(string-last "my string")
(string-last "")

(define (==> sunny friday)
  (if (or (not sunny) friday)
      #true
      #false))
(==> true true)
(==> true false)
(==> false true)
(==> false false)

(define (string-join s1 s2)
  (string-append s1 "_" s2))
(string-join "hello" "world")

(define (string-insert str i)
  (if (string=? str "") "_"
      (string-append (substring str 0 i)
                     "_"
                     (substring str i))))
(string-insert "helloworld" 5)
(string-insert "" 300)

(define (string-delete str i)
  (if (string=? str "") ""
      (substring str i)))

(string-delete "helloworld" 5)
(string-delete "" 5)

(define (my-letter fst lst sig)
  (string-append
   (opening fst)
   "\n\n"
   (body fst lst)
   "\n\n"
   (closing sig)))

(define (opening fst)
  (string-append "Dear " fst ","))

(define (body fst lst)
  (string-append
   "We have discovered that all people with the" "\n"
   "last name " lst " have won our lottery. So, " "\n"
   fst ", " "hurry and pick up your prize."))

(define (closing signature-name)
  (string-append
   "Sincerely,"
   "\n"
   signature-name   "\n"))

(write-file 'stdout (my-letter "Joe" "Armstrong" "Diekstra"))

(string-append "Monopolisitc Movie Theatre " "Simulation")

(define baseline-attendees 120)
(define baseline-price 5.0)
(define change-per-dime 15)
(define dime 0.1)
(define dime-ratio (/ change-per-dime dime))
(define cost-of-show 180)
(define cost-of-attendee 0.04)

(define (attendees ticket-price)
  (- baseline-attendees
     (* (- ticket-price baseline-price)
        dime-ratio)))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price)
  (+ cost-of-show
     (* cost-of-attendee (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))

(profit 2.8)
(profit 2.9) ; We have a winner!
(profit 3)

; WE ENJOY TYPING
; Also set to use Exercise 29 settings
(define (wet_profit price)
  (- (* (+ 120
           (* (/ 15 0.1)
              (- 5.0 price)))
        price)
        (* 1.5
           (+ 120
              (* (/ 15 0.1)
                 (- 5.0 price))))))

(wet_profit 3.5) ; the
(wet_profit 3.6) ;; peak
(wet_profit 3.7) ;; of the
(wet_profit 3.8) ; curve