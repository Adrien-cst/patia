(define (domain sokoban)

(:requirements :strips :typing)

(:types
    case
    direction
)


(:predicates
    ;; 1. Les cases adjacentes (case1 vers case2 dans la direction dir)
    (adjacent ?case1 - case ?case2 - case ?dir - direction)
    
    (box_at ?case - case)
    (empty_case ?case - case)

    (guard_at ?case - case)
)


;; 1. Déplacer le gardien
(:action move-guard
    :parameters (?from ?to - case ?dir -direction)
    :precondition (and 
        (adjacent ?from ?to ?dir)
        (empty_case ?to)
        (guard_at ?from)
    )
    :effect (and 
        (not (guard_at ?from))
        (guard_at ?to)
        
        (not(empty_case ?to))
        (empty_case ?from)
    )
)

;; 2. Déplacer la caisse
(
    :action move-box
        :parameters (?from ?middle ?to - case ?dir - direction)
        :precondition (and 
            (adjacent ?from ?middle ?dir)
            (adjacent ?middle ?to ?dir)

            (empty_case ?to)

            (box_at ?middle)
            (guard_at ?from)
        )
        :effect (and 
            (not (guard_at ?from))
            (guard_at ?middle)

            (not (box_at ?middle))
            (box_at ?to)
            
            (not(empty_case ?to))
            (empty_case ?from)
        )
)
)