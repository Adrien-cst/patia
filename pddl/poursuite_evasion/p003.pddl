(define (problem poursuite-evasion-2)
(:domain pursuite)

(:objects
    cops1 cops2 cops3 - cops
    c1 c2 c3 c4 - case
    a b c top bottom - link
)

(:init
    (occupiedcase c1)
    (emptycase c2)
    (occupiedcase c3)
    (occupiedcase c4)

    (nextto c1 c2 a)
    (nextto c2 c1 a)
    
    (nextto c2 c3 b)
    (nextto c3 c2 b)

    (nextto c2 c4 c)
    (nextto c4 c2 c)

    (istop top)
    (isbottom bottom)

    (onto cops1 c1)
    (isalone cops1)

    (onto cops2 c3)
    (isalone cops2)

    (onto cops3 c4)
    (isalone cops3)

    ; STACK DE C1
    (ontop c1 bottom a)
    (ontop c1 a top)
    (first c1 bottom)
    (last c1 top)

    ; STACK DE C2
    (ontop c2 bottom a)
    (ontop c2 a b)
    (ontop c2 b c)
    (ontop c2 c top)
    (first c2 bottom)
    (last c2 top)

    ; STACK DE C3
    (ontop c3 bottom b)
    (ontop c3 b top)
    (first c3 bottom)
    (last c3 top)

    ; STACK DE C4
    (ontop c4 bottom c)
    (ontop c4 c top)
    (first c4 bottom)
    (last c4 top)
)

(:goal (and
    (ontop c1 bottom top)
    (ontop c2 bottom top)
    (ontop c3 bottom top)    
    (ontop c4 bottom top)    
))

)