#lang at-exp racket
(require csv-reading)
(require infix)

(define make-cities-csv-reader (make-csv-reader-maker '((separator-chars #\,))))
(define next-row (make-cities-csv-reader (open-input-file "world-cities.csv")))

(define cities (make-hash))
(define (build-hash row)
  (hash-set! cities (car row) (list (list-ref row 2) (list-ref row 3))))

(csv-for-each build-hash  next-row)

(define city1 "Sofia")
(define city2 "Karlovo")

(define (degrad degrees)
  (* degrees (/ pi 180)))

(define (distance c1 c2)
	(let ([coords1 (map string->number (hash-ref cities c1))] [coords2 (map string->number (hash-ref cities c2))])
	(let ([lat1 (first coords1)] [lon1 (second coords1)] [lat2 (first coords2)] [lon2 (second coords2)])
          (define-values (dlat dlng a r c)  (values 0 0 0 0 0))
          @${
             dlat := degrad[lat1] - degrad[lat2];
             dlng := degrad[lon1] - degrad[lon2];
             a := (sin[dlat / 2]) ^ 2 + cos[degrad[lat1]] * cos[degrad[lat2]] * (sin[dlng / 2]) ^ 2;
             c := 2 * atan[sqrt[a], sqrt[1 - a]];
             r := 6371;
             r * c
}
)))

(distance city1 city2)
