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
