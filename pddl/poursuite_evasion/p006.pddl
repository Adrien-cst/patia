(define (problem poursuite-evasion-2)
(:domain pursuite)

(:objects
    cops1 cops2 - cops
    c1 c2 c3 c4 - case
    a b c d top bottom - link
)

(:init
    (occupiedcase c1)
    (emptycase c2)
    (emptycase c3)
    (emptycase c4)

    
    (nextto c1 c2 a)
    (nextto c2 c1 a)
    
    (nextto c2 c3 c)
    (nextto c3 c2 c)

    (nextto c2 c4 b)
    (nextto c4 c2 b)

    (nextto c3 c4 d)
    (nextto c4 c3 d)

    (onto cops1 c1)
    (onto cops2 c1)

    (istop top)
    (isbottom bottom)

    ; STACK DE C1
;    (onstack c1 a)
    (ontop c1 bottom a)
    (ontop c1 a top)

    
    ; STACK DE C2
;    (onstack c2 a)
;    (onstack c2 b)
;    (onstack c2 c)

    (ontop c2 bottom c)
    (ontop c2 c b)
    (ontop c2 b a)
    (ontop c2 a top)

    ; STACK DE C3
;    (onstack c3 c)
;    (onstack c3 d)

    (ontop c3 bottom c)
    (ontop c3 c d)
    (ontop c3 d top)

    ; STACK DE C4
;    (onstack c4 b)
;    (onstack c4 d)

    (ontop c4 bottom b)
    (ontop c4 b d)
    (ontop c4 d top)
)

(:goal (and
    (ontop c1 bottom top)
    (ontop c2 bottom top)
    (ontop c3 bottom top)
    (ontop c4 bottom top)
))
)