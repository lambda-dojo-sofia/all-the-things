(ns dojo.core

  (:gen-class))

(require '[clojure.set])



;; leg -> log -> cog

(def start "leg")
(def end "cog")
(def dict (into #{} (line-seq (clojure.java.io/reader "dictionary.txt"))))

(defn same-len [start]
  (fn [word] (= (count start) (count word))))

(def input-dict (filter (same-len start) dict))


(defn off-by-one? [current]
  (fn [word]
    (= 1 (count (filter false? (map = word current))))))

(defn neighbours [word chain]
  (clojure.set/difference (into #{} (filter (off-by-one? word) input-dict))
                  (set chain)))

(defn word-chain [start end]
  (loop [chain [start]
         current-word start
         words (neighbours current-word chain)]
    (if (any #(contains? % end ) words )
      (concat chain end)
      (recur
       (map (fn [word]
             (neighbours word (concat chain current-word))) words)))))

(defn -main
  ""
  [& args]
  (println "Hello, World!"))
