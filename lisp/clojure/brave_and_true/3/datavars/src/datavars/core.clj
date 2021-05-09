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
  ;; (::error-message :mild)
  ;; (::error-message :puppy)
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
(map (fn [name] (str "Hi, " name)) ["Phil Wadler" "Simon P. Jones"])
((fn [x] (* x 3)) 8)

;; They can be named
;; also, def gives you a var.
(def special-multiplier (fn [x] (* x 3)))
(special-multiplier 8)

;; They can also be completely hideous
;; the % reminds me of call/cc though
(#(* % 3) 8)

(map #(str "Hi, " %)
     ["Rob Pike" "Dennis Ritchie"])

;; % can be suffixed:
;; with numbers...
(#(str %1 " and " %2) "puppies" "crias")

;; ...and rest
(#(identity %&) [1 2 3])

(defn inc-maker
  "Create a custom incrementor"
  [inc-by]
  #(+ % inc-by))

(def inc3 (inc-maker 3))

(inc3 7)

;;; Hobbit non-sense.
;; C + P data structure:
(def asym-hobbit-body-parts [{:name "head" :size 3}
                             {:name "left-eye" :size 1}
                             {:name "left-ear" :size 1}
                             {:name "mouth" :size 1}
                             {:name "nose" :size 1}
                             {:name "neck" :size 2}
                             {:name "left-shoulder" :size 3}
                             {:name "left-upper-arm" :size 3}
                             {:name "chest" :size 10}
                             {:name "back" :size 10}
                             {:name "left-forearm" :size 3}
                             {:name "abdomen" :size 6}
                             {:name "left-kidney" :size 1}
                             {:name "left-hand" :size 2}
                             {:name "left-knee" :size 2}
                             {:name "left-thigh" :size 4}
                             {:name "left-lower-leg" :size 3}
                             {:name "left-achilles" :size 1}
                             {:name "left-foot" :size 2}])

(defn matching-part
  [part]
  ;; #"str" denotes Regex
  {:name (clojure.string/replace (:name part) #"^left-" "right-")
   :size (:size part)})

(defn symmetrize-body-parts
  "expects a seq of maps with :name and :size"
  [asym-body-parts]
  (loop [remaining-asym-parts asym-body-parts
         final-body-parts []]
    (if (empty? remaining-asym-parts)
      final-body-parts
      (let [[part & remaining] remaining-asym-parts]
        (recur remaining
               ;; into seems to conj these results on final body parts
               (into final-body-parts
                     (set [part (matching-part part)])))))))

(symmetrize-body-parts asym-hobbit-body-parts)
;; x is 0 in the global scope
(def x 0)
;; x is zero in the local scope, is returned to be assigned
;; (let [x 1] x)

;; inc is called on the global scope x, and is stored in the `let` x.
(let [x (inc x)] x)

;; loop and recur are complimentary peices.
(loop [iteration 0]
  (println (str "Iteration " iteration))
  (if (> iteration 3)
    (println "Goodbye!")
        (recur (inc iteration))))

;; Regex find
(re-find #"^left-" "left-eye")
(re-find #"^left-" "cleft-chin")

(reduce + [1 2 3])
(reduce + 1000 [1 2 3])

(defn better-symmetrize-body-parts
  "'ere we go 'ere we go"
  [asym-body-parts]
  (reduce (fn [final-body-parts part]
            (into final-body-parts
                  (set [part (matching-part part)])))
          []
          asym-body-parts))

(better-symmetrize-body-parts asym-hobbit-body-parts)

(defn hit
  [asym-body-parts]
  (let [sym-parts (better-symmetrize-body-parts asym-body-parts)
        body-part-size-sum (reduce + (map :size sym-parts))
        target (rand body-part-size-sum)]
    (loop [[part & remaining] sym-parts
           accumlated-size (:size part)]
      (if (> accumlated-size target)
        part
        (recur remaining (+ accumlated-size (:size (first remaining))))))))

;; Eval to see what part of the hobbit was hit.
;; Non-deterministic, if the `rand` didn't give it away.
(hit asym-hobbit-body-parts)

;;; EXERCISES:
;; 1) use the str / vector / list / hash-map / hash-set funcs.
;; 1A: Will do over time.
;; 2) Write a function that takes a number and adds 100 to it
(defn plus-100
  "You have a number, but what if it were 100 bigger?"
  [x]
  (+ 100 x))

(plus-100 6)
;; 3) Write a function dec-maker, like inc-maker but reverse
(defn dec-maker
  "Custom decrementing in the palm of your hand"
  [x]
  #(- % x))

(def dec9 (dec-maker 9))
(dec9 10)

(def minus-100 (dec-maker 100))
(minus-100 (plus-100 6))

;; 4) write mapset, map but it returns a set.
(defn mapset
  "Map but gives you a set"
  [func lst]
  (reduce (fn
            [next-set elm]
            (conj next-set (func elm)))
          #{}
          lst))

(mapset identity '(1 2 3 3))
(mapset inc '(1 2 3 3))
;; 5) Symmetrize Body Parts but it is HC'd to 5, skipping favor of ...
;; 6) Symmeterize body part but it's variadic!
(defn gen-match-part-once
  [part regex num]
  {:name (clojure.string/replace (:name part) regex (str (+ num 1)))})

(defn gen-more-parts
  [part regex total-iter acc]
  (loop [next-iter total-iter
         next-acc acc]
    (if (<= next-iter 0)
      next-acc
      (recur (- next-iter 1)
             (into next-acc (set [(gen-match-part-once part regex next-iter)]))))))


(gen-more-parts {:name "1-leg"} #"^1-" 8 [])

(def asym-spider-parts [{:name "head" :size 1}
                        {:name "1-leg" :size 6}])
(defn gen-symmeterize-body-parts
  [parts regex total]
  (print "SOMETHING"))
(gen-symmeterize-body-parts asym-spider-parts #"^1-" 8)
