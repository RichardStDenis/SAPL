; Sorting.
; Author: Richard St-Denis, Universite de Sherbrooke, 2023.
#lang rosette
(require json)
(require "../Theories/Fig20a-sorting.rkt")
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
; Display the permutation and the sorted array from a solution
(define (display-solution p a s)
  (for ([i (vector-length a)])
    (printf "i~a: ~a\n" i (evaluate (vector-ref p i) s)) )
  (printf "The sorted array:")
  (for ([i (vector-length a)])
    (printf " ~a" (evaluate (vector-ref a (vector-ref p i)) s)) )
  (printf "\n") )
(define-symbolic i j integer?)
;Auxiliairy function
(define (get-numbers filename)
  (let* ([ip (open-input-file filename)]
         [h (read-json ip)]
         [v (map cadr (hash-ref h 'list))] )
    (close-input-port ip)
    (values  v) ) )
; Get an instance of the sorting problem
(display "Enter a file name (without extension): ")
(define-values (lValues)
  (get-numbers (string-append (read-line) ".json")) )
                              
(let* ([A (list->vector (map string->number lValues))]
       [n (vector-length A)] [SortA (make-vector n)])
  (initialize-symbolic-vector SortA)
  (assert (&& (permutation-a1 SortA i) (permutation-a2 SortA i j)))

  (define t0 (current-seconds))
  (printf "Input data: ~a\n" A)
  (printf "Size of data: ~a\n" n)
  (let ([solution (run_sort A SortA i)])
    (if [sat? solution]
        (display-solution SortA A solution)
        (printf "The theory is inconsistent.~n") ) )
  (printf "~a\n" (- (current-seconds) t0)) )