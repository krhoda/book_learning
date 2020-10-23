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

; compose, limited to single arg excluding the original, single return including the original
(defun compose (&rest fns)
  (if fns
	  ; let over...
	  (let ((fn1 (car (last fns)))
			(fns (butlast fns)))
	  ; ... lambda
	  #'(lambda (&rest args)
		  (reduce #'funcall fns
				  :from-end t
				  :initial-value (apply fn1 args))))
	  #'identity))

(setq inc-list (compose #'(lambda (x) (* x x)) #'1+))
(funcall inc-list 2) ; => 9
(funcall (compose #'1+ #'find-if) #'oddp '(2 3 4)) ; => 4

; the original example is a lot more uncomfortable...
; ... but anyway, lets talk about puppies:
; this form of code often appears:
(mapcar #'(lambda (pup)
			(if (spotted pup)
				(adorable pup)
				(vcute pup)))
		puppies)
; lets define this quite goofily:
(setq puppies '(1 2 3 4 5))
(defun spotted (x) (oddp x))
(defun adorable (x) (print "ADORABLE"))
(defun vcute (x) (print "V CUTE"))

; Let's generalize that with function builders ...
(defun fun-if (test then &optional else)
  #'(lambda (x)
	  (if (funcall test x)
		  (funcall then x)
		  (if else (funcall else x)))))


; ... making the above renderable as:
(mapcar (fun-if #'spotted #'adorable #'vcute) puppies)

; function intersection, do ALL fns return true?
(defun fun-ix (fn &rest fns)
  (if (null fns)
	  fn
	  (let ((chain (apply #'fun-ix fns)))
		#'(lambda (x)
			; AND
			(and (funcall fn x) (funcall chain x))))))

(mapcar (fun-ix #'spotted #'evenp) puppies) ; => (NIL NIL NIL NIL NIL)

; anti function intersection, do ANY fns return true?
(defun fun-ex (fn &rest fns)
  (if (null fns)
	  fn
	  (let ((chain (apply #'fun-ex fns)))
		#'(lambda (x)
			; OR
			(or (funcall fn x) (funcall chain x))))))

(mapcar (fun-ex #'spotted #'evenp) puppies) ; => (T T T T T)

; higher-order list-recurser
(defun list-rec (rec &optional base)
  (labels ((self (lst)
			 (if (null lst)
				 (if (functionp base)
					 (funcall base)
					 base)
				 (funcall rec (car lst)
						  #'(lambda () (self (cdr lst)))))))
	#'self))

; this
(defun our-length (lst)
  (if (null lst) 0 (1+ (our-length (cdr lst)))))

; becomes this:
(setq better-len
	  (list-rec #'(lambda (next-car recurser) (1+ (funcall recurser))) 0))

(our-length puppies)
(funcall better-len puppies)

; and this
(defun our-every (fn lst)
  (if (null lst)
	  t
	  (and (funcall fn (car lst))
		   (our-every fn (cdr lst)))))

; becomes more specific?
(setq better-every-odd
	  (list-rec
	   #'(lambda (elm f)
		   (and (oddp elm) (funcall f)))
	   t))

(our-every #'(lambda (x) (or (evenp x) (oddp x))) puppies)
(funcall better-every-odd puppies)
(funcall better-every-odd '(1 3 5))

(setq cpy-list
	  (list-rec #'(lambda (elm f) (cons x (funcall f)))))

(setq rmv-dups
	  (list-rec
	   #'(lambda (elm f) (adjoin x (funcall f)))))

(setq find-if-so
	  (list-rec
	   #'(lambda (elm f) (if (fn x) x (funcall f)))))

(setq some-fun
	  (list-rec
	   #'(lambda (elm f) (or (fn x) (funcall f)))))

;; TODO: test, left off on PG 70.
