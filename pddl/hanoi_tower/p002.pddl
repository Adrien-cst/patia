(define (problem hanoitower-2-0) 
(:domain hanoi)
(:objects 
a b - disk
t1 t2 t3 - tower
)

(:init
    (clear b)
    (smaller b a)
    (on b a)
    (ontower a t1)
    (ontower b t1)          ; b est aussi sur la tour t1
    (ontable a)             ; a est posé directement sur la tour
    (towerempty t2)         ; les deux autres tours sont vides
    (towerempty t3)
    (handempty)
)

(:goal (and 
    (on b a)
    (ontower a t3)
))

)
