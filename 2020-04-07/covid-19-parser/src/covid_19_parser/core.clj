(ns covid-19-parser.core
  (:require [cheshire.core :as ch]
            [clojure.data.json :as json]
            [jsonista.core :as j]))

;; top five more cases for each date

(defn parse-all [data]
  (let [date "06/04/2020"
        data (:records data)
        f    (filter #(= date (:dateRep %)))
        m    (map #(assoc % :cases (. Integer parseInt (:cases %))))
        r    (eduction (comp f m) data)
        s    (sort-by :cases r)
        t    (reverse (take-last 5 s))]
    (map :countriesAndTerritories t)))

(defn covid-19-cheshire []
  (parse-all
    (ch/parse-string
      (slurp "../covid-2020-04-06.json")
      keyword)))

(defn covid-19-json []
  (parse-all
    (json/read-str
      (slurp "../covid-2020-04-06.json")
      :key-fn keyword)))

(defn covid-19-jsonista []
  (parse-all
    (j/read-value
      (slurp "../covid-2020-04-06.json")
      (j/object-mapper
        {:decode-key-fn keyword}))))
