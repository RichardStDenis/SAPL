;Infinite
; Author: Richard St-Denis, Universite de Sherbrooke, 2023.
#lang rosette
(current-bitwidth #f)

(define-symbolic x y integer?)

(define propertyOnInteger
  (forall (list x) (=> (<= 0 x) (exists (list y) (&& (<= 0 y) (<= x y))))) )

(verify (assert propertyOnInteger))

(verify (assert (not propertyOnInteger)))