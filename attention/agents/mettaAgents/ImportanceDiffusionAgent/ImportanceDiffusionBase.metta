!(bind! maxSpreadPercentage 0.1)
!(bind! hebbianMaxAllocationPercentage 0.05)
(: diffuseAtom (-> Atom Atom Number))
(= (diffuseAtom $atom $AForWA)
    (let*
        (
            ($incidentAtoms (incidentAtoms $atom))
            ($iset (getIncomingSet $atom ASYMMETRIC_HEBBIAN_LINK) )
            ($hebbianAdjacentAtoms (collapse (hebbianAdjacentAtoms $iset $atom)))
            ($probabilityVectorIncident (collapse (probabilityVectorIncident $incidentAtoms)))
            ($probabilityVectorHebbianAjacent (probabilityVectorHebbianAdjacent $atom $hebbianAdjacentAtoms))
            ($combProbabilityVector (combineIncidentAdjacentVectors $probabilityVectorIncident $probabilityVectorHebbianAjacent))
            ($totaldiffusionAmount (if (== $AForWA AF)
                                        (calculateDiffusionAmount $atom)
                                        (calculateDiffusionAmountWA $atom)
                                    )
            ) ; Why shouldn't this be at the top weird
            (($atomToReceive $stiGiven)
                    (if (== $totaldiffusionAmount 0)
                        (())
                        (let*
                            (
                                (($first $second) (superpose $combProbabilityVector))
                                ($diffusionAmount  (* $totaldiffusionAmount $second))
                            )
                            ($first $diffusionAmount)
                        )
                    )
            )
        )
        ($atomToReceive $stiGiven)
        
    )
)

;function incidentAtoms
;param: Atom
;return Expression
;get incoming atom to the target atom

(: incidentAtoms (-> Atom Expression))
(= (incidentAtoms $atom )
    (let* (
        ($incomingSet (getIncomingSetAllType $atom))
        ($incoming (incidentAtomsFilter $incomingSet $atom))
       
        )
        $incoming
    )


)
;function incidentAtomsFilter
;param Expression Atom
;retunr Expression
;remove hebian link from the incoming set also remove asymmetric hebbian link
(: incidentAtomsFilter (-> Expression Atom Expression))
(= (incidentAtomsFilter $incommingSet $atom)
    (if (== $incommingSet ())
        ()
        (let* (
            ($head (car-atom $incommingSet))
            ($tail (cdr-atom $incommingSet))
            ($link (car-atom $head))
            ($atoms (cdr-atom $head))
            ($source (car-atom $atoms))
            ($target (cdr-atom $atoms))
            ($targetValue (car-atom $target))
            ($recursive (incidentAtomsFilter $tail $atom))
            )
            (if (or (== habbianlink $link) (== ASYMMETRIC_HEBBIAN_LINK $link))
                $recursive
                (if (== $source $atom)
                    (cons-atom $targetValue $recursive )
                    (cons-atom $source $recursive)
                )
            )
        )
    )
)

(: hebbianAdjacentAtoms (-> Atom Atom Atom))
(= (hebbianAdjacentAtoms $iset $atom)
    (getTargetNeighborsAFI (superpose $iset) $atom ASYMMETRIC_HEBBIAN_LINK True)
)

(: probabilityVectorIncident (-> Atom Atom))
(= (probabilityVectorIncident $incidentAtoms)
    (let*
        (
            ($diffusionAmount (/ 1.0 (size-atom $incidentAtoms)))
            ($result ((superpose $incidentAtoms) $diffusionAmount))
        )
        $result
    )
)


;function probabilityVectorHebbianAdjacent
;param atom, Expression
;return Expression
(: probabilityVectorHebbianAdjacent (-> Atom Expression Expression))
(= (probabilityVectorHebbianAdjacent $source $targets)
    (let* (
        ($diffusionAvailable 1.0)
        ($atomCount (size-atom $targets))
        ($maxAllocation (/ $diffusionAvailable $atomCount))
        ($result (probabilityVectorHebbianAdjacentHelper $targets $maxAllocation $source))
                
        )
        $result
    )
)

;function probabilityVectorHebbianAdjacentHelper
;param Expression, Number, Atom
;return Expression
(: probabilityVectorHebbianAdjacentHelper (-> Expression Number Atom Number))
(= (probabilityVectorHebbianAdjacentHelper $targets $maxAllocation $source)
    (if (== $targets ())
        ()
        (let* (
            ($head (car-atom $targets))
            ($tail (cdr-atom $targets))
            ($recursive (probabilityVectorHebbianAdjacentHelper $tail $maxAllocation $source))
            ($diffusionAmount (* $maxAllocation  (calculateHebbianDiffusionPercentation $head)) )
            )
            (cons-atom ($head $diffusionAmount) $recursive)
        )
    )
)

;function combineIncidentAdjacentVectorsHelper
;param Expression, Number
;return Expression
(: combineIncidentAdjacentVectorsHelper (-> Expression Number Expression))
(= (combineIncidentAdjacentVectorsHelper $atoms $hebbianMaximumLinkAllocation)
    (if (== $atoms ())
        ()
        (let* (
                ($head (car-atom $atoms))
                ($atom-head (car-atom $head))
                ($tail-head (cdr-atom $head))
                ($val (car-atom $tail-head))
                ($tail (cdr-atom $atoms))
                ($diffusionAmount (* $hebbianMaximumLinkAllocation $val))
                ($recursive (combineIncidentAdjacentVectorsHelper $tail $hebbianMaximumLinkAllocation))
                ($map ($atom-head $diffusionAmount))
                
                
            )
            (cons-atom $map $recursive)
        )
    )
)
;function findHebbianDiffusionUsed
;param Expression Number Number
;return Number
(: findHebbianDiffusionUsed (-> Expression Number Number ))
(= (findHebbianDiffusionUsed $atoms $hebbianMaximumLinkAllocation )
    (if (== $atoms ())
        0.0
        (let* (
            ($head (car-atom $atoms))
            ($tail-head (cdr-atom $head))
            ($val (car-atom $tail-head))
            ($tail (cdr-atom $atoms))
            ($diffusionAmount (* $hebbianMaximumLinkAllocation $val))
            ($recursive (findHebbianDiffusionUsed $tail $hebbianMaximumLinkAllocation))
            )
            (+ $diffusionAmount $recursive)
        )
    )
)
;function combineIncidentAdjacentVectors
;param Expression, Expression
;return Expression

(:combineIncidentAdjacentVectors (-> Expression Expression Expression))
(= (combineIncidentAdjacentVectors $incidentVector $adjacentVector)
    (let* (
        ($diffusionAvailable 1.0)
        ; ($hebbianMaxAllocationPercentage 0.05) ;constant ECAN Variable
        ($hebbianDiffusionAvailable (* hebbianMaxAllocationPercentage $diffusionAvailable))
        ($hebbianMaximumLinkAllocation (/ $hebbianDiffusionAvailable (size-atom $adjacentVector)))
        ($adjacentTarget (combineIncidentAdjacentVectorsHelper $adjacentVector $hebbianMaximumLinkAllocation))
        ($hebbianDiffusionUsed (findHebbianDiffusionUsed $adjacentVector $hebbianMaximumLinkAllocation))
        ($remainingDiffusionAvailable (- $diffusionAvailable $hebbianDiffusionUsed))
        ($incidentTarget (combineIncidentAdjacentVectorsHelper $incidentVector $remainingDiffusionAvailable))
        ($result (concatTuple $incidentTarget $adjacentTarget))

        )
        $result
    )
)


(: hebbianProportionSTI (-> Atom Number Atom))
(= (hebbianProportionSTI $adjacentVector $hebbianMaximumLinkAllocation)
    (let*
        (
            ($decomposedAdjacentVector (superpose $adjacentVector))
            (($firstA $secondA) $decomposedAdjacentVector)
            ($resultone (let $diffusionAmountA (* $hebbianMaximumLinkAllocation $secondA) ($firstA $diffusionAmountA)))
            ($habbeanDiffusionUsed $secondA)

        )
            ($habbeanDiffusionUsed $resultone)
    )
)

(: incidentProportionSTI (-> Atom Number Atom))
(= (incidentProportionSTI $incidentVector $hebbianDiffusionUsed )
    (let*
        (
            ($decomposedIncidentVector (superpose $incidentVector))
            (($firstI $secondI) $decomposedIncidentVector)
            ($resulttwo (let $diffusionAmountI (* (- 1.0 $hebbianDiffusionUsed) $secondI) ($firstI $diffusionAmountI)))
        )
        $resulttwo
    )
)

(= (hebbianDiffusionUsed $expr)
    (if (== $expr ())
        0
        (+ (let $t (car-atom $expr) (car-atom $t)) (hebbianDiffusionUsed (cdr-atom $expr)))
    )
)

(= (extractMap $expr)
    (if (== $expr ())
        ()
        (concatTuple (let $t (car-atom $expr) (cdr-atom $t)) (extractMap (cdr-atom $expr)))
    )
)

(: calculateHebbianDiffusionPercentation (-> Atom Number))
(= (calculateHebbianDiffusionPercentation $link)
    (let*
        (
            ($strength (getMean $link))
            ($confident (getConfidence $link))
        )
        (* $strength $confident)
    )
)

(: diffusionSourceVector (-> Grounded Atom))
(= (diffusionSourceVector $space)
    (let*
        (
            ($atoms (match $space $x $x))
            ($result
                    (unify $atoms (ASYMMETRIC_HEBBIAN_LINK $a $b) (empty) $atoms))
        )
        $result
    )
)

(= (diffusionSourceVectorWA $space)
    (let*
        (
            ($atoms (getRandomAtomNotInAF))
            ((if (== $atoms ())
                ()
                ($result
                    (unify $atoms (ASYMMETRIC_HEBBIAN_LINK $a $b) (empty) $atoms)))
            )
        )
        $result
    )
)

(: getOutGoingAtoms (-> Atom Atom))
(= (getOutGoingAtoms $link)
    (if (== (size-atom $link) 3)
        (cdr-atom $link)
        ()
    )
)

(: getAllIncomingSets (-> Atom Grounded List))
(= (getAllIncomingSets $atom $space)
    (collapse
        (superpose
            (
                (match $space ($type $atom $b) ($type $atom $b))
                (match $space ($type $b $atom) ($type $b $atom))
            )
        )
    )
)

(= (helper-loop $diffusionSourceVector $space)
    (if (== $diffusionSourceVector ())
        ()
        ((diffuseAtom (car-atom $diffusionSourceVector) $space AF) (helper-loop (cdr-atom $diffusionSourceVector) $space))
    )
)

(: calculateDiffusionAmount (-> Atom Number))
(= (calculateDiffusionAmount $atom)
    (* (getSTI $atom) maxSpreadPercentage)
)

(: calculateDiffusionAmountWA (-> Atom Number))
(= (calculateDiffusionAmountWA $atom)
    (let*
        (
            ($currentEstiate (diffusedValue $atom maxSpreadPercentage))
            ($diffusionAmount (- (getSTI $atom) $currentEstiate))
        )
        $diffusionAmount
    )
)


(: tradeSti (-> Atom Atom Number Number))
(= (tradeSti $source $target $value)
      (let* (
                ($sourceSTI (getSTI $source))
                ($targetSTI (getSTI $target))
                ($newSourceSTI (- $sourceSTI $value))
                ($newTargetSTI (+ $targetSTI $value))
                ($updateTraget (setSTI $target $newTargetSTI))
                ($updateSource (setSTI $source $newSourceSTI))
            )
            ($sourceSTI)
    )
)

; (: AFImportanceDiffusionAgent-Run (-> Grounded Empty))
; (= (AFImportanceDiffusionAgent-Run $space)
;     (spreadImportance $space)
; )

; (: WAImportanceDiffusionAgent (-> Grounded Empty))
; (= (WAImportanceDiffusionAgent-Run $space)
;     (spreadImportanceWA $space)
; )