;;; Imperative (destructive)
(defun bad-rev (lst)
  (let* ((len (length lst))
		 (ilimit (truncate (/ len 2))))
	(do ((i 0 (1+ i))
		 (j (1- len) (1- j)))
	 ((>= i ilimit))
	 (rotatef (nth i lst) (nth j lst)))))

;;; Functional
(defun good-rev (lst)
  (labels ((rev (lst acc)
			 (if (null lst)
				 acc
				 (rev (cdr lst) (cons (car lst) acc)))))
	(rev lst nil)))

;;; Multiple return vals with truncate:
(truncate 3.14) ; => 3, 0.14
;;; Only use first value:
(= (truncate 3.14) 3)
;;; grab both:
(multiple-value-bind (int frac) (truncate 3.14) (print int) (print frac))
;;; create multiple return vals:
(defun powers (x)
  (values x (sqrt x) (expt x 2)))

(multiple-value-bind (base root square) (powers 4) (list base root square))

;;; imp v fun
(defun imp (x)
  (let (y sqr)
	(setq y (car x))
	(setq sqr (expt y 2))
	(list 'a sqr)))

(defun fun (x)
  list 'a (expt (car x) 2))

;;; Do NOT return quoted lists, it is code after all!
;;; DANGEROUS:
(defun bad-exclaim (expression)
  (append expression '(oh my)))
;;; SAFE:
(defun exclaim (expression)
  (append expression (list 'oh 'my)))
