(define (problem taquin-2-2) 
(:domain taquin)
(:objects 
    t1 t2 t3 - tile
    c1 c2 c3 c4 - case
)

(:init
    (nextto c1 c2)
    (nextto c1 c3)
    (nextto c3 c4)
    (nextto c2 c4)
    
    (nextto c2 c1)
    (nextto c3 c1)
    (nextto c4 c3)
    (nextto c4 c2)

    (clear c3)

    (placed t1 c1)
    (placed t2 c2)
    (placed t3 c4)
)

(:goal (and
    (placed t1 c1)
    (placed t2 c2)
    (placed t3 c3)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
