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
