(define (domain taquin)

(:requirements :strips :typing)

(:types
    tile
    case
)

(:predicates
    (placed ?x - tile ?y - case)
    (clear ?x - case)
    (nextto ?x - case ?y - case)
)

(:action move
    :parameters (?tile - tile ?blank - case ?used - case)
    
    :precondition (and 
        (clear ?blank)
        (placed ?tile ?used)
        (nextto ?blank ?used)
    )

    :effect (and 
        (clear ?used)
        (placed ?tile ?blank)
        (not(clear ?blank))
        (not(placed ?tile ?used))
    )
)

)