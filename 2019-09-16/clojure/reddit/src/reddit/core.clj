(ns reddit.core
  (:require [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [clojure.edn :as edn]
            [clojure.string :as str]))

(defn csv-data->maps [csv-data]
  (map zipmap
       (->> (first csv-data) ;; First row is the header
            (map keyword) ;; Drop if you want string keys instead
            repeat)
	     (rest csv-data)))

(defn read-file [filename]
  (with-open [reader (io/reader (io/resource filename))]
    (let [data (csv/read-csv reader)]
      (doall (csv-data->maps data)))))

(defn word? [s]
  (and (not (str/starts-with? s "&"))
       (> (count s) 3)))

;;;;
;; Part 1
;;;;
(defn word-frequencies [filename]
  (-> (read-file filename)
     (#(map :title %))
     (#(mapcat (fn [t] (str/split t #" ")) %))
     (#(filter word? %))
     (#(sort-by second > (frequencies %)))))

(def five-most-used-words (take 5 (word-frequencies "90sHipHop.csv")))

;;;;
;; Part 2
;;;;
(defn word-karma [filename]
    (->> (read-file filename)
         (map (fn [{:keys [title score]}] [title score]))
         (reduce
           (fn [acc [title score]]
             (let [words (str/split title #" ")
                   words (filter word? words)
                   score (edn/read-string score)]
               (reduce (fn [acc w]
                           (if (contains? acc w)
                             (update acc w + score)
                             (assoc acc w score)))
                         acc words)))
           {})
         (sort-by second >)))

(word-karma "90sHipHop.csv")
