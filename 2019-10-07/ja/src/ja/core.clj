(ns ja.core
  (:import org.kocakosm.jblake2.Blake2b)
  (:use [clojure.test :only [with-test is]])
  (:use [clojure.string :only [join]]))

(def alphabet [\A \B \C \D \E \F \G \H
               \J \K \L \M \N \P \Q \R
               \S \T \U \V \W \X \Y \1
               \2 \3 \4 \5 \6 \7 \8 \9])

(defn hash-str [input]
  (map #(Byte/toUnsignedInt %)
    (-> (Blake2b. 5 (.getBytes input)) (.digest))))

(with-test
  (defn int->bits [i]
    (loop [acc [] bits 8 number i]
      (if (zero? bits)
        acc
        (recur (conj acc (bit-and 1 number)) (dec bits) (bit-shift-right number 1)))))
  (is (= [0 0 0 0 0 0 0 0] (int->bits 0)))
  (is (= [0 0 0 0 0 0 0 1] (int->bits 1)))
  (is (= [0 0 0 0 0 0 1 0] (int->bits 2)))
  (is (= [1 0 0 0 0 0 0 0] (int->bits 128)))
  (is (= [1 1 1 1 1 1 1 1] (int->bits 255))))

(with-test
  (defn bits->int [bs]
    (loop [acc 0 bs bs]
      (if (seq bs)
        (let [acc (+ (bit-shift-left acc 1) (first bs))]
          (recur acc (rest bs)))
        acc)))
  (is (= 0 (bits->int [0 0 0 0 0])))
  (is (= 1 (bits->int [0 0 0 0 1])))
  (is (= 31 (bits->int [1 1 1 1 1]))))

(defn boyan [input]
  (join "" (map
    (partial nth alphabet)
    (map bits->int (partition 5 (mapcat int->bits (hash-str input)))))))

(clojure.test/run-tests 'ja.core)
