(define (problem sokoban-niveau_2)
(:domain sokoban)

(:objects

    c0_0 c0_1 c0_2 c0_3
    c1_0 c1_2 c1_3
    c2_0 c2_1 c2_2 c2_3 c2_4
    c3_2 c3_3 c3_4
    c4_2 c4_3 c4_4 - case

    U D L R - direction
)

(:init
    ;; Adjacences horizontales
    (adjacent c0_0 c0_1 R) (adjacent c0_1 c0_0 L)
    (adjacent c0_1 c0_2 R) (adjacent c0_2 c0_1 L)
    (adjacent c0_2 c0_3 R) (adjacent c0_3 c0_2 L)

    (adjacent c1_2 c1_3 R) (adjacent c1_3 c1_2 L)

    (adjacent c2_0 c2_1 R) (adjacent c2_1 c2_0 L)
    (adjacent c2_1 c2_2 R) (adjacent c2_2 c2_1 L)
    (adjacent c2_2 c2_3 R) (adjacent c2_3 c2_2 L)
    (adjacent c2_3 c2_4 R) (adjacent c2_4 c2_3 L)

    (adjacent c3_2 c3_3 R) (adjacent c3_3 c3_2 L)
    (adjacent c3_3 c3_4 R) (adjacent c3_4 c3_3 L)

    (adjacent c4_2 c4_3 R) (adjacent c4_3 c4_2 L)
    (adjacent c4_3 c4_4 R) (adjacent c4_4 c4_3 L)

    ;; Adjacences verticales
    (adjacent c0_0 c1_0 D) (adjacent c1_0 c0_0 U)
    (adjacent c1_0 c2_0 D) (adjacent c2_0 c1_0 U)

    (adjacent c0_2 c1_2 D) (adjacent c1_2 c0_2 U)
    (adjacent c1_2 c2_2 D) (adjacent c2_2 c1_2 U)
    (adjacent c2_2 c3_2 D) (adjacent c3_2 c2_2 U)
    (adjacent c3_2 c4_2 D) (adjacent c4_2 c3_2 U)

    (adjacent c0_3 c1_3 D) (adjacent c1_3 c0_3 U)
    (adjacent c1_3 c2_3 D) (adjacent c2_3 c1_3 U)
    (adjacent c2_3 c3_3 D) (adjacent c3_3 c2_3 U)
    (adjacent c3_3 c4_3 D) (adjacent c4_3 c3_3 U)

    (adjacent c2_4 c3_4 D) (adjacent c3_4 c2_4 U)
    (adjacent c3_4 c4_4 D) (adjacent c4_4 c3_4 U)

    ;; safe cases
    (safe_target c0_1)
    (safe_target c0_2)
    (safe_target c1_0)
    (safe_target c1_2)
    (safe_target c1_3)
    (safe_target c2_1)
    (safe_target c2_2)
    (safe_target c2_3)
    (safe_target c3_2)
    (safe_target c3_3)
    (safe_target c3_4)
    (safe_target c4_3)

    ;; Etats initiaux

    (guard_at c3_3)

    (box_at c2_2)
    (box_at c2_3)
    (box_at c3_2)

    (empty_case c0_0) (empty_case c0_1) (empty_case c0_2) (empty_case c0_3)
    (empty_case c1_0) (empty_case c1_2) (empty_case c1_3)
    (empty_case c2_0) (empty_case c2_1) (empty_case c2_4)
    (empty_case c3_4)
    (empty_case c4_2) (empty_case c4_3) (empty_case c4_4)
)
(:goal (and
    (box_at c1_2)
    (box_at c3_2)
    (box_at c3_3)
))

)