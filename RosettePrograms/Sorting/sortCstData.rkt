#lang rosette
; Sorting
; Author: Richard St-Denis, Universite de Sherbrooke, 2023
(require "Theories/Fig20a-sorting.rkt")
(current-bitwidth #f)

; Create a distinct symbolic constant of type integer
(define (new-symbolic-index)
  (define-symbolic* s integer?) s )

; Initialize a vector with symbolic constants
(define (initialize-symbolic-vector v)
  (for/list ([i (vector-length v)])
    (vector-set! v i (new-symbolic-index)) ) )

(define (vec_equality a b i)
  (let ([n (vector-length a)])
    (forall (list i) (=>
      (&& (<= 0 i) (< i n))
      (= (vector-ref a i) (vector-ref b i)) )) ) )
; Check vector equality
(define (check_vec_equality a b i) (verify (assert (vec_equality a b i))))

; Find a model with respect to property sorted
(define (run_sort a p i) (solve (assert (sorted a p i))))

; Find a model with respect to property stablySorted
(define (run_stablySort a p i) (solve (assert (stablySorted a p i))))

; Find a model with respect to property idempotent
(define (run_idempotent a b c p q i) (solve (assert (idempotent a b c p q i))))

; Check the property immutable
; *** Incorrect result with this formulation
;(define (check_immutable a p i)
;  (verify (begin (assume (stablySorted A SortA i))
;                 (assert (immutable a p i)) )) )
(define (check_immutable a p i)
  (verify (assert (immutable a p i))) )

; Check an assertion (idempotent)
; *** Incorrect result with this formulation
;(define (check_idempotent a b c p q i)
;  (verify (begin (assume (idempotent a b c p q i))
;                 (assert (vec_equality b c i)) )) )
(define (check_idempotent b c i)
 (verify (assert (vec_equality b c i))) )

; Display the permutation and the sorted array from a solution
(define (display-solution p a s)
  (for ([i (vector-length a)])
    (printf "i~a: ~a\n" i (evaluate (vector-ref p i) s)) )
  (printf "The sorted array:")
  (for ([i (vector-length a)])
    (printf " ~a" (evaluate (vector-ref a (vector-ref p i)) s)) )
  (printf "\n") )

(define-symbolic i j integer?)

(let* ([A (vector-immutable 6 -3 6 0 6)]
       [B (vector-immutable 3 -7 4 6 1)]
       [C (vector-immutable 3 -7 4 6 1)]
       [n (vector-length A)] [SortA (make-vector n)]
       [SortedA (make-vector n)] [Sort2A (make-vector n)] [Sorted2A (make-vector n)])
  (initialize-symbolic-vector SortA)
  (assert (and (permutation-a1 SortA i) (permutation-a2 SortA i j)))
  (initialize-symbolic-vector SortedA)
  (initialize-symbolic-vector Sort2A)
  (assert (and (permutation-a1 Sort2A i) (permutation-a2 Sort2A i j)))
  (initialize-symbolic-vector Sorted2A)
 
  (let ([solution (check_vec_equality B C i)])
    (if [sat? solution]
        (printf "Equality does not hold.~n")
        (printf "Equality holds.~n") ) )
 
  (let ([solution (run_sort A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "The theory is inconsistent.~n") ) )

  (let ([solution (run_stablySort A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "The theory is inconsistent.~n") ) )

  (let ([solution (run_idempotent A SortedA Sorted2A SortA Sort2A i)])
    (if [sat? solution]
        (begin (display-solution SortA A solution)
               (display-solution Sort2A SortedA solution)
               (display-solution Sort2A Sorted2A solution) )
        (printf "The theory is inconsistent.~n") ) )

; *** See above check_idempotent
;  (let ([solution (check_idempotent A SortedA Sorted2A SortA Sort2A i)])
;    (if [sat? solution]
;        (begin (display-solution SortA A solution)
;               (display-solution Sort2A B solution)
;               (display-solution Sort2A C solution) )
;        (printf "No conterexample.~n") ) )

  (assume (idempotent A SortedA Sorted2A SortA Sort2A i))
  (let ([solution (check_idempotent SortedA Sorted2A i)])
    (if [sat? solution]
        (begin (display-solution SortA A solution)
               (display-solution Sort2A B solution)
               (display-solution Sort2A C solution) )
        (printf "No conterexample.~n") ) )

; *** See above check_immutable
;  (let ([solution (check_immutable A SortA i)])
;    (if [sat? solution]
;        (display-solution SortA A solution)
;        (printf "No conterexample.~n") ) ) )

  (printf "~a\n" (vc))
  (clear-vc!)
  (printf "~a\n" (vc))
  (assert (and (permutation-a1 SortA i) (permutation-a2 SortA i j)))
  (assume (stablySorted A SortA i))
  (let ([solution (check_immutable A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "No conterexample.~n") ) ) )