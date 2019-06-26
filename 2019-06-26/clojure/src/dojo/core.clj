(ns dojo.core
  (:gen-class))

(require '[clojure.set :as set])

(slurp )

;; leg -> log -> cog

(def start "leg")
(def end "cog")
(def dict {})

(defn same-len [start]
  (fn [word] (= (count start) (count word))))

(def input-dict (filter (same-len start) dict))

((off-by-one "leg") "log")
((off-by-one "leg") "cog")
(defn off-by-one [current]
  (fn [word]
    (= 1 (count (filter false? (map = word current))))))

(defn neigbours [word chain]
  (set/difference (into #{} (filter off-by-one input-dict))
                  chain))



(defn -main
  ""
  [& args]
  (println "Hello, World!"))
