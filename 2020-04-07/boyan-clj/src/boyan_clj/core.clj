(ns boyan-clj.core
  (:require [jsonista.core :as json])
  (:gen-class))


(defn time-since! [message previous-ts]
  (prn (format "%s::  [%.4f seconds]"
               message
               (double (/ (- (System/currentTimeMillis) previous-ts) 1000)))))

(defn json->edn [path]
  (-> path
      clojure.java.io/resource
      slurp
      json/read-value))

(defn output! [top-5-records]
  (loop [records top-5-records
         index   1]
    (when (seq records)
      (prn (format "%d. %s"
                   (inc index)
                   (get (first records) "countriesAndTerritories")))
      (recur (rest records)
             (inc index)))))

(defn -main [& args]
  (let [start-ts   (System/currentTimeMillis)
        covid-data (json->edn "covid.json")
        day        "06/04/2020"]
    (as-> covid-data $
      (get $ "records")
      (filter #(= day (get % "dateRep")) $)
      (sort-by #(Integer/parseInt (get % "cases")) < $)
      (take 5 $)
      (output! $))
    (time-since! "We started:" start-ts)))
