(define (problem poursuite-evasion-p006)
(:domain pursuite)

(:objects
    cops1 cops2 - cops
    c1 c2 c3 c4 c5 - case
    a b c d e - link
)

(:init
    ; États des cases
    ; Adjacence
    (adjacent c1 c2 a)
    (adjacent c2 c1 a)
    (adjacent c2 c3 b)
    (adjacent c3 c2 b)
    (adjacent c2 c4 c)
    (adjacent c4 c2 c)
    (adjacent c4 c5 d)
    (adjacent c5 c4 d)
    (adjacent c2 c5 e)
    (adjacent c5 c2 e)

    ; Placement des policiers : les deux commencent seuls puis se rejoignent
    (on cops1 c1)
    (single-cop cops1 c1)
    
    (on cops2 c1)
    (single-cop cops2 c1)
    
    ; Distinction des policiers (pour empêcher cops-join trivial)
    (is-different cops1 cops2)
    (is-different cops2 cops1)

    ; Arêtes à visiter par case
    ; c1 : pile simple
    (in-pile a c1)
    (istop a c1)
    (isbottom a c1)
    (link-needed c1 a)
    
    ; c2 : pile avec quatre liens a(bottom) -> b -> c -> e(top)
    (in-pile a c2)
    (in-pile b c2)
    (in-pile c c2)
    (in-pile e c2)
    (isbottom a c2)
    (istop e c2)
    (ontop b a c2)
    (ontop c b c2)
    (ontop e c c2)
    (link-needed c2 a)
    (link-needed c2 b)
    (link-needed c2 c)
    (link-needed c2 e)
    
    ; c3 : pile simple
    (in-pile b c3)
    (istop b c3)
    (isbottom b c3)
    (link-needed c3 b)
    
    ; c4 : pile avec deux liens c(bottom) -> d(top)
    (in-pile c c4)
    (in-pile d c4)
    (isbottom c c4)
    (istop d c4)
    (ontop d c c4)
    (link-needed c4 c)
    (link-needed c4 d)

    ; c5 : pile avec deux liens d(bottom) -> e(top)
    (in-pile d c5)
    (in-pile e c5)
    (isbottom d c5)
    (istop e c5)
    (ontop e d c5)
    (link-needed c5 d)
    (link-needed c5 e)
)

(:goal (and
    (link-visited c1 a)
    (link-visited c2 a)
    (link-visited c2 b)
    (link-visited c2 c)
    (link-visited c2 e)
    (link-visited c3 b)
    (link-visited c4 c)
    (link-visited c4 d)
    (link-visited c5 d)
    (link-visited c5 e)
))
)