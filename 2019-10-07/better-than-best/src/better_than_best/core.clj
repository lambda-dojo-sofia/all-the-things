(ns better-than-best.core
    (:import (org.kocakosm.jblake2 Blake2b)))

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(def p "pooppoop")

(defn string->hash [str]
      (.digest
        (.update
          (Blake2b. (int 5))
          (bytes
            (byte-array
              (map (comp byte int)
                   str))))))
