;;; The following operators are not ideal from a FP perspective because they mutate their args.
'(set ; creates / resets var
  setf ; set but supplies the quote
  ;; changes value in place to be newvalue
  ;; assumes value exists.
  ;; (set 'x 2) === (setf x 2)
  setq ; creates / resets vars in pairs in the form of setf
  ;; ((set 'x 1) (set 'y 2)) === (setq x 1 y 2)
  psetf ; setf, but multiarg
  incf ; like ++ but for lisp
  decf ; like -- but for lisp
  push ; add elm to front of list
  pop ; remove / return elm from front of list
  pushnew ; push the elm, but only if it's not already in the list.
  rplaca ; replaces the car with the cons of the obj
  ;; (setq some-list '(one two three four))
  ;; (rplaca some-list 'uno)
  ;; => (UNO TWO THREE FOUR)
  rplacd ; replaces the cdr with the cons of the obj
  ;;(rplacd some-list (list 'dos))
  ;; => (ONE DOS)
  rotatef ; rotates values in place through madness
  shiftf  ; remove and replace
  ;; (setq x (list 'a 'b 'c)) => (A B C)
  ;; (shiftf (cadr x) 'z) => B
  ;; x => (A Z C)
  remf ;
  ;;
  remprop
  ;;
  remhash
  ;;
  )
