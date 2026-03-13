(define (problem hanoitower-3-0) 
(:domain hanoi)
(:objects 
a b c - disk
t1 t2 t3 - tower
)

(:init
    (clear c)
    
    (smaller b a)
    (smaller c b)
    (smaller c a)

    (on b a)
    (on c b)

    (ontower c t1)
    (ontower a t1)
    (ontower b t1)          ; b est aussi sur la tour t1
    (ontable a)             ; a est posé directement sur la tour
    (towerempty t2)         ; les deux autres tours sont vides
    (towerempty t3)
    (handempty)
)

(:goal (and 
    (on b a)
    (on c b)
    (ontower a t3)
))

)
