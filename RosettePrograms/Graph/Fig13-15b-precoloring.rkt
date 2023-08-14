; Precoloring extension problem (with I/O, data consistency, and a partial coloring in bounds).
; Author: Richard St-Denis, Universite de Sherbrooke, 2022.
#lang rosette
(require ocelot)
(require json)
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
; Rules for data consistency
(define data_r1 (in (join Edge Vertex) Vertex))
(define data_r2 (in (join Vertex Edge) Vertex))
(define data_r3 (in (join PartialColoring Color) Vertex))
(define data_r4 (in (join Vertex PartialColoring) Color))
; Auxiliary functions
(define (str2sym-pair p)
  (list (string->symbol(car p)) (string->symbol(cadr p))) )

(define flatten1-maker
  (lambda (f)
    (lambda (lst)
      (if (empty? lst) '() (append (car lst) ((f f) (cdr lst)))) ) ) )
(define flatten1 (flatten1-maker flatten1-maker))

(define (product lst1 lst2)
  (flatten1 (for/list ([v lst1])
    (map (lambda (c) (list v c)) lst2) )) )

(define (get-graph filename)
  (let* ([ip (open-input-file filename)]
         [h (read-json ip)]
         [v (map string->symbol (hash-ref h 'vertices))]
         [e (map str2sym-pair (hash-ref h 'edges))] )
    (close-input-port ip)
    (values v (map list v) (SymClosure-rkt e)) ) )

(define (get-partial-coloring filename)
  (let* ([ip (open-input-file filename)]
         [h (read-json ip)]
         [c (map string->symbol (hash-ref h 'colors))]
         [pi (map str2sym-pair (hash-ref h 'partialColoring))] )
    (close-input-port ip)
    (values c (map list c) pi) ) )

(define (set-bounds u bVertex bEdge bColor lbColoring ubColoring)
  (bounds u (list (make-exact-bound Vertex bVertex)
                  (make-exact-bound Edge bEdge)
                  (make-exact-bound Color bColor)
                  (make-bound Coloring lbColoring ubColoring) )) )

(define (get-coloring bnds)
  (let* ([intpn (instantiate-bounds bnds)]
         [phi (solve (assert (interpret* (and graph-a1 graph-a2
           pvc-a1 pvc-a2 Colored) intpn )))] )
    (if (unsat? phi)
        '()
        (hash-ref (interpretation->relations
                  (evaluate intpn phi) ) Coloring ) ) ) )
; External instance of the precoloring extension problem
(display "Enter a file name for a graph (without extension): ")
(define-values (lVertex tVertex tEdge)
  (get-graph (string-append (read-line) ".json")) )

(display "Enter a file name for a coloring (without extension): ")
(define-values (lColor tColor tPartialColoring)
  (get-partial-coloring (string-append (read-line) ".json")) )
; Universe of discourse
(define U (universe (remove-duplicates
  (append lVertex lColor
          (map (lambda (e) (car e)) tEdge)
          (map (lambda (e) (cadr e)) tEdge)
          (map (lambda (p) (car p)) tPartialColoring)
          (map (lambda (p) (cadr p)) tPartialColoring) ) )))
; Query for checking data consistency
(let* ([bnds (bounds U
         (list (make-exact-bound Vertex tVertex)
               (make-exact-bound Edge tEdge)
               (make-exact-bound Color tColor)
               (make-exact-bound PartialColoring tPartialColoring) ) )]
       [intpn (instantiate-bounds bnds)]
       [cntrex (verify (assert (interpret*
                         (and data_r1 data_r2 data_r3 data_r4 pi-a1 pi-a2) intpn )))] )
  (cond [(sat? cntrex) (printf "Data inconsistency.\n")]) )
; Query for solving the precoloring extension problem (with bounds setting)
(printf "The coloring: ~a\n" (get-coloring
  (set-bounds U tVertex tEdge tColor tPartialColoring
    (product (remove* (map (lambda (x) (car x)) tPartialColoring) lVertex) lColor) ) ))