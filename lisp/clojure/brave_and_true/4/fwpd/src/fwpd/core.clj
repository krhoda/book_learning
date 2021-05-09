(ns fwpd.core)
(def filename "suspects.csv")

;; Read file from base dir.
(slurp filename)

(def vamp-keys [:name :glitter-index])
(defn str->int
  [str]
  (Integer. str))

(def conversions {:name identity :glitter-index str->int})

(defn convert
  [vamp-key value]
  ((get conversions vamp-key) value))

(convert :glitter-index "3")

(defn parse
  "Convert CSV to rows of columns"
  [s]
  (map #(clojure.string/split % #",")
       (clojure.string/split s #"\n")))

(parse (slurp filename))

(defn pairs->map
  [row-map [vamp-key value]]
  (assoc row-map vamp-key (convert vamp-key value)))

(defn rows->map
  [unmapped-row]
  (reduce pairs->map
                 {}
                 ;; Convert the row to pairs, using the column headers
                 (map vector vamp-keys unmapped-row)))

(defn mapify
  "Return a seq maqs like {:name \"name\" :glitter-index 10}"
  [rows]
  (map rows->map rows))

(first (mapify (parse (slurp filename))))

(defn glitter-filter
  [min-glitter records]
  (filter #(>= (:glitter-index %) min-glitter) records))

(glitter-filter 3 (mapify (parse (slurp filename))))

(def suspects (mapify (parse (slurp filename))))

;; EXERCISES:
;; 1) make glitter-filter return a list of names
(defn give-me-the-names
  [min-glitter records]
  (reduce #(if (>= (:glitter-index %2) min-glitter)
             (conj %1 (:name %2))
             %1)
          []
          records))

(give-me-the-names 3 suspects)

;; 2) write fn 'append' which will append a new suspect to your list of suspects
(defn append-sus-vamp
  [suslist maybe-vamp]
  (conj suslist maybe-vamp))

(append-sus-vamp suspects {:glitter-index 5 :name "Drac"})

;; 3) write fn 'validate' which will check that :name and :glitter-index are present when appending.
;; 3 cont) 'validate should accept a map of keywords to validating functions -- like 'conversions'

(def animal-noises {:dog "grrr" :cat "hsss"})
(map #(println ((get % 0) animal-noises)) {:dog "woof" :cat "meow"})

(def validators { :name #(instance? java.lang.String %) :glitter-index #(instance? java.lang.Long %) })
(defn validate
  [valid-map value]
  (not (some false? (map #((get % 1) ((get % 0) value)) valid-map))))

(validate validators {:glitter-index 6 :name "La Croix"})
(validate validators {:glitter-index "BAD" :name "La Croix"})

(defn append-sus
  [suslist sus]
  (if (validate validators sus)
    (append-sus-vamp suslist sus)
    suslist))
(append-sus suspects {:glitter-index 6 :name "La Croix"})
(append-sus suspects {:glitter-index "Invalid Data" :name "Hacker Vamp"})

;; 4) Go from map back to CSV String.
(defn save-out
  [suslist]
  (reduce
   #(str (str (:name %2) "," (:glitter-index %2) "\n") %1)
   ""
   suslist))

(save-out suspects)
