(ns jordan
  (:require [jsonista.core :as json])
  (:import (java.time Instant)))

(def start (Instant/now))

(def mapper
  (json/object-mapper
    {:decode-key-fn keyword}))

(defn main [dateRep]
  (->> (-> "covid-2020-04-06.json"
           slurp
           (json/read-value mapper)
           :records)
       (filter #(= dateRep (:dateRep %)))
       (sort-by #(- (. Integer parseInt (:cases %))))
       (take 5)
       (map :countriesAndTerritories)
       println))

(main "06/04/2020")

(def end (Instant/now))

(clojure.pprint/pprint (/ (- (.getNano end) (.getNano start)) 1e6))
