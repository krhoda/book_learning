(ns datavars.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!")
  ;; Normal if
  (if true
    (println "By Zeus's hammer!")
    (println "By Neptune's trident!"))
  ;; Multistatement if
  (if true
    (do (println "Success")
        "March on!")
    (do (println "Failure")
        "Halt!"))
  ;; Execute multiples statements and returns
  (when true
    (println "something")
    "something else")
  (nil? 1)
  (nil? nil)
  ;; or returns first truthy
  (or false nil :not-nothing) ; => :not-nothing
  ;; and returns last truthy or first falsey
  (and :puppy :dog) ; => :dog
  (and :puppy :dog nil :paw) ; => nil
  (::error-message :mild)
  (::error-message :puppy)
  )

(defn error-message
  [severity]
  (str "OH NO! "
       (if (= severity :mild)
         "o well"
         "!!!!!")))

;;; Map literal
({})
({:first-name "Spot" :last-name "Waggle"})
;; String key, func val
({"plus-func" +})
({:name {:first "John" :middle "Jacob" :last "Jingleheimerschmidt"}})

;; all the same
(get (hash-map :a 1 :b 2) :b)
(:b (hash-map :a 1 :b 2))
((hash-map :a 1 :b 2) :b)

;; return if doesn't exist.
(:c (hash-map :a 1 :b 2) "whoops")

;; nested traversal
(get-in (hash-map :a 1 :b (hash-map :c "puppy")) [:b :c])

;;; vector zero index, conj onto back
(get [3 2 1] 0)
(vector "I" "like" "puppies")
(conj [1 2] 3)

;;; linked lists:
(nth '(1 2 3 4) 0)
(nth (list :a "b" 3) 2)
(conj '(2 3) 1)

;;; hash sets
#{"thing" 22 :other-thing}

;; Drops the duplicates, #{1 2}
(hash-set 1 1 2)
(contains? #{:a :b} :a)
(contains? #{:a :b} "dog")
(contains? #{nil} nil)
;; you can do this, but y?
(:a #{:a :b})

(map inc (vector 0 1 2))
(map inc '(0 1 2))

(defn my-const
  "takes and needs nothing"
  []
  "Nothing")

(defn my-print
  "takes and returns anything"
  [x]
  (println x))

(defn my-eq
  "takes and compares anything"
  [x y]
  (= x y))

(defn multi-arity
  ;; 3-arity arguments and body
  ([first-arg second-arg third-arg]
   (do-things first-arg second-arg third-arg))
  ;; 2-arity arguments and body
  ([first-arg second-arg]
   (do-things first-arg second-arg))
  ;; 1-arity arguments and body
  ([first-arg]
   (do-things first-arg)))

;;; leveraging recursion and the above, we get default args:

(defn x-chop
    "Contrived example"
    ([name chop-type]
     (str "I " chop-type " chop " name))
    ([name]
     (x-chop name "karate")))

(defn codger-comm
  [whippersnapper]
  (str "Get off my lawn, " whippersnapper))

(defn codger
  [& whipersnappers]
  (map codger-comm whipersnappers))
