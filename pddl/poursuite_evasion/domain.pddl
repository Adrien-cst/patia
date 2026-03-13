(define (domain pursuite)

(:requirements :strips  :typing)

(:types
    cops
    case
    linknn
)

(:predicates
   (safe ?x - case)
   (unsafe ?x - case)

    (nextto ?x - case ?y - case)
    (onto ?x - cops ?y - case)
    
    (nocops ?x - case)
    
    (alone ?x - cops)
    (moving ?x - cops)
    (first ?x - cops)
    (nomovement)

    (emptycase ?from)
)

(:action leave_empty
    :parameters (?cops - cops ?from - case ?to - case)

    :precondition (and 
        (alone ?cops)
        (first ?cops)
        (onto ?cops ?from)
        (nextto ?from ?to)
        (nomovement)
    )

    :effect (and 
        (not (alone ?cops))
        (not (first ?cops))
        (not (onto ?cops ?from))
        (emptycase ?from)
        (not (nomovement))
        (moving ?cops)
        (forall (?case) )
    )

)
    


)