(define (problem taquin-3-3) 

(:domain taquin)
(:objects 
    t1 t2 t3 t4 t5 t6 t7 t8 - tile
    c1 c2 c3 c4 c5 c6 c7 c8 c9 - case
)

(:init
    (nextto c1 c2)
    (nextto c2 c3)
    (nextto c4 c5)
    (nextto c5 c6)
    (nextto c7 c8)
    (nextto c8 c9)

    (nextto c1 c4)
    (nextto c2 c5)
    (nextto c3 c6)
    (nextto c4 c7)
    (nextto c5 c8)
    (nextto c6 c9)

    (nextto c2 c1)
    (nextto c3 c2)
    (nextto c5 c4)
    (nextto c6 c5)
    (nextto c8 c7)
    (nextto c9 c8)

    (nextto c4 c1)
    (nextto c5 c2)
    (nextto c6 c3)
    (nextto c7 c4)
    (nextto c8 c5)
    (nextto c9 c6)

    (clear c9)

    (placed t1 c3)
    (placed t2 c1)
    (placed t3 c4)
    (placed t4 c5)
    (placed t5 c6)
    (placed t6 c8)
    (placed t7 c7)
    (placed t8 c2)
)

(:goal (and
    (placed t1 c1)
    (placed t2 c2)
    (placed t3 c3)
    (placed t4 c4)
    (placed t5 c5)
    (placed t6 c6)
    (placed t7 c7)
    (placed t8 c8)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
