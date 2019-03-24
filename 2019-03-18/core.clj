(ns maximum-length-snake.core)

(def ma3x [7 5 2 3 1
           3 4 1 4 4
           1 5 6 7 8
           3 4 5 8 9
           3 2 2 7 6])

(def n 5)

(defn at [row col matrix]
  (get matrix (+ col (* row n))))

(defn neighbours [[row col] matrix]
  (let [current (at row col matrix)
        right (at row (inc col) matrix)
        bottom (at (inc row) col matrix)]
    [(when (and right
                (= 1 (Math/abs (- current right))))
       [row (inc col)])
     (when (and bottom
                (= 1 (Math/abs (- current bottom))))
       [(inc row) col])]))

(defn negative-sum [[a b]]
  (- (+ a b)))

(defn cartesian-pairs [n]
  (for [i (range n)
        j (range n)]
    [i j]))

(defn reverse-diagonal-walk [n]
  (sort-by negative-sum
           (cartesian-pairs n)))

(defn path-lengths [matrix]
  (loop [lengths {}
         paths {}
         todo (reverse-diagonal-walk n)]
    (if (empty? todo)
      [lengths paths]
      (let [current (first todo)
            [a b] (remove nil? (neighbours current matrix))
            a-len (get lengths a)
            b-len (get lengths b)
            [new-length new-path] (cond
                                    (nil? a) [1 []]
                                    (nil? b) [(inc a-len) a]
                                    :else (if (>= a-len b-len)
                                            [(inc a-len) a]
                                            [(inc b-len) b]))]
        (recur (assoc lengths current new-length)
               (assoc paths current new-path)
               (rest todo))))))

(defn longest-path [matrix]
  (let [[lengths paths] (path-lengths matrix)
        start (first (first (sort-by (fn [[k v]]
                                       (- v)) (seq lengths))))]
    (loop [[x y :as coords] start
           acc []]
      (if (empty? coords)
        acc
        (recur (get paths coords)
               (conj acc (at x y matrix)))))))

(println (longest-path ma3x))

