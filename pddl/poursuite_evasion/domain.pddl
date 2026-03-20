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

    (ontop ?case - case ?bottom - link ?top - link)

    (istop ?link - link)
    (isbottom ?link - link)
    (isalone ?cops - cops)
    (isnotalone ?cops - cops)

;    (onstack ?case - case ?link - link)
)

(:action move_alone_to_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?top_link_a - link ?bottom_link_a - link ?top_link_b - link ?bottom_link_b - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (emptycase ?goal_case)

        (isalone ?cops)
        (nextto ?init_case ?goal_case ?link)

;        (onstack ?init_case ?link)
;        (onstack ?goal_case ?link)

        (istop ?top_link_a)
        (isbottom ?bottom_link_a)

        (ontop ?init_case ?link ?top_link_a)
        (ontop ?init_case ?bottom_link_a ?link)

        (ontop ?goal_case ?link ?top_link_b)
        (ontop ?goal_case ?bottom_link_b ?link)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))

        (not (emptycase ?goal_case))
        (occupiedcase ?goal_case)

        (emptycase ?init_case)
        (not (occupiedcase ?init_case))

;        (not (onstack ?init_case ?link))
;        (not (onstack ?goal_case ?link))
        
        (ontop ?init_case ?bottom_link_a ?top_link_a)
        (ontop ?goal_case ?bottom_link_b ?top_link_b)
    )
)

(:action move_alone_to_not_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?top_link_a - link ?bottom_link_a - link ?top_link_b - link ?bottom_link_b - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isalone ?cops)
        
        (occupiedcase ?goal_case)
        (nextto ?init_case ?goal_case ?link)

;        (onstack ?init_case ?link)
;        (onstack ?goal_case ?link)

        (istop ?top_link_a)
        (isbottom ?bottom_link_a)

        (ontop ?init_case ?link ?top_link_a)
        (ontop ?init_case ?bottom_link_a ?link)

        (ontop ?goal_case ?link ?top_link_b)
        (ontop ?goal_case ?bottom_link_b ?link)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))

        
        (not (isalone ?cops))
        (isnotalone ?cops)

        (emptycase ?init_case)
        (not (occupiedcase ?init_case))


;        (not (onstack ?init_case ?link))
;        (not (onstack ?goal_case ?link))
        
        (ontop ?init_case ?bottom_link_a ?top_link_a)
        (ontop ?goal_case ?bottom_link_b ?top_link_b)
    )       
)

(:action move_not_alone_to_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?top_link_a - link ?bottom_link_a - link ?top_link_b - link ?bottom_link_b - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isnotalone ?cops)
        
        (emptycase ?goal_case)
        (nextto ?init_case ?goal_case ?link)

        (ontop ?init_case ?link ?top_link_a)
        (ontop ?init_case ?bottom_link_a ?link)

        (ontop ?goal_case ?link ?top_link_b)
        (ontop ?goal_case ?bottom_link_b ?link)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))


        (isalone ?cops)
        (not (isnotalone ?cops))

        (not (emptycase ?goal_case))
        (occupiedcase ?goal_case)

;        (not (onstack ?init_case ?link))
;        (not (onstack ?goal_case ?link))
        
        (ontop ?init_case ?bottom_link_a ?top_link_a)
        (ontop ?goal_case ?bottom_link_b ?top_link_b)
    )       
)

(:action move_not_alone_to_not_alone
    :parameters (?init_case - case ?goal_case - case ?link - link ?top_link_a - link ?bottom_link_a - link ?top_link_b - link ?bottom_link_b - link ?cops - cops)

    :precondition (and 
        (onto ?cops ?init_case)
        (isnotalone ?cops)
        
        (occupiedcase ?goal_case)
        (nextto ?init_case ?goal_case ?link)

        (ontop ?init_case ?link ?top_link_a)
        (ontop ?init_case ?bottom_link_a ?link)

        (ontop ?goal_case ?link ?top_link_b)
        (ontop ?goal_case ?bottom_link_b ?link)
    )

    :effect (and 
        (onto ?cops ?goal_case)
        (not (onto ?cops ?init_case))

;        (not (onstack ?init_case ?link))
;        (not (onstack ?goal_case ?link))
        
        (ontop ?init_case ?bottom_link_a ?top_link_a)
        (ontop ?goal_case ?bottom_link_b ?top_link_b)
    )       
)

; (:action join
    
; )
    


)