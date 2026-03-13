(define (problem hanoitower-4-0) 
(:domain hanoi)
(:objects 
a b c d - disk
t1 t2 t3 t4 - tower
)

(:init
    (clear d)

    (on d c)
    (on c b)
    (on b a)
    (ontower a t1)

    (smaller a b)

    (towerempty t2)
    (towerempty t3)
    (towerempty t4)

    (handempty)
)

(:goal (and 
    (on d c)
    (on c b)
    (on b a)

    (ontower a t4)
))

)
