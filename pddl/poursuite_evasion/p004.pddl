(define (problem poursuite-evasion-2)
(:domain pursuite)

(:objects
    cops1 cops2 - cops
    c1 c2 c3 c4 - case
    a b c top bottom - link
)

(:init
    (occupiedcase c1)
    (emptycase c2)
    (occupiedcase c3)
    (emptycase c4)

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

    ; STACK DE C1
;    (onstack c1 a)
    (ontop c1 bottom a)
    (ontop c1 a top)

    
    ; STACK DE C2
;    (onstack c2 a)
;    (onstack c2 b)
;    (onstack c2 c)

    (ontop c2 bottom a)
    (ontop c2 a b)
    (ontop c2 b c)
    (ontop c2 c top)

    ; STACK DE C3
;    (onstack c3 c)
;    (onstack c3 d)

    (ontop c3 bottom b)
    (ontop c3 b top)

    ; STACK DE C4
    (ontop c4 bottom c)
    (ontop c4 c top)
)

(:goal (and
    (ontop c1 bottom top)
    (ontop c2 bottom top)
    (ontop c3 bottom top)    
    (ontop c4 bottom top)    
))

)