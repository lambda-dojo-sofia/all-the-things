(ns the-very-best.core)

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(defn to-digits [number]
  (map #(-> % str read-string) (str number)))

(defn two-consecutive [digits]
  (= true
     (reduce
       #(if (or (= %1 %2)
                (true? %1))
          true
          %2)
       digits)))

(defn two-consecutive-exactly [digits]
  (= true
     (reduce
       #(fn [{:keys [pair? group? last-number]} n]
          (if (= last-number n)
            (if
              {:pair?       false
               :last-is-pair?      true
               :last-number n}
              {:pair?       true
               :last-is-pair?      true
               :last-number n})
            {:pair?       pair?
             :group       false
             :last-number n}))
       {:pair? false
        :last-number nil}
       digits)))

(defn only-increment [digits]
  (not=
    false
    (reduce
      #(if (or (false? %1)
               (> %1 %2))
         false
         %2)
      digits)))

(defn find-count [start end cons-fn]
  (let [all-the-numbers (range start (inc end))
        b               (filter
                          #(let [digits (to-digits %)
                                 two?   (cons-fn digits)
                                 only?  (only-increment digits)]
                             (and two? only?))
                          all-the-numbers)
        c               (count b)]
    c))
