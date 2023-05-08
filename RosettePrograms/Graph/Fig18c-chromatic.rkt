; Chromatic number problem (without checking data consistency).
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
         [c (map string->symbol (hash-ref h'colors))]
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
         [phi (solve (assert (interpret* (and pvc-a1 pvc-a2 Colored) intpn)))] )
    (if (unsat? phi)
        '()
        (hash-ref (interpretation->relations
                  (evaluate intpn phi) ) Coloring ) ) ) )
; Recursive function for computing the chromatic number
(define (get-chi phi pi-clr chi)
  (printf "~a\n" phi)
  (let ([phi-clr (remove-duplicates(map (lambda (x) (cadr x)) phi))])
    (cond
      ((eq? phi '()) chi)
      ((eq? (length phi-clr) (length pi-clr)) (length phi-clr))
      (else (let* ([new-clr (append pi-clr (cdr (remove* pi-clr phi-clr)))]
                   [bnds (set-bounds U tVertex tEdge tColor tPartialColoring
                     (product
                       (remove* (map (lambda (x) (car x)) tPartialColoring) lVertex)
                       new-clr ) )] )
              (get-chi (get-coloring bnds) pi-clr (length phi-clr)) )) ) ) )
; External instance of the chromatic number problem
(display "Enter a file name for a graph (without extension): ")
(define-values (lVertex tVertex tEdge)
  (get-graph (string-append (read-line) ".json")) )

(display "Enter a file name for a coloring (without extension): ")
(define-values (lColor tColor tPartialColoring)
  (get-partial-coloring (string-append (read-line) ".json")) )
; Universe of discourse
(define U (universe (append lVertex lColor)))
; First step of the recursive process
;   with the colors of the partial coloring and a first coloring
(let* ([pi-clr (remove-duplicates (map (lambda (x) (cadr x)) tPartialColoring))]
       [bnds (set-bounds U tVertex tEdge tColor tPartialColoring
         (product
           (remove* (map (lambda (x) (car x)) tPartialColoring) lVertex)
           lColor ) )]
       [chi (get-chi (get-coloring bnds) pi-clr 0)] )
  (if (eq? chi 0) (printf "No solution.\n")
                  (printf "Chromatic number: ~a.\n" chi) ) )