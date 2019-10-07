(ns best-clojure-solution.core
  (:import [org.kocakosm.jblake2.Blake2b]))


(.digest )

(apply str (map char (.getBytes "pooppoop")))

(defn stupid
  [s]
  (let [string-bytes (.getBytes s)
        string-digester (org.kocakosm.jblake2.Blake2b. 5)]
    (alength (.digest (.update string-digester string-bytes)))))

(stupid "pooppoop")

(defn five->eight
  [a b c d e]
  [(bitshift-right)])
