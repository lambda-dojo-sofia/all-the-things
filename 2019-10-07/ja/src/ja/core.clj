(ns ja.core
  (:use [clojure.test :only [with-test is]]))

(defn hash-str [input]
  (-> (Blake2b. 5)
      (.update (.getBytes input))
      (.digest)
      (vec)))

(with-test
  (defn int->bits [i]
    (loop [acc [] bits 8 number i]
      (recur (conj acc (bit-and 1 number)) (dec bits) (bit-shift-right i 1))))
  (is (= [0 0 0 0 0 0 0 0] 0))
  (is (= [1 0 0 0 0 0 0 0] 1))
  (is (= [0 1 0 0 0 0 0 0] 2))
  (is (= [0 0 0 0 0 0 0 1] 128))
  (is (= [1 1 1 1 1 1 1 1] 255)))

(clojure.test/run-tests 'ja.core)
