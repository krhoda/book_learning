;;; This declaration turns on the tail-recursion-optimizer
;;; (proclaim '(optimize speed))

(defun our-remove-if (fn lst)
  (if (null lst)
	  nil
	  (if (funcall fn (car lst))
		  (our-remove-if fn (cdr lst))
		  (cons (car lst) (our-remove-if fn (cdr lst))))))

;; (defun brittle-behave (animal)
;;   (case animal
;; 	(dog (wag-tail)
;; 	 (bark))
;; 	(rat (scurry)
;; 	 (squeak))
;; 	(cat (rub-legs)
;; 	 (scratch-carpet))))

;; (defun extensible-behave (animal)
;;   (funcall (get animal 'behavior)))

;; (setf (get 'dog 'behavior)
;; 	  #'(lambda ()
;; 		  (wag-tail)
;; 		  (bark)))

;;; Rats and Cats are an excercise for the reader

;;; SCIP Style closures in CL:
(let ((counter 0))
  (defun new-id () (incf counter))
  (defun reset-id () (setq counter 0)))

;;; Adder fun:
(defun make-adder (n)
  #'(lambda (x) (+ x n)))

(defun resetable-adder (n)
  #'(lambda (x &optional change)
	  (if change
		  (setq n x)
		  (+ x n))))

;;; (setq addx (restable-adder 3))
;;; (funcall addx 3) ; 6
;;; (funcall addx 100 t) ; 100
;;; (funcall addx 1) ; 101

;;; Lambda is sufficient in cases of no recursion and no need to capture local vars.
(mapcar #'(lambda (x) (+ 2 X))
		'(1 2 3))

;;; It can capture surrounding scope
(defun list+ (lst n)
  (mapcar #'(lambda (x) (+ x n))
		  lst))

;;; This is the limitation of let:
;;; (let ((x 10) (y x)) y)
;;; y cannot refer to x.

;;; Labels is a special form of let. Namespaces in labels can refer to one another, allowing
;;; (co/tail-)recursion.
(labels ((inc (x) (1+ x)))
  (inc 3))

(defun count-instances (obj lsts)
  (labels ((instances-in (lst)
			 (if (consp lst)
				 (+ (if (eq (car lst) obj) 1 0)
					(instances-in (cdr lst)))
			 0)))
  (mapcar #'instances-in lsts)))

;;; Tail recursion is idiomatic because the compiler is optimized for it.
;;; That's awesome!
(defun our-find-if (fn lst)
  (if (funcall fn (car lst))
	  (car lst)
	  (our-find-if fn (cdr lst))))

;;; Below, Idiomatic lisp code.
;;; Demonstrates (labels ((...))) can be used to return values / tail-recurse.
;;; Hoping this ages well, but my understanding of the code is that
;;; c is the accumulator and n is the break condition.
;;; when n reachs zero, the result of adding the previous `n`s to `c`s is returned.
(defun triangle (n)
  (labels ((tri (c n)
			 (declare (type fixnum n c))
			 (if (zerop n)
				 c
				 (tri (the fixnum (+ n c))
					  (the fixnum (- n 1))))))
	(tri 0 n)))

;;; Compilation:

(defun foo (x) (+ x x)) ; => FOO
(compiled-function-p #'foo) ; => NIL
(compile 'foo) ; => FOO
(compiled-function-p #'foo) ; => T

;;; Acts as a compiling defun
(progn (compile 'bar '(lambda (x) (* x 3)))
	   (compiled-function-p #'bar)) ; => T

;;; Compile is Eval but with different optimizations in mind.
;;; Similar footguns though.

;;; 2 funcs one cannot compile.

;;; !!!
;;; (1) "defined interpretively in a non-null lexical environment"
;;; Example:
;; (let ((y 2))
  ;; (defun foo-2 (x) (+ x y)))
;; (compile foo-2)
;;; This may work, but is not promised. Better to keep things in the correct scoping.

;;; !!!
;;; (2) compiling a compiled function has no specified consequence and sounds like UB.

;;; Most Implementations WILL find and COMPILE nested funcs.
