(ns best-clojure-solution.core
  (:import [org.kocakosm.jblake2 Blake2b]))

(defn stupid [s]
  (let [string-bytes     (.getBytes s)
        string-digester  (org.kocakosm.jblake2.Blake2b. 5)
        jbytes-array     (.digest (.update string-digester string-bytes))
        bytes-collection (mapv #(aget jbytes-array %) (range 0 5))]
    {:five  bytes-collection
     :five-binary (mapv #(Integer/toBinaryString %) bytes-collection)
     :eight (five->eight bytes-collection)}))

(defn five->eight
  [[a b c d e]]
  [
   ;; 1
   (-> a
       (bit-shift-right 3)
       (bit-and 2r11111))
   ;; 2
   (bit-or
    (-> a
        (bit-and 2r111)
        (bit-shift-left 2))
    (-> b
        (bit-shift-right 6)
        (bit-and 2r11)))
   ;; 3
   (-> b
       (bit-shift-right 1)
       (bit-and 2r11111))
   ;; 4
   (bit-or
    (-> b
        (bit-and 2r1)
        (bit-shift-left 4))
    (-> c
        (bit-shift-right 4)
        (bit-and 2r1111)))
   ;; 5
   (bit-or
    (-> c
        (bit-and 2r1111)
        (bit-shift-left 4))
    (-> d
        (bit-shift-right 7)
        (bit-and 2r1)))
   ;; 6
   (-> d
       (bit-shift-right 2)
       (bit-and 2r11111))
   ;; 7
   (bit-or
    (-> d
        (bit-and 2r11)
        (bit-shift-left 3))
    (-> e
        (bit-shift-right 5)
        (bit-and 2r111)))
   ;; 8
   (-> e
       (bit-and 2r11111))])

(stupid "pooppoop")
