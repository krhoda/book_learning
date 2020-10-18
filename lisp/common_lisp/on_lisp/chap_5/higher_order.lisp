;;; 5.1
;;; Compliment removes the needs for the "-not" class of functions:
(remove-if #'evenp '(1 2 3)) ; => (1 3)
;;; is the same as (remove-if-not #'oddp (1 2 3))
;;; remove-if-not is deprecated in favor of:
(remove-if (complement #'oddp) '(1 2 3)) ; => (1 3)

;;; This higher order function works with dynamic or lexical scope
(defun my-joiner (obj)
  (typecase obj
	(cons #'append)
	(number #'+)))
;;; It works in dynamic because the number of functions it can return is fixed
;;; We can define polymorphic join
(defun my-join (&rest args)
  (apply (my-joiner (car args)) args))

(my-join 1 2 3) ; => 6
(my-join '((a b) (c d))) ; => (A B C D)
(my-join '(a b) (c d)) ; => (A B C D)
(my-join '((1 2) (3 4)))

;;; Earlier example, make-adder:
;;; (defun make-adder (n) #'(lambda (x) (+ x n)))
;;; requires lexical scope because n is captured in the call to make adder,
;;; and utilized by the returned function on all subsequent

;;; complement's definition is similarly dependent on lexical scope:
;;; (defun complement (fn) #'(lambda (&rest args) (not (apply fn args))))

;;; 5.2
(defvar *!equivs* (make-hash-table))

(defun ! (fn)
  (or (gethash fn *!equivs*) fn))

(defun def! (fn fn!)
  (setf (gethash fn *!equivs*) fn!))
