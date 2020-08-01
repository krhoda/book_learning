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

(defun math-zoo ()
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

(defparameter *nums* '(2 4 6))
(push 1 *nums*)

(format t "2nd Item in list ~a ~%" (nth 2 *nums*)) ; Result: 4, zero indexed.

;;; No more heroes anymore
;;; P List, stored with :key val. Looks like Elixir/Erlang.
(defvar superman (list :name "Superman" :secret-id "Clark Kent"))
(defvar *hero-list* nil)

;;; TODO: More info about fmt?
(push superman *hero-list*)
(dolist (hero *hero-list*)
  (format t "~{~a: ~a ~}~%" hero)) ; Result: NAME Superman SECRET-ID Clark Kent

(defparameter *heroes*
  '((Superman (Clark Kent))
	(Flash (Barry Allen))
	(Batman (Bruce Wayne))))

(format t "Superman Data: ~a ~%" (assoc 'superman *heroes*))
;;; Just a list:
(format t "Superman Data: ~a ~%" (cadr (assoc 'superman *heroes*)))

(defun get-avg (num-1 num-2)
  (/ (+ num-1 num-2) 2))

(defun print-list (w x &optional y z)
  (format t "List = ~a ~%" (list w x y z)))

(defvar *total* 0)
(defun one-use-sum (&rest nums)
  (dolist (num nums)
	(setf *total* (+ *total* num)))
  (format t "Sum ~a ~%" *total*))

(defun key-print-list (&optional &key x y z)
  (format t "List: ~a ~%" (list x y z)))

(defun difference (num1 num2)
  (return-from difference (- num1 num2)))

(defparameter *hero-size*
  '((Superman (6 ft 3 in) (230 lbs))
	(Flash (6 ft 0 in) (190 lbs))
	(Batman (6 ft 2 in) (210 lbs))))

(defun get-hero-data (size)
  (format t "~a ~%"
		  ;; Quasi quote string interpolation.
		  `(,(caar size) is ,(cadar size) and ,(cddar size))))

(format t "A number ~a ~%" (mapcar #'numberp '(1 2 3 dog cat)))

;;; Local function inside of function, flet
(flet ((double-it (num)
		 (* num 2))
	   (triple-it (num)
		 (* num 3)))
  (triple-it (double-it 10)))

;;; To allow local functions to refer to one another.
(labels ((double-it (num)
		   (* num 2))
		 (quad-it (num)
		   (double-it (double-it num))))
  (quad-it 5))

;;; Multiple value returns
(defun squarez (num)
  (values (expt num 2) (expt num 3)))

;;; Multiple value destructuring
(multiple-value-bind (a b) (squarez 2)
  (format t "2^2 = ~d 2^3 = ~d~%" a b))

(defun times-3 (x) (* x 3))
(defun times-4 (x) (* x 4))

(defun multiples (mult-func max-num)
  (dotimes (x max-num)
	(format t "~d : ~d ~%" x (funcall mult-func x))))

(multiples #'times-3 10)
(multiples #'times-4 10)

(mapcar (lambda (x)
		  (print (* x 2)))
		'(1 2 3))

(defvar *m-num* 2)
(defvar *m-num-2* 0)

(defmacro ifit (condition &rest body)
  `(if, condition (progn ,@body) (format t "Something else ~%")))

(ifit (> 1 0)
	  (print "hello")
	  (print "goodbye"))

(ifit (> 0 1)
	  (print "hello")
	  (print "goodbye"))

(defun add (num1 num2)
  (let ((sum (+ num1 num2)))
	(format t "~a + ~a = ~a" num1 num2 sum)))

(defmacro letx (var val &rest body)
  `(let ((,var , val)) ,@body))

(defun subtract (num1 num2)
  (letx dif (- num1 num2)
		(format t "~a - ~a = ~a" num1 num2 dif)))

(defclass animal ()
  (name sound))

(defparameter *dog* (make-instance 'animal))
(setf (slot-value *dog* 'name) "Pup")
(setf (slot-value *dog* 'sound) "Yip")

(slot-value *dog* 'name) ; => Pup

(defclass mammal ()
  ((name
	 :initarg :name
	 :initform (error "Must provide a name"))
   ;; Autogen getters / setters.
   (sound
	:initarg :sound
	:initform "No Sound"
	:accessor mammal-sound)
   ;; Getter only.
   (secret
	:initarg :secret
	:initform "is boring"
	:reader mammal-secret)
   ;; Setter only.
   (post-it
	:initarg :post-it
	:initform "Nothing said yet"
	:writer mammal-post-it)))

(defparameter *king-kong*
  (make-instance 'mammal :name "King Kong" :sound "Rawwr" :secret "Likes the attention, even if it's negative"))

(format t "~a says ~a ~%don't tell anyone ~a ~a ~%"
		(slot-value *king-kong* 'name)
		(slot-value *king-kong* 'sound)
		(slot-value *king-kong* 'name)
		(slot-value *king-kong* 'secret))

(defgeneric make-sound (mammal))
(defmethod make-sound ((the-mammal mammal))
	(format t "~a says ~a ~%don't tell anyone ~a ~a ~%"
		(slot-value the-mammal 'name)
		(slot-value the-mammal 'sound)
		(slot-value the-mammal 'name)
		(slot-value the-mammal 'secret)))

(defparameter *fluffy* (make-instance 'mammal :name "Fluffy" :sound "Mew" :secret "Is scared of heights"))

(make-sound *fluffy*)

;;; Manually defined setter
(defgeneric (setf mammal-name) (value the-mammal))
(defmethod (setf mammal-name)
  (value (the-mammal mammal))
  (setf (slot-value the-mammal 'name) value))

;;; Manually defined getter
(defgeneric mammal-name (the-mammal))
(defmethod mammal-name ((the-mammal mammal))
  (slot-value the-mammal 'name))

(setf (mammal-name *king-kong*) "Mr. Kong")
(setf (mammal-sound *king-kong*) "ROOOOAAAAR")
(make-sound *king-kong*)

;;; Multi-Inheritance is a list? Video mentioned a comma seperated list? I doubt it...
(defclass dog (mammal) ())
(defparameter *rover*
  (make-instance 'dog :name "Rover" :sound "Woof"))

(make-sound *rover*)

(defparameter names (make-array 3))
(setf (aref names 1) 'Pup)

;;; Make a 3 by 3 array
(setf num-array (make-array '(3 3)
							:initial-contents '((0 1 2) (3 4 5) (6 7 8))))

;;; Cycle through and print the array
(dotimes (x 3)
  (dotimes (y 3)
	(print (aref num-array x y))))

(defparameter pups (make-hash-table))
(setf (gethash '102 pups) '(Pup Dog))
(setf (gethash '103 pups) '(Mutt Dog))
(format t "~a ~%" (gethash '102 pups))

;;; Range over a map
(maphash #'(lambda (k v) (format t "~a = ~a ~%" k v)) pups)
(remhash '103 pups)
(format t "Removed dog from table... ~%")
(maphash #'(lambda (k v) (format t "~a = ~a ~%" k v)) pups)

;;; Structs
(defstruct customer name address favorite-color)
(defparameter paulsmith (make-customer
				 :name "Paul Smith"
				 :address "123 boring"
				 :favorite-color "Puece"))

(format t "~a ~%" (customer-name paulsmith))
(format t "~a ~%" (customer-favorite-color paulsmith))
(setf (customer-favorite-color paulsmith) "Teal")
(format t "~a ~%" (customer-favorite-color paulsmith))
(write paulsmith)

(with-open-file (my-stream "test.txt" :direction :output :if-exists :supersede)
  (print "Some Random Text" my-stream))

(let ((in (open "test.txt" :if-does-not-exist nil)))
  (when in
	(loop for line = (read-line in nil)
		  while line do (format t "~a~%" line))
	(close in)))
