(define (problem poursuite-evasion-2)
(:domain pursuite)

(:objects
    cops1 cops2 - cops
    c1 c2 c3 c4 c5 - case
    a b c d e top bottom - link
)

(:init
    (occupiedcase c1)
    (emptycase c2)
    (emptycase c3)
    (emptycase c4)
    (emptycase c5)

    (nextto c1 c2 a)
    (nextto c2 c1 a)
    
    (nextto c2 c3 b)
    (nextto c3 c2 b)

    (nextto c2 c4 c)
    (nextto c4 c2 c)

    (nextto c4 c5 d)
    (nextto c5 c4 d)

    (nextto c2 c5 e)
    (nextto c5 c2 e)

    (onto cops1 c1)
    (onto cops2 c1)
    (isnotalone cops1)
    (isnotalone cops2)

    (istop top)
    (isbottom bottom)

    ; STACK DE C1
    (ontop c1 bottom a)
    (ontop c1 a top)
    (first c1 bottom)
    (last c1 top)

    ; STACK DE C2
    (ontop c2 bottom a)
    (ontop c2 a b)
    (ontop c2 b c)
    (ontop c2 c e)
    (ontop c2 e top)
    (first c2 bottom)
    (last c2 top)

    ; STACK DE C3
    (ontop c3 bottom b)
    (ontop c3 b top)
    (first c3 bottom)
    (last c3 top)

    ; STACK DE C4
    (ontop c4 bottom c)
    (ontop c4 c d)
    (ontop c4 d top)
    (first c4 bottom)
    (last c4 top)

    ; STACK DE C5
    (ontop c5 bottom e)
    (ontop c5 e d)
    (ontop c5 d top)
    (first c5 bottom)
    (last c5 top)
)

(:goal (and
    (ontop c1 bottom top)
    (ontop c2 bottom top)
    (ontop c3 bottom top)
    (ontop c4 bottom top)
    (ontop c5 bottom top)
))
)