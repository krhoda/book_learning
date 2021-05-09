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

(map inc [1 2 3])
(map str ["one: " "two: " "three: "] ["1" "2" "3"])
