(define (problem sokoban-level-screenshot)
(:domain sokoban)

(:objects
    ;; Pièce du haut
    c_2_2 c_3_2
    c_2_3 c_3_3

    ;; Longue ligne avec la première caisse sombre
    c_2_4 c_3_4 c_4_4 c_5_4 c_6_4 c_7_4

    ;; Ligne principale avec les 3 autres caisses
    c_2_5 c_3_5 c_4_5 c_5_5 c_6_5 c_7_5

    ;; Ligne avec la cible centrale (ATTENTION : c_4_6 est un mur, donc absent)
    c_2_6 c_3_6 c_5_6 c_6_6 c_7_6

    ;; Ligne du bas avec le gardien et la cible gauche
    c_2_7 c_3_7 c_4_7 c_5_7 c_6_7 c_7_7 - case

    U D L R - direction
)

(:init
    ;; ==========================================
    ;; 1. ADJACENCES HORIZONTALES (Left / Right)
    ;; ==========================================
    (adjacent c_2_2 c_3_2 R) (adjacent c_3_2 c_2_2 L)
    
    (adjacent c_2_3 c_3_3 R) (adjacent c_3_3 c_2_3 L)

    (adjacent c_2_4 c_3_4 R) (adjacent c_3_4 c_2_4 L)
    (adjacent c_3_4 c_4_4 R) (adjacent c_4_4 c_3_4 L)
    (adjacent c_4_4 c_5_4 R) (adjacent c_5_4 c_4_4 L)
    (adjacent c_5_4 c_6_4 R) (adjacent c_6_4 c_5_4 L)
    (adjacent c_6_4 c_7_4 R) (adjacent c_7_4 c_6_4 L)

    (adjacent c_2_5 c_3_5 R) (adjacent c_3_5 c_2_5 L)
    (adjacent c_3_5 c_4_5 R) (adjacent c_4_5 c_3_5 L)
    (adjacent c_4_5 c_5_5 R) (adjacent c_5_5 c_4_5 L)
    (adjacent c_5_5 c_6_5 R) (adjacent c_6_5 c_5_5 L)
    (adjacent c_6_5 c_7_5 R) (adjacent c_7_5 c_6_5 L)

    ;; Le trou en c_4_6 sépare cette ligne en deux
    (adjacent c_2_6 c_3_6 R) (adjacent c_3_6 c_2_6 L)
    (adjacent c_5_6 c_6_6 R) (adjacent c_6_6 c_5_6 L)
    (adjacent c_6_6 c_7_6 R) (adjacent c_7_6 c_6_6 L)

    (adjacent c_2_7 c_3_7 R) (adjacent c_3_7 c_2_7 L)
    (adjacent c_3_7 c_4_7 R) (adjacent c_4_7 c_3_7 L)
    (adjacent c_4_7 c_5_7 R) (adjacent c_5_7 c_4_7 L)
    (adjacent c_5_7 c_6_7 R) (adjacent c_6_7 c_5_7 L)
    (adjacent c_6_7 c_7_7 R) (adjacent c_7_7 c_6_7 L)

    ;; ==========================================
    ;; 2. ADJACENCES VERTICALES (Up / Down)
    ;; ==========================================
    ;; Colonne 2
    (adjacent c_2_2 c_2_3 D) (adjacent c_2_3 c_2_2 U)
    (adjacent c_2_3 c_2_4 D) (adjacent c_2_4 c_2_3 U)
    (adjacent c_2_4 c_2_5 D) (adjacent c_2_5 c_2_4 U)
    (adjacent c_2_5 c_2_6 D) (adjacent c_2_6 c_2_5 U)
    (adjacent c_2_6 c_2_7 D) (adjacent c_2_7 c_2_6 U)

    ;; Colonne 3
    (adjacent c_3_2 c_3_3 D) (adjacent c_3_3 c_3_2 U)
    (adjacent c_3_3 c_3_4 D) (adjacent c_3_4 c_3_3 U)
    (adjacent c_3_4 c_3_5 D) (adjacent c_3_5 c_3_4 U)
    (adjacent c_3_5 c_3_6 D) (adjacent c_3_6 c_3_5 U)
    (adjacent c_3_6 c_3_7 D) (adjacent c_3_7 c_3_6 U)

    ;; Colonne 4 (Interrompue par le mur en c_4_6)
    (adjacent c_4_4 c_4_5 D) (adjacent c_4_5 c_4_4 U)
    ;; pas de lien c_4_5 vers c_4_7 !

    ;; Colonne 5
    (adjacent c_5_4 c_5_5 D) (adjacent c_5_5 c_5_4 U)
    (adjacent c_5_5 c_5_6 D) (adjacent c_5_6 c_5_5 U)
    (adjacent c_5_6 c_5_7 D) (adjacent c_5_7 c_5_6 U)

    ;; Colonne 6
    (adjacent c_6_4 c_6_5 D) (adjacent c_6_5 c_6_4 U)
    (adjacent c_6_5 c_6_6 D) (adjacent c_6_6 c_6_5 U)
    (adjacent c_6_6 c_6_7 D) (adjacent c_6_7 c_6_6 U)

    ;; Colonne 7
    (adjacent c_7_4 c_7_5 D) (adjacent c_7_5 c_7_4 U)
    (adjacent c_7_5 c_7_6 D) (adjacent c_7_6 c_7_5 U)
    (adjacent c_7_6 c_7_7 D) (adjacent c_7_7 c_7_6 U)

    ;; ==========================================
    ;; 3. ETAT INITIAL
    ;; ==========================================

    (guard_at c_4_7)

    ;; Caisses noircies (déjà sur les cibles)
    (box_at c_4_4)
    (box_at c_3_5)
    ;; Caisses claires
    (box_at c_4_5)
    (box_at c_6_5)

    ;; Cases vides
    (empty_case c_2_2) (empty_case c_3_2)
    (empty_case c_2_3) (empty_case c_3_3)
    (empty_case c_2_4) (empty_case c_3_4) (empty_case c_5_4) (empty_case c_6_4) (empty_case c_7_4)
    (empty_case c_2_5) (empty_case c_5_5) (empty_case c_7_5)
    (empty_case c_2_6) (empty_case c_3_6) (empty_case c_5_6) (empty_case c_6_6) (empty_case c_7_6)
    (empty_case c_2_7) (empty_case c_3_7) (empty_case c_5_7) (empty_case c_6_7) (empty_case c_7_7)
)

(:goal (and
    (box_at c_4_4)  ;; Cible de la caisse noircie 1
    (box_at c_3_5)  ;; Cible de la caisse noircie 2
    (box_at c_3_6)  ;; Cible vide centrale
    (box_at c_2_7)  ;; Cible vide en bas à gauche
))

)