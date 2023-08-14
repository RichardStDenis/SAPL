; Precoloring extension problem (with a partial coloring in a constraint).
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.
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
; Relation for a partial coloring
(define PartialColoring (declare-relation 2 "partialcoloring"))
(define pi-a1 (in PartialColoring (-> Vertex Color)))
(define pi-a2 (all ([v Vertex]) (lone ([c Color]) (in (-> v c) PartialColoring))))
; Instance of the precoloring extension problem
(define lVertex '(v1 v2 v3 v4 v5))
(define tVertex '((v1) (v2) (v3) (v4) (v5)))
(define tEdge (SymClosure-rkt '((v1 v2) (v1 v3) (v1 v4) (v1 v5) (v2 v3) (v4 v5))))
(define lColor '(blue brown gray green pink red))
(define tColor '((blue) (brown) (gray) (green) (pink) (red)))
(define tPartialColoring '((v1 red) (v5 green)))
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
; Query for solving the precoloring extension problem (with bounds setting)
(let* ([bnds (bounds U
         (list (make-exact-bound Vertex tVertex)
               (make-exact-bound Edge tEdge)
               (make-exact-bound Color tColor)
               (make-product-bound Coloring lVertex lColor)
               (make-exact-bound PartialColoring tPartialColoring) ) )]
       [intpn (instantiate-bounds bnds)]
       [phi (solve (assert (interpret* (and graph-a1 graph-a2
         pvc-a1 pvc-a2 Colored pi-a1 pi-a2 (in PartialColoring Coloring) ) intpn )))] )
  (cond [(sat? phi) (printf "The coloring: ~a\n"
         (hash-ref (interpretation->relations (evaluate intpn phi)) Coloring) )]) )