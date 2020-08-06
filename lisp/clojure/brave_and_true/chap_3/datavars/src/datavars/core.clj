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
(codger "pascal" "raskell" "haskell")

;;; manditory and rest vars
(defn favorite-things
  [name & things]
  (str "Hi, " name ", here are my favorite things: "
       (clojure.string/join ", " things)))

;; destructuring
(def our-first [[first-thing]] first-thing)

;; destructuring with rest
(defn chooser
  [[first-choice second-choice & unimportant-choices]]
  (println (str "Your first choice is: " first-choice))
  (println (str "Your second choice is: " second-choice))
  (println (str "We're ignoring the rest of your choices. "
                "Here they are in case you need to cry over them: "
                (clojure.string/join ", " unimportant-choices))))

(chooser ["Marmalade", "Handsome Jack", "Pigpen", "Aquaman"])

;; pluck keys
(defn announce-treasure-loc
  [{lat :lat lng :lng}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))

(announce-treasure-loc {:lat 25 :lng 34})

;; using :keys keyword
(defn announce-treasure-loc2
  [{:keys [lat lng]}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng)))

(announce-treasure-loc2 {:lat 22 :lng 33})

;; maintaining a ref to the whole.
(defn recv-treasure-loc
  [{:keys [lat lng] :as treasure-location}]
  (println (str "Treasure lat: " lat))
  (println (str "Treasure lng: " lng))
  (println (str "Full loc: " treasure-location)))

(recv-treasure-loc {:lat 22 :lng 33})

;; Last val in form is return
(defn illustrative-function
  []
  (+ 1 304)
  30
    "joe")
(illustrative-function)

;; lambda got turned into fn
