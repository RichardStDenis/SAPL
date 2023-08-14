; Graph coloring (without I/O)
; Author: Richard St-Denis, Universite de Sherbrooke, 2023.
#lang rosette
(require ocelot)
(require json)
(require "../Theories/Fig11-graph.rkt")

(define SubEdge (declare-relation 2 "subEdge"))
(define Restriction (= SubEdge (+ (<: (- Vertex C) Edge) (~(<: (- Vertex C) Edge)))))

; Auxiliary functions
(define (str2sym-pair p)
  (list (string->symbol(car p)) (string->symbol(cadr p))) )

(define (get-graph filename)
  (let* ([ip (open-input-file filename)]
         [h (
             read-json ip)]
         [v (map string->symbol (hash-ref h 'vertices))]
         [e (map str2sym-pair (hash-ref h 'edges))] )
    (close-input-port ip)
    (values v (map list v) (SymClosure-rkt e)) ) )

(define (set-bounds-clique u bVertex bEdge)
  (bounds u (list (make-exact-bound Vertex bVertex)
                  (make-exact-bound Edge bEdge)
                  (make-upper-bound C bVertex) )) )

(define (set-bounds-restriction u bVertex bEdge bC)
  (bounds u (list (make-exact-bound Vertex bVertex)
                  (make-exact-bound Edge bEdge)
                  (make-exact-bound C bC)
                  (make-upper-bound SubEdge bEdge) )) )

(define (get-maximal-clique bnds)
  (let* ([intpn (instantiate-bounds bnds)]
         [clique (solve (assert (interpret* MaximalClique intpn)))] )
    (if (unsat? clique)
        '()
        (hash-ref (interpretation->relations (evaluate intpn clique)) C) ) ) )

(define (get-sub-edges bnds)
    (let* ([intpn (instantiate-bounds bnds)]
         [new-edges (solve (assert (interpret* Restriction intpn)))] )
    (if (unsat? new-edges)
        '()
        (hash-ref (interpretation->relations (evaluate intpn new-edges)) SubEdge) ) ) )

(define (get-all-maximal-cliques tV tE lst m)
;  (printf "The vertices: ~a\n"  tV)
;  (printf "The edges: ~a\n" tE)
;  (printf "Length: ~a\n" m)
  (cond ((eq? (length tV) 0) (cons m lst) )
        (else (let* ([bnds (set-bounds-clique U tV tE)]
                     [a-clique (get-maximal-clique bnds)] )
;                (printf "A maximal clique: ~a\n" a-clique)
                (let* ([bnds (set-bounds-restriction U tV tE a-clique)]
                       [a-subEdge (get-sub-edges bnds)]
                       [a-subVertex (remove-duplicates (map (lambda (x) (list (car x))) a-subEdge))] )
;                  (printf "The new vertices: ~a\n" a-subVertex)
;                  (printf "The new edges: ~a\n" a-subEdge)
                  (get-all-maximal-cliques a-subVertex a-subEdge (list* a-clique lst) (max m (length a-clique)) ) ) ) ) ) )
; External instance of a graph
(display "Enter a file name for a graph (without extension): ")
(define-values (lVertex tVertex tEdge)
  (get-graph (string-append (read-line) ".json")) )

(define t0 (current-seconds))
(define U (universe lVertex))
(let* ([all-cliques (get-all-maximal-cliques tVertex tEdge null 0)])
;   (printf "~a\n" all-cliques)
;   (printf "~a\n" (car all-cliques))
;   (printf "~a\n" (cdr all-cliques))
   (for ([l (cdr all-cliques)])
;     (printf "A maximal clique: ~a\n" l)
;     (printf "The length of the maximal clique: ~a\n" (length l))
     (cond [(= (length l) (car all-cliques))
           (printf "A maximal clique: ~a\n" l) ]) ) )      
(printf "~a\n" (- (current-seconds) t0))
