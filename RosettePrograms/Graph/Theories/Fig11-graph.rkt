; A basic graph theory.
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.
#lang racket
(require ocelot)
(provide Vertex Edge C graph-a1 graph-a2 Adjacent Adjacent-rkt Degree-rkt SymClosure-rkt
         Clique MaximalClique Complete HandshakingLemma-rkt? Undirected)

(define Vertex (declare-relation 1 "vertex"))
(define Edge (declare-relation 2 "edge"))
(define C (declare-relation 1 "clique"))

(define graph-a1 (= (join Vertex (& Edge iden)) none))
(define graph-a2 (= Edge (~ Edge)))
(define (Adjacent v) (join v Edge))
(define (Adjacent-rkt E v) (filter-map (lambda (x) (and (eq? (car x) v) (cadr x))) E))
(define (Degree-rkt E v) (length (Adjacent-rkt E v)))
(define (SymClosure-rkt E)
  (remove-duplicates (append E (map (lambda (x) (list (cadr x) (car x))) E))) )

(define Clique (and (in C Vertex)
  (all ([u C] [v C]) (=> (not(= u v)) (in (-> u v) Edge))) ))
(define MaximalClique (and Clique
  (no ([u (- Vertex C)]) (all ([v C]) (in (-> u v) Edge))) ))
(define Complete (all ([u Vertex] [v Vertex])
  (=> (not (= u v)) (in (-> u v) Edge)) ))
(define (HandshakingLemma-rkt? V E)
  (eq? (apply + (map (lambda (x) (Degree-rkt E x)) V)) (length E)) )
(define Undirected (and
  (no ([v Vertex]) (in v (Adjacent v)))
  (all ([u Vertex] [v Vertex]) (=> (in (-> u v) Edge) (in (-> v u) Edge))) ))