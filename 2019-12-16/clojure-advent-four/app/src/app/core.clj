(ns app.core)

;; 235741-706948
;; 137683-596253

#_(defn to-digits [n]
  (cond (< n 10) [n]
        :else (conj
               (to-digits (quot n 10))
               (mod n 10))))

(defn to-digits [n]
  (let [a (quot n 100000)
        b (quot (- n (* a 100000)) 10000)
        c (quot (- n (* b 10000) (* a 100000)) 1000)
        d (quot (- n (* c 1000) (* b 10000) (* a 100000)) 100)
        e (quot (- n (* d 100) (* c 1000) (* b 10000) (* a 100000)) 10)
        f (mod n 10)]
    [a b c d e f]))

(to-digits 1)
(to-digits 12)
(to-digits 123)
(to-digits 1234)
(to-digits 123456)

(defn never-decrease [digits]
  (apply <= digits))

(never-decrease (to-digits 123))
(never-decrease (to-digits 1))
(never-decrease (to-digits 21))
(never-decrease (to-digits 321))

(defn same-adjacent [[a b c d e f]]
  (or (= a b ) (= b c) (= c d) (= d e) (= e f)))

(same-adjacent-two (to-digits 111155))
(same-adjacent-two (to-digits 123444))

(defn same-adjacent-two [digits]
  (some #{2} (vals (frequencies digits))))

(same-adjacent (to-digits 123456))
(same-adjacent (to-digits 112345))
(same-adjacent (to-digits 123455))

(defn passwords [n-min n-max]
  (count (filter (fn [n]
                  (let [digits (to-digits n)]
                    (and (same-adjacent-two digits)
                         (never-decrease digits))))
                 (range n-min (inc n-max)))))

(passwords 235741 706948)
(passwords 137683 596253)
(passwords 183564 657474)

(defn foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))
