; Proper vertex coloring problem (without I/O).
; Author: Richard St-Denis, Universite de Sherbrooke, 2023.
#lang rosette
(require ocelot)
(require "Theories/Fig11-graph.rkt")
; Extension of the graph theory
(define Color (declare-relation 1 "color"))
(define Coloring (declare-relation 2 "coloring"))
(define pvc-a1 (in Coloring (-> Vertex Color)))
(define pvc-a2 (all ([v Vertex]) (one ([c Color]) (in (-> v c) Coloring))))
(define Colored (all ([v Vertex])
  (not (in (join v Coloring) (join (Adjacent v) Coloring))) ))
; Instance of the proper vertex coloring problem
(define lVertex '(v1 v2 v3 v4 v5))
(define tVertex '((v1) (v2) (v3) (v4) (v5)))
(define tEdge (SymClosure-rkt '((v1 v2) (v1 v3) (v1 v4) (v1 v5) (v2 v3) (v4 v5))))
(define lColor '(blue brown gray green pink red))
(define tColor '((blue) (brown) (gray) (green) (pink) (red)))
; Universe of discourse
(define U (universe (append lVertex lColor)))
; Query for checking if the graph is undirected (with bound setting)
(let* ([bnds (bounds U
         (list (make-exact-bound Vertex tVertex)
               (make-exact-bound Edge tEdge) ) )]
       [intpn (instantiate-bounds bnds)]
       [cntrex (verify (begin (assume (interpret* (and graph-a1 graph-a2) intpn))
                              (assert (interpret* Undirected intpn)) ))] )
  (cond [(sat? cntrex) (printf "The graph is not undirected.\n")]) )
; Query for solving an instance of the proper vertex coloring problem (with bound setting)
(let* ([bnds (bounds U
         (list (make-exact-bound Vertex tVertex)
               (make-exact-bound Edge tEdge)
               (make-exact-bound Color tColor)
               (make-product-bound Coloring lVertex lColor) ) )]
       [intpn (instantiate-bounds bnds)]
       [phi (solve (assert (interpret* (and graph-a1 graph-a2
         pvc-a1 pvc-a2 Colored ) intpn )))] )
  (cond [(sat? phi) (printf "The coloring: ~a\n"
         (hash-ref (interpretation->relations (evaluate intpn phi)) Coloring) )]) )