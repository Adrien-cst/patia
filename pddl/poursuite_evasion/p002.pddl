(define (problem pursuit-evasion-p002)
(:domain pursuit)

(:objects
    cops1 cops2 - cops
    c1 c2 c3 - case
    a b - link
)

(:init
    ; Adjacence
    (adjacent c1 c2 a)
    (adjacent c2 c1 a)
    (adjacent c2 c3 b)
    (adjacent c3 c2 b)

    ; Placement des policiers
    (on cops1 c1)
    (single-cop cops1 c1)

    (on cops2 c3)
    (single-cop cops2 c3)
    
    ; Distinction des policiers (pour empêcher cops-join trivial)
    (is-different cops1 cops2)
    (is-different cops2 cops1)

    ; Arêtes à visiter par case
    ; c1 : pile simple avec un seul lien
    (in-pile a c1)
    (istop a c1)
    (isbottom a c1)
    (link-needed c1 a)
    
    ; c2 : pile avec deux liens a(bottom) -> b(top)
    (in-pile a c2)
    (in-pile b c2)
    (isbottom a c2)
    (istop b c2)
    (ontop b a c2)
    (link-needed c2 a)
    (link-needed c2 b)
    
    ; c3 : pile simple avec un seul lien
    (in-pile b c3)
    (istop b c3)
    (isbottom b c3)
    (link-needed c3 b)
)

(:goal (and
    (emptystack c1)
    (emptystack c2)
    (emptystack c3)
))

)