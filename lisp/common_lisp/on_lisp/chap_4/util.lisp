(proclaim '(inline last1 single append1 conc1 mklist))

(defun last1 (lst)
  (car (last lst)))

(defun single (lst)
  (and (consp lst) (not (cdr lst))))

(defun append1 (lst obj)
  (append lst (list obj)))

(defun conc1 (lst obj)
  (nconc lst (list obj)))

(defun mklist (obj)
  (if (listp obj) obj (list obj)))

(defun longer (x y)
  (labels ((compare (x y)
			 ;; x must exist.
			 (and (consp x)
				  ;; if y doesn't, true.
				  (or (null y)
					  ;; otherwise recurse
					  (compare (cdr x) (cdr y))))))
	;; if x and y
	(if (and (listp x) (listp y))
		;; start comparison
		(compare x y)
		;; select which ever one is the list
		(> (length x) (length y)))))

;;; Build list out of filter fn which returns the val it compares against.
;;; Quite imperative, I assume for speed's sake.
(defun filter (fun lst)
  (let ((acc nil))
	(dolist (x lst)
	  (let ((val (funcall fun x)))
		(if val (push val acc))))
	(nreverse acc)))

;;; (filter #'(lambda (x) (if (eq x 2) x nil)) '(1 2 2 3))
;;; => (2 2)

;;; Breaks list in subgroups of lists:
(defun group (source n)
  ;; Cannot create groups of zero.
  (if (zerop n) (error "zero length"))
  ;;; create our recursive op
  (labels ((rec (source acc)
			 ;;; move foward in the list n.
			 (let ((rest (nthcdr n source)))
			   ;;; if rest is a list
			   (if (consp rest)
				   ;;; add it to the list
				   (rec rest (cons (subseq source 0 n) acc))
				   ;;; otherwise, we're done, flip the list and return it.
				   (nreverse (cons source acc))))))
	;;; either traverse or return nil
	(if source (rec source nil) nil)))

;;; (group '(g a g c g g g c t t a) 3)
;;; => ((G A G) (C G G) (G C T) (T A))

(defun flatten (x)
  ;; x being whatever
  ;; acc being a list
  (labels ((rec (x acc)
			 ;; if x is null, we're done
			 (cond ((null x) acc)
				   ;; if x is a atom, cons it
				   ((atom x) (cons x acc))
				   ;; else recurse using,
				   (t (rec
					   ;; pop the first val of the list,
					   ;; this catches as we traverse the list.
					   (car x)
					   ;; recurse over the back of the list
					   ;; dropping all of it into the flattened accumulator
					   (rec (cdr x) acc))))))
	(rec x nil)))

;;; (flatten '(a b c (e f g (h i j k) l) m n (o p (q))))
;;; (A B C E F G H I J K L M N O P Q)
(defun prune (test tree)
  (labels ((rec (tree acc)
			 ;; if tree is nil, reverse + return acc
			 (cond ((null tree) (nreverse acc))
				   ;; if the current elm of tree is itself a list...
				   ((consp (car tree))
					;; ... recurse over the list ...
					(rec (cdr tree)
						 ;; ... recurse over the first elm of tree ...
						 ;; ... to possibly place in the accumulator
						 (cons (rec (car tree) nil) acc)))
				   ;; Otherwise, recurse of the rest
				   (t (rec (cdr tree)
						   ;; test the elm to see if we add it.
						   (if (funcall test (car tree))
							   acc
							   (cons (car tree) acc)))))))
	(rec tree nil)))

;;; (prune #'evenp '(1 2 3 4))
;;; =>(1 3)

;;; (prune #'evenp '(1 2 (3 4) 4 5))
;;; => (1 (3) 5)

;;; Searching functions:

;;; pretty self explanitory
;;; can use alternates to equality with named param test.
(defun before (x y lst &key (test #'eql))
  (and lst
	   (let ((first (car lst)))
		 (cond ((funcall test y first) nil)
			   ((funcall test x first) lst)
			   (t (before x y (cdr lst) :test test))))))

;;; before does not care if y is in the list.
;;; after does
;;; but is defined in terms of before.
(defun after (x y lst &key (test #'eql))
  (let ((rest (before y x lst :test test)))
	(and rest (member x rest :test test))))

(defun duplicate (obj lst &key (test #'eql))
  (member obj (cdr (member obj lst :test test))
		  :test test))

;;; TODO, understand better. What is src? do?
(defun split-if (fn lst)
  (let ((acc nil))
	(do ((src lst (cdr src)))
		((or (null src) (funcall fn (car src)))
		 (values (nreverse acc) src))
	  (push (car src) acc))))

;;; (split-if #'(lambda (x) (> x 4)) '(1 2 3 4 5 6 7 9 0))
;;; => (1 2 3 4)
;;; , (5 6 7 9 0)

;;; Comparisons
(defun most (fn lst)
  (if (null lst)
	  ;; If nil, return nil
	  (values nil nil)
	  ;; set wins and max to first result
	  (let* ((wins (car lst))
			 (max (funcall fn wins)))
		;; set obj to next elm
		(dolist (obj (cdr lst))
		  ;; set score to next obj
		  (let ((score (funcall fn obj)))
			;; when score > max ...
			(when (> score max)
			  ;; redefine wins and max
			  (setq wins obj
					max score))))
		(values wins max))))

;;; simpler most, w/o max
(defun best (fn lst)
  (if (null lst)
	  nil
	  (let ((wins (car lst)))
		(dolist (obj (cdr lst))
		  (if (funcall fn obj wins)
			  (setq wins obj)))
		wins)))

(defun mostn (fn lst)
  (if (null lst)
	  (values nil nil)
	  (let ((result (list (car lst)))
			(max (funcall fn (car lst))))
		(dolist (obj (cdr lst))
		  (let ((score (funcall fn obj)))
			(cond ((> score max)
				   (setq max score
						 result (list obj)))
				  ((= score max)
				   (push obj result)))))
		(values (nreverse result) max))))

;;; Mapping
;;; Over an arbitrary range with an optional step param.
(defun mapa-b (fn a b &optional (step 1))
  (do ((i a (+ i step))
	   (result nil))
	  ((> i b) (nreverse result))
	(push (funcall fn i) result)))

;;; The range over naturals
(defun map0-n (fn n)
  (mapa-b fn 0 n))

;;; The range over integers
(defun map1-n (fn n)
  (mapa-b fn 1 n))

;; This appears to be a manual map where succ-fn is called to get the next result
;; and test-fn is used to end the iteration.
(defun map-> (fn start test-fn succ-fn)
  (do ((i start (funcall succ-fn i))
	   (result nil))
	  ((funcall test-fn i) (nreverse result))
	(push (funcall fn i) result)))

;;; mapa-b in terms of map->
;;; (lambda
;;;   (fn a b & optional (step 1))
;;;   (map-> fn a #'(lambda (x) (> x b)) #'(lambda (x) (+ x step))))

;; Look up mapcat to understand this better
(defun mappend (fn &rest lsts)
  (apply #'append (apply #'mapcar fn lsts)))

;; (mapcars (lambda (x) (+ x x)) '(1 2 3) '(4 5)) => (2 3 6 8 10)
(defun mapcars (fn &rest lsts)
  (let ((result nil))
	(dolist (lst lsts)
	  (dolist (obj lst)
		(push (funcall fn obj) result)))
	(nreverse result)))

;;(rmapcar #'+ '(1 2 (3)) '(2 1 (3))) => (3 3 (6))
(defun rmapcar (fn &rest args)
  (if (some #'atom args)
	  (apply fn args)
	  (apply #'mapcar
			 #'(lambda (&rest args)
				 (apply #'rmapcar fn args))
			 args)))

;;; I/O:
(defun readlist (&rest args)
  (values (read-from-string
		   (concatenate 'string
						"("
						(apply #'read-line args)
						")"))))

(defun prompt (&rest args)
  (apply #'format *query-io* args)
  (read *query-io*))

(defun break-loop (fn quit &rest args)
  (format *query-io* "Entering break-loop. ~%")
  (loop
	(let ((in (apply #'prompt args)))
	  (if (funcall quit in)
		  (return)
		  (format *query-io* "~A~%" (funcall fn in))))))

;;; Symbols and Strings

;;; (mkstr 'ar "Madi" #\L #\L 0) => "ARMadiLL0"
(defun mkstr (&rest args)
  (with-output-to-string (s)
	(dolist (a args) (princ a s))))

;;; (symb 'ar "Madi" #\L #\L 0) => |ARMadiLL0|
(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

;;; Reads twice to attain uniformity of symbol:
;;; (reread 'ar "Madi" #\L #\L 0) => ARMADILL0
(defun reread (&rest args)
  (values (read-from-string (apply #'mkstr args))))

;;; Breaks symbol into composite symbols
;;; Pretty inefficient, avoid in production.
;;; (explode 'pie) => (P I E)
(defun explode (sym)
  (map 'list #'(lambda (c)
				 (intern (make-string
						  1
						  :initial-element
						  c)))
	   (symbol-name sym)))
