; Sorting.
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.
#lang rosette
(require "Theories/Fig20a-sorting.rkt")
(current-bitwidth #f)
; Create a distinct symbolic constant of type integer
(define (new-symbolic-index)
  (define-symbolic* s integer?) s )
; Initialize a vector with symbolic constants
(define (initialize-symbolic-vector v)
  (for/list ([i (vector-length v)])
    (vector-set! v i (new-symbolic-index)) ) )
; Solve the sorting problem
(define (run_sort a p i) (solve (assert (sorted a p i))))
; Check the property immutable
(define (check_immutable a p i)
  (verify (assert (immutable a p i))) )            
; Display the permutation and the sorted array from a solution
(define (display-solution p a s)
  (for ([i (vector-length a)])
    (printf "i~a: ~a\n" i (evaluate (vector-ref p i) s)) )
  (printf "The sorted array:")
  (for ([i (vector-length a)])
    (printf " ~a" (evaluate (vector-ref a (vector-ref p i)) s)) )
  (printf "\n") )

(define-symbolic i j integer?)
; Instance of the sorting problem
(let* ([A (vector-immutable 6 -3 6 0 3)]
       [n (vector-length A)] [SortA (make-vector n)])
  (initialize-symbolic-vector SortA)
  (assert (&& (permutation-a1 SortA i) (permutation-a2 SortA i j)))
  
  (let ([solution (run_sort A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "The theory is inconsistent.~n") ) )
  
  (assume (stablySorted A SortA i))
  (let ([solution (check_immutable A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "No conterexample.~n") ) ) )