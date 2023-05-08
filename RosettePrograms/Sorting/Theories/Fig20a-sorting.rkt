; Sorting theory (based on quantified formulas).
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.

(module Fig21a-sorting rosette
  (provide permutation-a1 permutation-a2 sorted stablySorted idempotent immutable)

; The permutation elements represent the indices of an array of n values
; (i.e., 0 <= p[i] <= n-1, i = 0, 1, ..., n-2, n-1)
(define (permutation-a1 p i)
  (let ([n (vector-length p)]) (forall (list i) (=>
    (&& (<= 0 i) (<= i (- n 1)))
    (&& (>= (vector-ref p i) 0) (<= (vector-ref p i) (- n 1))) ))) )

; A permutation is a bijection
; (i,e., p[i] != p[j], i = 0, 1, ..., n-3, n-2, and j = i+1, ..., n-1)
(define (permutation-a2 p i j)
  (let ([n (vector-length p)]) (forall (list i j) (=>
    (&& (<= 0 i) (< i j) (<= j (- n 1)))
    (! (= (vector-ref p i) (vector-ref p j))) ))) )

; Under a symbolic permutation, the array of values is sorted
; (i.e., a[p[i]] <= a[p[i+1]], i = n-2, ..., 1, 0)
(define (sorted a p i)
  (let ([n (vector-length a)]) (forall (list i) (=>
    (&& (<= 0 i) (< i (- n 1)))
    (<= (vector-ref a (vector-ref p i))
        (vector-ref a (vector-ref p (+ i 1))) ) ))) )

; Under a symbolic permutation, the array of values is stably sorted
(define (stablySorted a p i)
  (let ([n (vector-length a)]) (&& (sorted a p i)
    (forall (list i) (=>
      (&& (<= 0 i) (< i (- n 1))
           (= (vector-ref a (vector-ref p i))
              (vector-ref a (vector-ref p (+ i 1))) ) )
      (< (vector-ref p i) (vector-ref p (+ i 1))) )) )) )

; sort(a) = (sort(sort(a))
(define (idempotent a b c p q i)
  (let ([n (vector-length a)]) (&&
    (sorted a p i) (forall (list i) (=>
      (&& (<= 0 i) (< i n))
      (= (vector-ref b i) (vector-ref a (vector-ref p i))) ))
    (sorted b q i) (forall (list i) (=>
      (&& (<= 0 i) (< i n))
      (= (vector-ref c i) (vector-ref b (vector-ref q i))) )) )) )

; If the array is already sorted, then the permutation of its stable sort is the identity
; (i.e., i = p[i], i =0, 1, ..., n-1, n-2)
(define (immutable a p i)
  (let ([n (vector-length a)]) (=>
    (forall (list i) (=>
      (&& (<= 0 i) (< i n))
      (= (vector-ref a i) (vector-ref a (vector-ref p i))) ))
    (forall (list i) (=>
      (&& (<= 0 i) (< i n))
      (= i (vector-ref p i)) )) )) ) )