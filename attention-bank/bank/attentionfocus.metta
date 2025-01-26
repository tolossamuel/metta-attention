;;; Function: getIncomingSet
;;; Description: Retrieves the set of incoming links of a specific type for a given atom,
;;;              filtering out links not in the active frame (AF).
;;; Parameters:
;;;   $atom: The atom for which to find incoming links.
;;;   $type: The type of link to consider.
;;; Returns: A list of incoming links that are in the AF.
(: getIncomingSet (-> Atom Type List))
(= (getIncomingSet $atom $type)
    (let* (
          ($incoming_set (getIncomingSetByType $atom $type))
          ($filtered_set (filterLinksInAF $incoming_set))
           )
        ($filtered_set)
    )
)

;;; Function: AtomIsInAF
;;; Description: Simulates a check to determine if an atom is part of the active frame (AF).
;;;              This is a simulation function for demonstration purposes.
;;; Parameters:
;;;   $head: The atom to check.
;;; Returns: True if the atom is in the AF, False otherwise.
(: AtomIsInAF (-> Atom Bool))
;Simulation Function
(= (AtomIsInAF $head)
    (if (== $head (habbianlink abebe kebede))
        False
        True
    )
)

;;; Function: filterLinksInAF
;;; Description: Filters a list of links, returning only those that are in the active frame (AF).
;;; Parameters:
;;;   $incoming_set: A list of incoming links to filter.
;;; Returns: A new list containing only the links that are in the AF.
(: filterLinksInAF (-> List List))
(= (filterLinksInAF $incoming_set)
    (if (== $incoming_set ())
        ()
        (let* (
              ($head (car-atom $incoming_set))
              ($tail (cdr-atom $incoming_set))
              ($filtered_head 
                    (if (AtomIsInAF $head)
                        $head
                        ()
                    ))
               )
               
            (concatTuple ($filtered_head) (filterLinksInAF $tail))
        )
    )
)

;;; Function: getIncomingSetByType
;;; Description: Retrieves the set of incoming links of a specific type for a given atom
;;;              without filtering based on the active frame.
;;; Parameters:
;;;   $atom: The atom for which to find incoming links.
;;;   $type: The type of link to consider.
;;; Returns: A list of incoming links of the specified type.
(: getIncomingSetByType (-> Atom Type List))
(= (getIncomingSetByType $atom $type)
    (let* (
          ($link-variation-one (collapse (match &self ($type $atom $b) ($type $atom $b))))
          ($link-variation-two (collapse (match &self ($type $a $atom) ($type $a $atom))))
           )
        (concatTuple $link-variation-one $link-variation-two)
    )
)

;This should be removed temporary Population for test
(habbianlink abebe kebede)  ;This should be discarded since not in AF according to the simulation function
(habbianlink challa abebe)
(habbianlink abebe challa)
(PlusLink abebe kebede)


; Example Usage
; ! (getIncomingSet abebe habbianlink)
; output
;[((() (habbianlink abebe challa) (habbianlink challa abebe)))]