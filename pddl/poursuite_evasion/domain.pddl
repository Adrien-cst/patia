(define (domain pursuit)

(:requirements :strips :typing)

(:types
    cops
    case
    link
)

(:predicates
    (on ?cop - cops ?case - case)
    (adjacent ?case1 - case ?case2 - case ?link - link)
    
    (in-pile ?link - link ?case - case)
    (ontop ?above - link ?below - link ?case - case)
    (istop ?link - link ?case - case)
    (isbottom ?link - link ?case - case)
    (emptystack ?case - case)
    
    (link-needed ?case - case ?link - link)
    (link-visited ?case - case ?link - link)
    
    (single-cop ?cop - cops ?case - case)
    (with-company ?cop - cops ?case - case)
    
    (is-different ?cop1 - cops ?cop2 - cops)
)

;; 1. Un policier seul se déplace : il DOIT être sur le dernier lien de la pile
(:action move-single-cop
    :parameters (?cop - cops ?from ?to - case ?link - link)
    :precondition (and 
        (on ?cop ?from)
        (single-cop ?cop ?from)
        (adjacent ?from ?to ?link)
        (link-needed ?from ?link)
        (link-needed ?to ?link)
        (istop ?link ?from)
        (isbottom ?link ?from)
    )
    :effect (and 
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (single-cop ?cop ?from))
        (single-cop ?cop ?to)

        (not (link-needed ?from ?link))
        (not (link-needed ?to ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
    )
)

;; 2. Un policier accompagné se déplace : il peut partir même s'il reste plusieurs liens, 
;;    car un autre policier reste pour empêcher la recontamination.
(:action move-cop-leaving-group
    :parameters (?cop-leaving ?cop-staying - cops ?from ?to - case ?link - link)
    :precondition (and 
        (on ?cop-leaving ?from)
        (with-company ?cop-leaving ?from)
        (on ?cop-staying ?from)
        (with-company ?cop-staying ?from)
        (is-different ?cop-leaving ?cop-staying)
        
        (adjacent ?from ?to ?link)
        (link-needed ?from ?link)
        (link-needed ?to ?link)
    )
    :effect (and 
        (not (on ?cop-leaving ?from))
        (on ?cop-leaving ?to)
        
        (not (with-company ?cop-leaving ?from))
        (single-cop ?cop-leaving ?to)
        
        (not (with-company ?cop-staying ?from))
        (single-cop ?cop-staying ?from)

        (not (link-needed ?from ?link))
        (not (link-needed ?to ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
    )
)

;; Actions de gestion de la pile (s'activent asynchronement dès qu'un lien a été "link-visited")
(:action clear-stack-single
    :parameters (?case - case ?link - link)
    :precondition (and 
        (link-visited ?case ?link)
        (istop ?link ?case)
        (isbottom ?link ?case)
    )
    :effect (and 
        (not (in-pile ?link ?case))
        (not (istop ?link ?case))
        (not (isbottom ?link ?case))
        (not (link-visited ?case ?link))
        (emptystack ?case)
    )
)

(:action clear-stack-top
    :parameters (?case - case ?link ?below - link)
    :precondition (and 
        (link-visited ?case ?link)
        (istop ?link ?case)
        (ontop ?link ?below ?case)
    )
    :effect (and 
        (not (in-pile ?link ?case))
        (not (istop ?link ?case))
        (not (ontop ?link ?below ?case))
        (istop ?below ?case)
        (not (link-visited ?case ?link))
    )
)

(:action clear-stack-bottom
    :parameters (?case - case ?link ?above - link)
    :precondition (and 
        (link-visited ?case ?link)
        (isbottom ?link ?case)
        (ontop ?above ?link ?case)
    )
    :effect (and 
        (not (in-pile ?link ?case))
        (not (isbottom ?link ?case))
        (not (ontop ?above ?link ?case))
        (isbottom ?above ?case)
        (not (link-visited ?case ?link))
    )
)

(:action clear-stack-middle
    :parameters (?case - case ?link ?above ?below - link)
    :precondition (and 
        (link-visited ?case ?link)
        (ontop ?above ?link ?case)
        (ontop ?link ?below ?case)
    )
    :effect (and 
        (not (in-pile ?link ?case))
        (not (ontop ?above ?link ?case))
        (not (ontop ?link ?below ?case))
        (ontop ?above ?below ?case)
        (not (link-visited ?case ?link))
    )
)

;; Un policier rejoint un autre sur une case adjacente.
;; Ce mouvement est possible même si le lien a déjà été "visité", mais il
;; doit cependant respecter la règle de non-recontamination.

;; Cas 1: Le policier qui bouge est seul et quitte une case sécurisée.
(:action cops-join-from-secured
    :parameters (?cop-move ?cop-at-dest - cops ?from ?to - case ?link - link)
    :precondition (and 
        (on ?cop-move ?from)
        (single-cop ?cop-move ?from)
        (on ?cop-at-dest ?to)
        (adjacent ?from ?to ?link)
        (is-different ?cop-move ?cop-at-dest)
        (istop ?link ?from)
        (isbottom ?link ?from)
    )
    :effect (and 
        (not (on ?cop-move ?from))
        (on ?cop-move ?to)
        (not (single-cop ?cop-move ?from))
        (single-cop ?cop-move ?to)
    )
)

;; Cas 2: Le policier qui bouge est en groupe et laisse un coéquipier derrière pour garder la case.
(:action cops-join-leaving-guard
    :parameters (?cop-move ?cop-guard ?cop-at-dest - cops ?from ?to - case ?link - link)
    :precondition (and
        (on ?cop-move ?from)
        (with-company ?cop-move ?from)
        (on ?cop-guard ?from)
        (with-company ?cop-guard ?from)
        (is-different ?cop-move ?cop-guard)

        (on ?cop-at-dest ?to)
        (adjacent ?from ?to ?link)
        (is-different ?cop-move ?cop-at-dest)
    )
    :effect (and
        (not (on ?cop-move ?from))
        (on ?cop-move ?to)
        (not (with-company ?cop-move ?from))
        (single-cop ?cop-move ?to)
        (not (with-company ?cop-guard ?from))
        (single-cop ?cop-guard ?from)
    )
)

(:action cops-group
    :parameters (?cop1 ?cop2 - cops ?case - case)
    :precondition (and
        (on ?cop1 ?case)
        (on ?cop2 ?case)
        (single-cop ?cop1 ?case)
        (single-cop ?cop2 ?case)
        (is-different ?cop1 ?cop2)
    )
    :effect (and
        (not (single-cop ?cop1 ?case))
        (with-company ?cop1 ?case)
        (not (single-cop ?cop2 ?case))
        (with-company ?cop2 ?case)
    )
)

(:action cop-joins-existing-group
    :parameters (?cop-new - cops ?cop-group - cops ?case - case)
    :precondition (and
        (on ?cop-new ?case)
        (on ?cop-group ?case)
        (single-cop ?cop-new ?case)
        (with-company ?cop-group ?case)
        (is-different ?cop-new ?cop-group)
    )
    :effect (and
        (not (single-cop ?cop-new ?case))
        (with-company ?cop-new ?case)
    )
)

)