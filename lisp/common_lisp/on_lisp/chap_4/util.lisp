(proclaim '(inline last1 single append1 conc1 mklist))
;;; Bookshops utility example:
;;; setup
(defun bookshops (x)
  (if (eq x 'boulder) T nil))

(setq towns '(boulder longmont))

;;; Bad implementation.
(let ((town (find-if #'bookshops towns)))
  (values town (bookshops town)))

;;; Better implementation.
(defun find-books (towns)
  (if (null towns)
	  nil
	  (let ((shops (bookshops (car towns))))
		(if shops
			(values (car towns) shops)
			(find-books (cdr towns))))))

;;; Higher order!
(defun find2 (fn lst)
  (if (null lst)
	  nil
	  (let ((val (funcall fn (car lst))))
		(if val
			(values (car lst) val)
			(find2 fn (cdr lst))))))

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
  (labels ((compare (x y))
		   ;; x must exist.
		   (and (consp x)
			 ;; if y doesn't, true.
			 (or (null y)
				 ;; otherwise recurse
				 (compare (cdr x) (cdr y)))))
	;; if x and y
	(if (and (listp x) (listp y))
		;; start comparison
		(compare x y)
		;; determine which is a list...?
		(> (length x) (length y)))))
		;; why not: (if (listp x) T nil))))

;;; Build list out of filter.
;;; Quite imperative, I assume for speed's sake.
(defun filter (fun lst)
  (let ((acc nil))
	(dolist (x lst)
	  (let ((val (funcall fn x)))
		(if val (push val acc))))
	(nreverse acc)))

;;; TODO: Understand better:
(defun group (source n)
  (if (zerop n) (error "zero length"))
  (labels ((rec (source acc)
			 (let ((rest nthcdr n source))
			   (if (consp rest)
				   (rec rest (cons (subseq source 0 n) acc))))))
	(if source (rec source nil) nil)))
