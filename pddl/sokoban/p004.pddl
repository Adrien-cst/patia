(define (problem sokoban-sniveau_30)
(:domain sokoban)

(:objects
    ;; Ligne 1
    c1_2 c1_3 c1_4
    ;; Ligne 2
    c2_1 c2_2 c2_3 c2_4 c2_5
    ;; Ligne 3
    c3_1 c3_3 c3_5 c3_6
    ;; Ligne 4
    c4_1 c4_2 c4_3 c4_4 c4_5 c4_7
    ;; Ligne 5
    c5_2 c5_3 c5_4 c5_5 c5_7
    ;; Ligne 6
    c6_1 c6_2 c6_5 c6_7
    ;; Ligne 7
    c7_1 c7_2 c7_3 c7_5 c7_6
    ;; Ligne 8
    c8_4 c8_5 c8_6 - case

    U D L R - direction
)

(:init
    ;; --- Adjacences Horizontales ---
    (adjacent c1_2 c1_3 R) (adjacent c1_3 c1_2 L) (adjacent c1_3 c1_4 R) (adjacent c1_4 c1_3 L)
    (adjacent c2_1 c2_2 R) (adjacent c2_2 c2_1 L) (adjacent c2_2 c2_3 R) (adjacent c2_3 c2_2 L) (adjacent c2_3 c2_4 R) (adjacent c2_4 c2_3 L) (adjacent c2_4 c2_5 R) (adjacent c2_5 c2_4 L)
    (adjacent c3_5 c3_6 R) (adjacent c3_6 c3_5 L)
    (adjacent c4_1 c4_2 R) (adjacent c4_2 c4_1 L) (adjacent c4_3 c4_4 R) (adjacent c4_4 c4_3 L) (adjacent c4_4 c4_5 R) (adjacent c4_5 c4_4 L)
    (adjacent c5_2 c5_3 R) (adjacent c5_3 c5_2 L) (adjacent c5_3 c5_4 R) (adjacent c5_4 c5_3 L) (adjacent c5_4 c5_5 R) (adjacent c5_5 c5_4 L)
    (adjacent c6_1 c6_2 R) (adjacent c6_2 c6_1 L)
    (adjacent c7_1 c7_2 R) (adjacent c7_2 c7_1 L) (adjacent c7_2 c7_3 R) (adjacent c7_3 c7_2 L) (adjacent c7_5 c7_6 R) (adjacent c7_6 c7_5 L)
    (adjacent c8_4 c8_5 R) (adjacent c8_5 c8_4 L) (adjacent c8_5 c8_6 R) (adjacent c8_6 c8_5 L)

    ;; --- Adjacences Verticales ---
    (adjacent c1_2 c2_2 D) (adjacent c2_2 c1_2 U) (adjacent c1_3 c2_3 D) (adjacent c2_3 c1_3 U) (adjacent c1_4 c2_4 D) (adjacent c2_4 c1_4 U)
    (adjacent c2_1 c3_1 D) (adjacent c3_1 c2_1 U) (adjacent c2_3 c3_3 D) (adjacent c3_3 c2_3 U) (adjacent c2_5 c3_5 D) (adjacent c3_5 c2_5 U)
    (adjacent c3_1 c4_1 D) (adjacent c4_1 c3_1 U) (adjacent c3_3 c4_3 D) (adjacent c4_3 c3_3 U) (adjacent c3_5 c4_5 D) (adjacent c4_5 c3_5 U)
    (adjacent c4_1 c5_1 D) (adjacent c5_1 c4_1 U) (adjacent c4_2 c5_2 D) (adjacent c5_2 c4_2 U) (adjacent c4_3 c5_3 D) (adjacent c5_3 c4_3 U) (adjacent c4_5 c5_5 D) (adjacent c5_5 c4_5 U) (adjacent c4_7 c5_7 D) (adjacent c5_7 c4_7 U)
    (adjacent c5_2 c6_2 D) (adjacent c6_2 c5_2 U) (adjacent c5_5 c6_5 D) (adjacent c6_5 c5_5 U) (adjacent c5_7 c6_7 D) (adjacent c6_7 c5_7 U)
    (adjacent c6_1 c7_1 D) (adjacent c7_1 c6_1 U) (adjacent c6_2 c7_2 D) (adjacent c7_2 c6_2 U) (adjacent c6_5 c7_5 D) (adjacent c7_5 c6_5 U) (adjacent c6_7 c7_7 D) (adjacent c7_7 c6_7 U) ;; Attention c6_7/c7_7 si mur
    (adjacent c7_1 c8_1 D) (adjacent c7_5 c8_5 D) (adjacent c8_5 c7_5 U) (adjacent c7_6 c8_6 D) (adjacent c8_6 c7_6 U)

    ;; --- Positions Initiales ---
    (guard_at c4_4)    ;; @

    (box_at c2_4)      ;; $
    (box_at c3_3)      ;; $
    (box_at c4_3)      ;; $
    (box_at c5_5)      ;; $
    (box_at c5_3)      ;; * (box sur goal)
    (box_at c5_4)      ;; * (box sur goal)

    ;; --- Cases Vides ---
    (empty_case c1_2) (empty_case c1_3) (empty_case c1_4)
    (empty_case c2_1) (empty_case c2_2) (empty_case c2_3) (empty_case c2_5)
    (empty_case c3_1) (empty_case c3_5) (empty_case c3_6)
    (empty_case c4_1) (empty_case c4_2) (empty_case c4_5) (empty_case c4_7)
    (empty_case c5_2) (empty_case c5_7)
    (empty_case c6_1) (empty_case c6_2) (empty_case c6_5) (empty_case c6_7)
    (empty_case c7_1) (empty_case c7_2) (empty_case c7_3) (empty_case c7_5) (empty_case c7_6)
    (empty_case c8_4) (empty_case c8_5) (empty_case c8_6)
)

(:goal (and
    (box_at c4_5) ;; .
    (box_at c5_3) ;; *
    (box_at c5_4) ;; *
    (box_at c6_5) ;; .
    (box_at c7_5) ;; .
    ;; Le nombre de box ($) et de cibles (.) doit correspondre
))
)