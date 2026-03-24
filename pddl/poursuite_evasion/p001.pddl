(define (problem poursuite-evasion-2)
(:domain pursuite)

(:objects
    cops1 - cops
    c1 c2 c3 - case
    a b top bottom - link
)

(:init
    (occupiedcase c1)
    (emptycase c2)
    (emptycase c3)

    (nextto c1 c2 a)
    (nextto c2 c1 a)
    
    (nextto c2 c3 b)
    (nextto c3 c2 b)

    (istop top)
    (isbottom bottom)

    (onto cops1 c1)
    (isalone cops1)

    ; STACK DE C1
    (ontop c1 bottom a)
    (ontop c1 a top)
    (first c1 bottom)
    (last c1 top)

    ; STACK DE C2
    (ontop c2 bottom a)
    (ontop c2 a b)
    (ontop c2 b top)
    (first c2 bottom)
    (last c2 top)

    ; STACK DE C3
    (ontop c3 bottom b)
    (ontop c3 b top)
    (first c3 bottom)
    (last c3 top)
)

(:goal (and
    (ontop c1 bottom top)
    (ontop c2 bottom top)
    (ontop c3 bottom top)    
))

)