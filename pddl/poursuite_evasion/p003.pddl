(define (problem poursuite-evasion-p003)
(:domain pursuite)

(:objects
    cops1 cops2 cops3 - cops
    c1 c2 c3 c4 - case
    a b c - link
)

(:init
    ; Adjacence
    (adjacent c1 c2 a)
    (adjacent c2 c1 a)
    (adjacent c2 c3 b)
    (adjacent c3 c2 b)
    (adjacent c2 c4 c)
    (adjacent c4 c2 c)

    ; Placement des policiers
    (on cops1 c1)
    (single-cop cops1 c1)

    (on cops2 c3)
    (single-cop cops2 c3)

    (on cops3 c4)
    (single-cop cops3 c4)
    
    ; Distinction des policiers (pour empêcher cops-join trivial)
    (is-different cops1 cops2)
    (is-different cops1 cops3)
    (is-different cops2 cops1)
    (is-different cops2 cops3)
    (is-different cops3 cops1)
    (is-different cops3 cops2)

    ; Arêtes à visiter par case
    ; c1 : pile simple
    (in-pile a c1)
    (istop a c1)
    (isbottom a c1)
    (link-needed c1 a)
    
    ; c2 : pile avec trois liens a(bottom) -> b -> c(top)
    (in-pile a c2)
    (in-pile b c2)
    (in-pile c c2)
    (isbottom a c2)
    (istop c c2)
    (ontop b a c2)
    (ontop c b c2)
    (link-needed c2 a)
    (link-needed c2 b)
    (link-needed c2 c)
    
    ; c3 : pile simple
    (in-pile b c3)
    (istop b c3)
    (isbottom b c3)
    (link-needed c3 b)
    
    ; c4 : pile simple
    (in-pile c c4)
    (istop c c4)
    (isbottom c c4)
    (link-needed c4 c)
)

(:goal (and
    (emptystack c1)
    (emptystack c2)
    (emptystack c3)
    (emptystack c4)
))

)