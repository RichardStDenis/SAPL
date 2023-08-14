; Sorting theory (based on lambda functions).
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.

(module Fig21b-sorting rosette
  (provide permutation-a1 permutation-a2 sorted)

; The permutation elements represent the indices of an array of n values
; (i.e., 0 <= p[i] <= n-1, i = n-1, n-2, ..., 1, 0)
(define permutation-a1
  (lambda (p n i) (if (< i 0) (list)
    (cons (&& (>= (vector-ref p i) 0)
              (<= (vector-ref p i) (- n 1)) )
          (permutation-a1 p n (- i 1)) ) )) )

; A permutation is a bijection
; (i,e., p[i] != p[j], i = n-1, n-2, ..., 1, 0 and j = 0, ..., i-1)
(define permutation-a2
  (lambda (p i j) (if (= i 0) (list)
    (cons (! (= (vector-ref p i) (vector-ref p j)))
          (if (= i (+ j 1))
              (permutation-a2 p (- i 1) 0)
              (permutation-a2 p i (+ j 1)) ) ) )) )

; Under a symbolic permutation, the array of values is sorted
; (i.e., a[p[i]] <= a[p[i+1]], i = n-2, ..., 1, 0)
(define sorted
  (lambda (a p i) (if (< i 0) (list)
    (cons (<= (vector-ref a (vector-ref p i))
              (vector-ref a (vector-ref p (+ i 1))) )
          (sorted a p (- i 1)) ) )) ) )
