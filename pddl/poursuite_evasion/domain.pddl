(define (domain pursuite)

(:requirements :strips  :typing)

(:types
    cops
    case
    link
)

(:predicates
    (onto ?cops - cops ?case - case)
    (nextto ?caseA - case ?caseB - case ?link - link)

    (emptycase ?case)
    (occupiedcase ?case)

    (ontop ?case - case ?link1 - link ?link2 - link)
    (first ?case - case ?link - link)
    (last ?case - case ?link - link)

    (istop ?link - link)
    (isbottom ?link - link)
    
    (isalone ?cops - cops)
    (isnotalone ?cops - cops)

;    (onstack ?case - case ?link - link)
)

(:action move_alone_to_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?prev_init - link ?next_init - link ?prev_goal - link ?next_goal - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (emptycase ?goal_case)
        (isalone ?cops)
        (nextto ?init_case ?goal_case ?link)
        
        (ontop ?init_case ?prev_init ?link)
        (ontop ?init_case ?link ?next_init)
        
        (ontop ?goal_case ?prev_goal ?link)
        (ontop ?goal_case ?link ?next_goal)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))
        (not (emptycase ?goal_case))
        (occupiedcase ?goal_case)
        (emptycase ?init_case)
        (not (occupiedcase ?init_case))
        
        (ontop ?init_case ?prev_init ?next_init)
        (not (ontop ?init_case ?prev_init ?link))
        (not (ontop ?init_case ?link ?next_init))
        
        (ontop ?goal_case ?prev_goal ?next_goal)
        (not (ontop ?goal_case ?prev_goal ?link))
        (not (ontop ?goal_case ?link ?next_goal))
    )
)

(:action move_alone_to_not_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?prev_init - link ?next_init - link ?prev_goal - link ?next_goal - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isalone ?cops)
        (occupiedcase ?goal_case)
        (nextto ?init_case ?goal_case ?link)
        
        (ontop ?init_case ?prev_init ?link)
        (ontop ?init_case ?link ?next_init)
        
        (ontop ?goal_case ?prev_goal ?link)
        (ontop ?goal_case ?link ?next_goal)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))
        (not (isalone ?cops))
        (isnotalone ?cops)
        (emptycase ?init_case)
        (not (occupiedcase ?init_case))
        
        (ontop ?init_case ?prev_init ?next_init)
        (not (ontop ?init_case ?prev_init ?link))
        (not (ontop ?init_case ?link ?next_init))
        
        (ontop ?goal_case ?prev_goal ?next_goal)
        (not (ontop ?goal_case ?prev_goal ?link))
        (not (ontop ?goal_case ?link ?next_goal))
    )       
)

(:action move_not_alone_to_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?prev_init - link ?next_init - link ?prev_goal - link ?next_goal - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isnotalone ?cops)
        (emptycase ?goal_case)
        (nextto ?init_case ?goal_case ?link)
        
        (ontop ?init_case ?prev_init ?link)
        (ontop ?init_case ?link ?next_init)
        
        (ontop ?goal_case ?prev_goal ?link)
        (ontop ?goal_case ?link ?next_goal)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))
        (isalone ?cops)
        (not (isnotalone ?cops))
        (not (emptycase ?goal_case))
        (occupiedcase ?goal_case)
        
        (ontop ?init_case ?prev_init ?next_init)
        (not (ontop ?init_case ?prev_init ?link))
        (not (ontop ?init_case ?link ?next_init))
        
        (ontop ?goal_case ?prev_goal ?next_goal)
        (not (ontop ?goal_case ?prev_goal ?link))
        (not (ontop ?goal_case ?link ?next_goal))
    )       
)

(:action move_not_alone_to_not_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?prev_init - link ?next_init - link ?prev_goal - link ?next_goal - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isnotalone ?cops)
        (occupiedcase ?goal_case)
        (nextto ?init_case ?goal_case ?link)
        
        (ontop ?init_case ?prev_init ?link)
        (ontop ?init_case ?link ?next_init)
        
        (ontop ?goal_case ?prev_goal ?link)
        (ontop ?goal_case ?link ?next_goal)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))
        
        (ontop ?init_case ?prev_init ?next_init)
        (not (ontop ?init_case ?prev_init ?link))
        (not (ontop ?init_case ?link ?next_init))
        
        (ontop ?goal_case ?prev_goal ?next_goal)
        (not (ontop ?goal_case ?prev_goal ?link))
        (not (ontop ?goal_case ?link ?next_goal))
    )       
)

(:action join
    :parameters (?init_case - case ?goal_case - case ?link - link ?cops1 - cops ?cops2 - cops)    

    :precondition (and 
        (onto ?cops1 ?init_case)
        (isalone ?cops1)

        (onto ?cops2 ?goal_case)
        (isalone ?cops2)

        (nextto ?init_case ?goal_case ?link)
    )

    :effect (and 
        (onto ?cops1 ?goal_case)
        (not (onto ?cops1 ?init_case))

        (onto ?cops2 ?init_case)
        (not (onto ?cops2 ?goal_case))

        (isnotalone ?cops1)
        (isnotalone ?cops2)
    )
)
    


)