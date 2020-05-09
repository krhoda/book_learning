;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise_1_3_6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
(define WIDTH-OF-WORLD (* WHEEL-RADIUS 40))

(define WHEEL (circle WHEEL-RADIUS "solid" "black"))
(define SPACE (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white"))
(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))
(define CAR-BODY (overlay/align
                  "center"
                  "bottom"
                  (rectangle (* WHEEL-DISTANCE 2)
                             (* WHEEL-RADIUS 2)
                             "solid"
                             "red")
                  (square WHEEL-DISTANCE
                          "solid"
                          "red")))

(define BACKGROUND (rectangle WIDTH-OF-WORLD
                              (* 2 (+ (image-height CAR-BODY) WHEEL-RADIUS))
                              "solid"
                              "white"))
(define Y-CAR (* 3 WHEEL-RADIUS))
(define SADCAR (overlay/xy
                BOTH-WHEELS
                (- 0 WHEEL-RADIUS)
                (- 0 (- (image-height CAR-BODY)
                        (/ (image-height BOTH-WHEELS)
                           2)))
                CAR-BODY))

(define TEST-1 (place-image
                SADCAR
                50
                Y-CAR
                BACKGROUND))
  
(define TEST-2 (place-image
                SADCAR
                75
                Y-CAR
                BACKGROUND))
  
(define TEST-3 (place-image
                SADCAR
                100
                Y-CAR
                BACKGROUND))
  
(define TEST-4 (place-image
                SADCAR
                150
                Y-CAR
                BACKGROUND))


; WorldState: data that represents the state of the world (cw)
 
; WorldState -> Image
; places the image of the car x pixels
; from the left margin of BACKGROUND image
(check-expect (render 50) TEST-1)
(check-expect (render 75) TEST-2)
(check-expect (render 100) TEST-3)
(check-expect (render 150) TEST-4)
(define (render x) (place-image
                    SADCAR
                    x
                    Y-CAR
                    BACKGROUND))

; (define (trippy-render x) (place-image
;                           SADCAR
;                           x
;                           (- 0 (* 2 (sin x)))
;                           BACKGROUND))

; WorldState -> WorldState
; adds 3 to x to move the car right for every clock tick
(check-expect (tock 3) 6)
(define (tock x)
  (+ x 3))
 
; WorldState String -> WorldState 
; for each keystroke, big-bang obtains the next state 
; from (keystroke-handler cw ke); ke represents the key
(define (keystroke-handler cw ke) ...)
 
; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"
(check-expect (mouse-event-handler 21 20 20 "enter") 21)
(check-expect (mouse-event-handler 42 10 20 "button-down") 10)
(check-expect (mouse-event-handler 42 10 20 "move") 42)
(define (mouse-event-handler cw x y me)
  (if (string=? "button-down" me) x
      cw))

; WorldState -> Boolean
; after each event, big-bang evaluates (end? cw)
(check-expect (end? 0) #false)
(check-expect (end? (* 2 (image-width BACKGROUND))) #true)
(define (end? x)
  (> x (+ (image-width BACKGROUND)
          (/ (image-width SADCAR) 2))))

; WorldState -> WorldState
; launches the program from some initial state
(define (main ws)
  (big-bang ws
    [on-tick tock]
    ; [to-draw trippy-render]
    [to-draw render]
    [on-mouse mouse-event-handler]
    [stop-when end?]))
(main 0)