(define (problem sokoban-p001)
(:domain sokoban)

(:objects
    c1 c2 c3 c4 c5 c6 c7 - case
    U D L R - direction
)

(:init
    ; Adjacence
    (adjacent c1 c2 D)

    (adjacent c2 c1 U)
    (adjacent c2 c3 D)

    (adjacent c3 c2 U)
    (adjacent c3 c4 L)
    (adjacent c3 c6 D)

    (adjacent c4 c3 R)
    (adjacent c4 c5 D)

    (adjacent c5 c4 U)
    (adjacent c5 c6 R)

    (adjacent c6 c5 L)
    (adjacent c6 c3 U)
    (adjacent c6 c7 R)

    (adjacent c7 c6 L)

    (safe_target c3)
    (safe_target c6)
    (safe_target c7)
    
    (empty_case c2)
    (empty_case c3)
    (empty_case c4)
    (empty_case c5)
    (empty_case c7)

    (box_at c6)
    (guard_at c1)
)

(:goal (and
    (box_at c7)
))

)