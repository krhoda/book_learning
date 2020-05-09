(module sicp_chap1 racket
	(define my_pi 3.14159)
	(define my_radius 10)
	(define my_circle (* my_pi (* my_radius my_radius)))
	(identity my_circle)

	(define (make-rat n d)
	  (let ((g (gcd n d)))
	  (cons (/ n g)
			(/ d g))))

	(define (numer x) (car x))
	(define (denom x) (cdr x))

	(define a (make-rat 1 2))
	(define b (make-rat 1 4))
	(define (+rat x y)
	  (make-rat (+ (* (numer x) (denom y))
				   (* (numer y) (denom x)))
				(* (denom x) (denom y))))
	(+rat a b)

	(define (make-vect x y) (cons x y))
	(define (xcord p) (car p))
	(define (ycord p) (cdr p))

	(define (make-seg p q) (cons p q))
	(define (seg-start s) (car s))
	(define (seg-end s) (cdr s))
	(define (avg2 x y) (/ (+ x y) 2))

	(define (midpoint s)
	  (let ((a (seg-start s))
			(b (seg-end s)))
	  (make-vect
		(avg2 (xcord a) (xcord b))
		(avg2 (ycord a) (ycord b))))))
