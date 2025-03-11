;function spreadImportanceWA
;param None
;return None
; Carries out the importance diffusion process, spreading STI along the
; graph according to the configuration settings
(: spreadImportanceWA (-> empty))

(= (spreadImportanceWA)
    (
        let $sourceVec (diffusionSourceVectorWA)
        (if (== $sourceVec ())
            (empty)
            (let* (
                ($target (car-atom $sourceVec))
                ($diffuse (diffuseAtom $target WA))
                
                )
                (if (== $diffuse ())
                    (empty)
                    (let* (
                        ($head (car-atom $diffuse))
                        ($tail (cdr-atom $diffuse))
                        ($val (car-atom $tail))
                        ($spread (tradeSti $target $head $val))
                        )
                        (empty)

                    )
                )
                
            
            )
        )
    )
)


;function diffusionSourceVector
;param None
;return Expression

(: diffusionSourceVectorWA (-> Expression))
(= (diffusionSourceVectorWA)
    (let* (
        ($randomAtom (getRandomAtomNotInAF))
       
        )
        ($randomAtom)
    )
)


(= (processDiffusionStackWA $atoms $source))
(
    let * (
        (($target $val) (superpose $atoms))
        ($_ (tradeSti $source $target $val))
    )
    ($target $val)
)

