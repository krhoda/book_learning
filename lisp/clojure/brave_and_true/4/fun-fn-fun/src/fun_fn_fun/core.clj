(ns fun-fn-fun.core
  (:gen-class))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))

(defn titleize
  [topic]
  (str topic " for the Brave and True"))

; Generalize folds etc. over data structures
; Vecs
(map titleize ["Hamsters" "Ragnarok"])
; Lists
(map titleize '("Empathy" "Decorating"))
; Sets
(map titleize #{"Elbows" "Soap Carving"})
; Maps transform into pairs
(map #(titleize (second %)) {:dont-do-this "Chillin"})

; Convert to unified data type, "seq"
(=
 (seq '(1 2 3))
 (seq [1 2 3])
 (map second (seq {:one 1 :two 2 :three 3})))

;; Sets can get reordered...?
(seq #{1 2 3})

;; Cast back as:
(into {} (seq {:a 1 :b 2 :c 3}))
;; A way to cast in general, though the polymorphism makes this less interestring:
;; Flips a from vec...
(into '() [1 2 3])
;; ...but not a list
(into [] '(1 2 3))

;; Maddness ensues
(into #{} [1 2 3])
(into #{} '(1 2 3))
(into '() #{1 2 3})
(into [] #{1 2 3})

;; The classic, the beloved
(map inc [1 2 3])

;; multiple collections are sequentially fed as arguments into the
;; fn to be mapped
;; NOTE: ":as" allows us to avoid destructring.
(let [[:as prefix] ["one: " "two: " "three: "]
      [:as suffix] ["1" "2" "3"]]
 (map str prefix suffix))

;; Vampiric example of mapping
(def human-consumption [8.1 7.3 6.6 5.0])
(def critter-consumption [0.0 0.2 0.3 1.1])
(defn unify-diet-data
  [human critter]
  {:human human
   :critter critter})

(map unify-diet-data human-consumption critter-consumption)

;; Higher Order fun, pass collections of functions.

(def sum #(reduce + %))
(def avg #(/ (sum %) (count %)))
(defn stats
  [numbers]
  ;; Note the inversion, the list is passed to each function
  (map #(% numbers) [sum count avg]))

(stats [3 4 10])
(stats [80 1 44 13 6])

;; Programmatic destructuring
(def identities
  [{:alias "Batman" :real "Bruce Wayne"}
   {:alias "Spiderman" :real "Peter Parker"}])

(map :real identities)

;; Use reduce transform maps in a non-destructive way.
(reduce (fn [new-map [key val]]
          (assoc new-map key (inc val)))
        {}
        {:max 100 :min 0})

;; Can also filter maps based on key/val
(reduce (fn [new-map [key val]]
          (if (> val 4)
            (assoc new-map key val)
            new-map))
        {}
        {:human 4.1
         :critter 3.9})

;; If you need to update or filter a data structure, use reduce.

;; Impl map in terms of reduce.
;; NOTE: Not type agnostic, but good enough.
(defn my-map
  [f org]
  ;; %1 is the accumulator, %2 is the current value of org.
  (reduce #(conj %1 (f %2)) [] org))

(my-map inc [111 222 333])

;; TODO: Impl filter and some in terms of reduce here:

(def z-ints [1 2 3 4 5 6 7 8 9 10])

(defn my-filter
  [f org]
  (reduce #(if (f %2)
             (conj %1 %2)
             %1)
          []
          org))

(my-filter even? z-ints)

(defn my-some
  [f org]
  (reduce
   #(if (f %2)
      :true
      %1)
   nil
   org))

(my-some even? z-ints)
(my-some #(< 100 %) z-ints)

(take 3 z-ints)
(drop 3 z-ints)

;; -while continue until a predicate function returns false:
(def food-journal
  [{:month 1 :day 1 :human 5.3 :critter 2.3}
   {:month 1 :day 2 :human 5.1 :critter 2.0}
   {:month 2 :day 1 :human 4.9 :critter 2.1}
   {:month 2 :day 2 :human 5.0 :critter 2.5}
   {:month 3 :day 1 :human 4.2 :critter 3.3}
   {:month 3 :day 2 :human 4.0 :critter 3.8}
   {:month 4 :day 1 :human 3.7 :critter 3.9}
   {:month 4 :day 2 :human 3.7 :critter 3.6}])

(take-while #(< (:month %) 3) food-journal)
;; Drop first 2 entries, not all entries where the predicate holds.
(drop-while #(> (:human %) 5) food-journal)

;; Can do some lens like things:
;; Take only months under 4...
(take-while #(< (:month %) 4)
            ;; ...after dropping all months under 2
            (drop-while #(< (:month %) 2) food-journal))

;; filter processes the whole list, doesn't just break when the first
;; predicate is met.
(filter #(< (:human %) 5) food-journal)

;; some tests if at least 1 entry meets the predicate
(some #(> (:critter %) 5) food-journal)
(some #(> (:critter %) 3) food-journal)

;; Can be more informative than just a true/nil using JS tricks.
(some #(and (> (:critter %) 3) %) food-journal)

;; Basic
(sort [3 4 1 2])
;; Complex
(sort-by count ["aaa" "c" "bb"])

;; Concat is seq agnostic
(concat [1 2] [3 4])
(concat '(1 2) '(3 4))
(concat [1 2] '(3 4))
