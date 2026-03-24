(define (problem poursuite-evasion-p001)
(:domain pursuite)

(:objects
    cops1 - cops
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

    ; Arêtes à visiter par case
    ; c1 : pile simple avec un seul lien
    (in-pile a c1)
    (istop a c1)
    (isbottom a c1)
    (link-needed c1 a)
    
    ; c2 : pile avec deux liens B(bottom) -> C(top)
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
    (link-visited c1 a)
    (link-visited c2 a)
    (link-visited c2 b)
    (link-visited c3 b)
))

)