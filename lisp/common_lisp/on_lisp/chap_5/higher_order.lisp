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

;;; 5.2 "destructive counter-parts"
;;; Or, adding Scheme's ! operator to CL

;;; Our global hash table of destructive functions
(defvar *!equivs* (make-hash-table))

;;; get the destructive counter-part from the global hash
(defun ! (fn)
  "Use destructive counter-part if defined, if not use the function"
  (or (gethash fn *!equivs*) fn))

;;; set destructive counter-part.
(defun def! (fn fn!)
  "Set destructive counter-part"
  (setf (gethash fn *!equivs*) fn!))

; Confusing Example
(def! #'remove-if #'delete-if) ; => #'DELETE-IF
(setq lst '(1 2 3 4 5)) ; => (1 2 3 4 5)
(remove-if #'oddp lst) ; => (2 4)
lst ; => (1 2 3 4 5) remove-if is non-destructive.
(funcall (! #'remove-if) #'oddp lst) ; => (2 4) makes sense
lst ; => (1 2 4)  WHY DID ONE COME BACK?!?!
(setq lst-two '(1 2 3 4 5)) ; => (1 2 3 4 5)
(delete-if #'oddp lst-two) ; => (2 4)
lst-two ; => (1 2 4) WHATS WRONG WITH DELETE-IF???

;;; 5.3 Get the memo.
(defun memoize (fn)
  "Memoize utility, does NOT account for key-word args or multi-value returns"
  ;;; let over
  (let ((cache (make-hash-table :test #'equal)))
	;;; lambda
	#'(lambda (&rest args)
		(multiple-value-bind
		  (val win)
		  (gethash args cache)
		  ;;; If win exists, return val.
		  (if win
			  val
			  ;;; otherwise compute n cache
			  (setf (gethash args cache)
					(apply fn args)))))))

(setq slowid (memoize #'(lambda (x) (sleep 5) x)))
(time (funcall slowid 1)) ; will run for 5 seconds.
(time (funcall slowid 1)) ; will run for 0.000 seconds.

; compose
; can you tell I like haskell?
(defun compose (&rest fns)
  (if fns
	  ; let over...
	  (let ((fn1 (car (last fns)))
			(fns (butlast fns)))
	  ; lambda ...
	  #'(lambda (&rest args)
		  (reduce #'funcall fns
				  :from-end t
				  :initial-value (apply fn1 args))))
	  #'identity))

(setq inc-list (compose #'(lambda (x) (* x x)) #'1+))
(funcall inc-list 2) ; => 9
(funcall (compose #'1+ #'find-if) #'oddp '(2 3 4)) ; => 4
