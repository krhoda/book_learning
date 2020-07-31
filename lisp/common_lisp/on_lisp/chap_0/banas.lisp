;;;; Describe Whole Program Comment
;;; Regular top-level Comment
(defun hello ()
  ;; Indented comment
  (print "Hello World")) ; After Code.

(defun hello-world ()
  ;; What magic is this fmt string?
  ;; ~a show value
  ;; ~s show quotes around val
  ;; ~10a adds 10 spaces for value
  ;; ~10@a adds 10 spaces for value
  (format t "Hello world ~%"))

;;; Global vars
(defvar *name* (read))

;;; Let's write a program!
(defun hello-prog ()
  (print "What's your name?")
  (defun hello-you (*name*)
	(format t "Hello ~a! ~%" *name*))

  (setq *print-case* :capitalize) ; :upcase / :downcase
  (hello-you *name*))

(+ 5 4) ; 9
(+ 5 (- 6 2)) ; 9

(defvar *number* 0)
(setf *number* 6)
(+ *number* *number*)

;;; more fmt String stuff:
(defun fmt-zoo ()
  (format t "Number with commas ~:d ~%" 10000000)
  (format t "PI to 5 chars ~5f ~%" 3.141593)
  (format t "PI to 4 decimals ~,4f ~%" 3.141593)
  (format t "10 Percent ~,,2f ~%" .10)
  (format t "10 Dollars ~$ ~%" 10))
(defun math-zoo () ()
  (+ 5 4)
  (- 5 4)
  (* 5 4)
  (/ 5 4)
  (/ 5 4.0)
  (rem 5 4)
  (mod 5 4)
;;; Continues with several others, like min max eq oddp numberp etc etc.
;;; C+P'd the rest:
  (format t "(expt 4 2) = ~d ~%" (expt 4 2)) ; = Exponent 4^2
  (format t "(sqrt 81) = ~d ~%" (sqrt 81)) ; = 9
  (format t "(exp 1) = ~d ~%" (exp 1)) ; = e^1
  (format t "(log 1000 10) = ~d ~%" (log 1000 10)) ; = 3 = Because 10^3 = 1000
  (format t "(eq 'dog 'dog) = ~d ~%" (eq 'dog 'dog)) ; = T Check Equality
  (format t "(floor 5.5) = ~d ~%" (floor 5.5)) ; = 5
  (format t "(ceiling 5.5) = ~d ~%" (ceiling 5.5)) ; = 6
  (format t "(max 5 10) = ~d ~%" (max 5 10)) ; = 10
  (format t "(min 5 10) = ~d ~%" (min 5 10)) ; = 5
  (format t "(oddp 15) = ~d ~%" (oddp 15)) ; = T Check if 15 is odd
  (format t "(evenp 15) = ~d ~%" (evenp 15)) ; = NIL = FALSE Check if 15 is even
  (format t "(numberp 2) = ~d ~%" (numberp 2)) ; = T Is 2 a number
  (format t "(null nil) = ~d ~%" (null nil))) ; = T Is something equal to nil

(defun equal-zoo () ()
  (defparameter *my-name* 'Me)
  ;; eq is for symbol to var comparison.
  (format t "(eq *my-name* 'Me) = ~d ~%" (eq *my-name* 'Me))

  ;; equal is more widely applicable, I think
  (format t "(equal 'car 'truck) = ~d ~%" (equal 'car 'truck))
  (format t "(equal 10 10) = ~d ~%" (equal 10 10))
  (format t "(equal 5.5 5.3) = ~d ~%" (equal 5.5 5.3))
  (format t "(equal \"string\" \"String\") = ~d ~%" (equal "string" "String"))
  (format t "(equal (list 1 2 3) (list 1 2 3)) = ~d ~%"
		  (equal (list 1 2 3) (list 1 2 3)))
  ;; equalp is loose about decimal places and case sensativity
  (format t "(equalp 1.0 1) = ~d ~%" (equalp 1.0 1))
  (format t "(equalp \"Derek\" \"derek\") = ~d ~%" (equalp "Derek" "derek")))

(defun age-checker (x)
  (if (>= x 18)
	  (format t "You can vote~%")
	  (format t "You can't vote~%")))

;;; This bit didn't run, it incorrectly set to symbols?
;; (defvar *num* 2)
;; (defvar *num-2* 2)
;; (defvar *num-3* 2)

;; (if (= *num* 2)
;;   (progn
;; 	(set *num-2* (* *num-2* 2))
;; 	(set *num-3* (* *num-3* 2)))
;;   (format t "It's not two..."))

;;; Boolean fun:
(defun get-grade (age)
  (case age
	(5 (print "Kindergarten"))
	(6 (print "First Grade"))
	(otherwise (print "Hard Knocks"))))

(defun magic-door (password)
  (when (equal password "open sesame")
	(format t "Literary referece achieved!")))

(defun is-puppy (dog-age)
  (cond ((>= dog-age 1)
		 (format t "This is a dog, not a puppy"))
		((< dog-age 0)
		 (format t "This is a time-traveling dog, possibly a puppy"))
		(t (format t "This is a puppy"))))


(loop for x from 1 to 10
	  do (print x))

(setq x 1)
(loop
  (format t "~d ~%" x)
  (setq x (+ x 1))
  (when (> x 10) (return x)))

(loop for x in '(Dog Pup Mutt) do
	  (format t "~s ~%" x))

;;; Inclusive on both ends.
(loop for y from 100 to 110 do
	  (format t "~s ~%" y))

;;; Prints 0 -> 11 inclusive.
(dotimes (y 12)
  (print y))

;;; Super lists.
(cons 'superman 'batman)
(list 'superman 'batman 'aquaman)
(cons 'aquaman '(superman batman))

(format t "First: ~a ~%" (car '(superman batman aquaman)))
(format t "Rest: ~a ~%" (cdr '(superman batman aquaman)))

;;; Type Constructor Style:
(format t "Second: ~a ~%" (car (cdr '(superman batman aquaman))))

;;; Idiomatic Style
(format t "Second: ~a ~%" (cadr '(superman batman aquaman)))
(format t "Fourth: ~a ~%" (cadddr '(superman batman aquaman flash catwoman)))
(format t "Fifth and beyond: ~a ~%" (cddddr '(superman batman aquaman flash catwoman)))
;;; More than 4 'a' or 'd's is not allowed.
;;; Type Contrstructor Style would be needed to reach someone beyond flash as a singleton.

;;; List traversal:
(format t "Is 3 in list = ~a ~%" (if (member 3 '(2 4 6)) 't nil))

(append '(just) '(some) '(random words))
