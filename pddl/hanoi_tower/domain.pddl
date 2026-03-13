;Header and description

(define (domain hanoi)

;remove requirements that are not needed
(:requirements :strips :typing)

(:types disk tower)


(:predicates
    (on ?x - disk ?y - disk) ; disk x is on disk y
    (ontable ?x - disk)
    (towerempty ?x - tower)
    (ontower ?x - disk ?y - tower) ; disk x is on the tower y
    (clear ?x - disk) ; there is nothing on top of disk x
    (handempty) ; the hand is empty
    (holding ?x - disk) ; the hand is holding disk x
    (smaller ?x - disk ?y - disk) ; disk x is smaller than disk y
)


(:action pick-up
    :parameters (?x - disk ?y - tower)
    
    :precondition (and 
    (clear ?x)
    (ontable ?x) 
    (ontower ?x ?y) 
    (handempty))
    
    :effect(and 
    (not (ontower ?x ?y))
    (not (clear ?x))
    (not (ontable ?x))
    (towerempty ?y)
    (not (handempty))
    (holding ?x)
    )
)

(:action put-down
    :parameters (?x - disk ?y - tower)
    
    :precondition (and
        (holding ?x)
        (towerempty ?y)
    )
    
    :effect (and 
    (not(holding ?x))
    (clear ?x) 
    (handempty)
    (ontower ?x ?y)
    (ontable ?x)
    (not (towerempty ?y))
    )
)

(:action stack
    :parameters (?x - disk ?y - disk ?z - tower)
    
    :precondition (and 
    (holding ?x)
    (ontower ?y ?z)
    (clear ?y)
    (smaller ?x ?y)
    )
    :effect (and
    (not (holding ?x))
    (not (clear ?y))
    (clear ?x)
    (handempty)
    (on ?x ?y)
    (ontower ?x ?z)
    )
)

(:action unstack
    :parameters (?x - disk ?y - disk ?z - tower)
    :precondition (and 
        (handempty)
        (on ?x ?y)
        (ontower ?x ?z)
        (ontower ?y ?z)
        (clear ?x)
    )
    :effect (and 
        (holding ?x)
        (clear ?y)
        (not (clear ?x))
        (not (ontower ?x ?z))
        (not (handempty))
        (not (on ?x ?y))
    )
)

)