(define (domain pursuite)

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
    
    (link-needed ?case - case ?link - link)
    (link-visited ?case - case ?link - link)
    
    (single-cop ?cop - cops ?case - case)
    (with-company ?cop - cops ?case - case)
    
    (is-different ?cop1 - cops ?cop2 - cops)
)

;;; Un policier SEUL peut traverser une arête SEULEMENT si c'est le seul lien de sa case source
;;; Cas 1: Le lien est aussi seul dans la destination

(:action move-cop-alone-to-single
    :parameters (?cop - cops ?from ?to - case ?link - link)
    
    :precondition (and
        (on ?cop ?from)
        (single-cop ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (istop ?link ?from)
        (isbottom ?link ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (isbottom ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (istop ?link ?from))
        (not (isbottom ?link ?from))
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (isbottom ?link ?to))
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


;;; Cas 2: Le lien est au fond d'une pile multi-liens dans la destination
;;; Après suppression, le lien au-dessus devient le nouveau fond

(:action move-cop-alone-to-bottom-multi
    :parameters (?cop - cops ?from ?to - case ?link ?above - link)
    
    :precondition (and
        (on ?cop ?from)
        (single-cop ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (istop ?link ?from)
        (isbottom ?link ?from)
        (in-pile ?link ?to)
        (isbottom ?link ?to)
        (ontop ?above ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (istop ?link ?from))
        (not (isbottom ?link ?from))
        
        (not (in-pile ?link ?to))
        (not (isbottom ?link ?to))
        (not (ontop ?above ?link ?to))
        (isbottom ?above ?to)
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


;;; Un policier EN GROUPE traverse depuis le TOP d'une pile
;;; Le lien au-dessous devient le nouveau TOP en source

(:action move-cop-with-company-from-top-to-single
    :parameters (?cop - cops ?from ?to - case ?link ?below - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (istop ?link ?from)
        (ontop ?link ?below ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (isbottom ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (istop ?link ?from))
        (not (ontop ?link ?below ?from))
        (istop ?below ?from)
        
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (isbottom ?link ?to))
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


(:action move-cop-with-company-from-top-to-bottom-multi
    :parameters (?cop - cops ?from ?to - case ?link ?below-from ?above-to - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (istop ?link ?from)
        (ontop ?link ?below-from ?from)
        (in-pile ?link ?to)
        (isbottom ?link ?to)
        (ontop ?above-to ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (istop ?link ?from))
        (not (ontop ?link ?below-from ?from))
        (istop ?below-from ?from)
        
        (not (in-pile ?link ?to))
        (not (isbottom ?link ?to))
        (not (ontop ?above-to ?link ?to))
        (isbottom ?above-to ?to)
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


(:action move-cop-with-company-from-top-to-top
    :parameters (?cop - cops ?from ?to - case ?link ?below-from ?below-to - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (istop ?link ?from)
        (ontop ?link ?below-from ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (ontop ?link ?below-to ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (istop ?link ?from))
        (not (ontop ?link ?below-from ?from))
        (istop ?below-from ?from)
        
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (ontop ?link ?below-to ?to))
        (istop ?below-to ?to)
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


(:action move-cop-with-company-from-bottom-to-single
    :parameters (?cop - cops ?from ?to - case ?link ?above - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (isbottom ?link ?from)
        (ontop ?above ?link ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (isbottom ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (isbottom ?link ?from))
        (not (ontop ?above ?link ?from))
        (isbottom ?above ?from)
        
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (isbottom ?link ?to))
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


(:action move-cop-with-company-from-bottom-to-top
    :parameters (?cop - cops ?from ?to - case ?link ?above-from ?below-to - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (isbottom ?link ?from)
        (ontop ?above-from ?link ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (ontop ?link ?below-to ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (isbottom ?link ?from))
        (not (ontop ?above-from ?link ?from))
        (isbottom ?above-from ?from)
        
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (ontop ?link ?below-to ?to))
        (istop ?below-to ?to)
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)


(:action move-cop-with-company-from-middle-to-single
    :parameters (?cop - cops ?from ?to - case ?link ?above ?below - link)
    
    :precondition (and
        (on ?cop ?from)
        (with-company ?cop ?from)
        (adjacent ?from ?to ?link)
        (in-pile ?link ?from)
        (ontop ?above ?link ?from)
        (ontop ?link ?below ?from)
        (in-pile ?link ?to)
        (istop ?link ?to)
        (isbottom ?link ?to)
        (link-needed ?from ?link)
    )
    
    :effect (and
        (not (on ?cop ?from))
        (on ?cop ?to)
        
        (not (in-pile ?link ?from))
        (not (ontop ?above ?link ?from))
        (not (ontop ?link ?below ?from))
        (ontop ?above ?below ?from)
        
        (not (in-pile ?link ?to))
        (not (istop ?link ?to))
        (not (isbottom ?link ?to))
        
        (not (link-needed ?from ?link))
        (link-visited ?from ?link)
        (link-visited ?to ?link)
        (single-cop ?cop ?to)
        (not (single-cop ?cop ?from))
    )
)

;;; Deux policiers seuls et DIFFÉRENTS sur la même case se regroupent
;;; Chacun cesse d'être seul et gagne le statut "with-company"

(:action cops-join
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

;;; Un nouveau policier rejoint un groupe existant sur une case
;;; Le policier perd son statut de "seul" et gagne "with-company"

(:action cop-joins-existing-group
    :parameters (?cop-new - cops ?cop-group - cops ?case - case)
    
    :precondition (and
        (on ?cop-new ?case)
        (on ?cop-group ?case)
        (single-cop ?cop-new ?case)
        (with-company ?cop-group ?case)
    )
    
    :effect (and
        (not (single-cop ?cop-new ?case))
        (with-company ?cop-new ?case)
    )
)

)