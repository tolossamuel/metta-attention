; set_av function accepts a pattern/node with the attention values
; and set the attention value to the pattern/node.
;
; i.e !(set_av A (399 400 1))
!(bind! &n (new-space))
(: setAv (-> Atom (Number Number Number) Atom))
(= (setAv $pattern ($sti $lti $vlti))
    (if (== (collapse (match &n (: $pattern $something) (: $pattern $something))) ())
        (add-atom &n (: $pattern (AV $sti $lti $vlti)))
        (let* (
                ( $stv (getStv $pattern))
                ( $_ (let $x (collapse (match &n (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &n $y)))))
            (if (== $stv (STV 0 0))
                (add-atom &n (: $pattern (AV $sti $lti $vlti)))
                (add-atom &n (: $pattern ($stv (AV $sti $lti $vlti)))))))
)

 ; getAv function accepts a pattern/node and returns the attention
 ; value attached to the pattern/node.
 ;
 ; i.e !(getAv A)  output: (AV 400 400 1)
 
(: getAv (-> Atom AV))
(= (getAv $pattern)
    (case (match &n (: $pattern $something) (: $pattern $something))
        (
            ((: $pattern (AV $a $b $c) )(AV $a $b $c) )
            ((: $pattern ((STV $a $b) (AV $x $y $z))) (AV $x $y $z))
            ($else (AV 0 0 0))
        )
    )
)



 ; set_stv function accepts a pattern/node with the truthvalues
 ; and set the simple truth value to the pattern/node.
 ;
 ; i.e !(set_stv A (0.1 0.9))
 ;

 (: setStv (-> Atom (Number Number) Atom))
(= (setStv $pattern ($mean $conf))
     (if (== (collapse (match &n (: $pattern $something) (: $pattern $something))) ())
        (add-atom &n (: $pattern (STV $mean $conf)))
        (let* ( ( $av (getAv $pattern))
                ($_ (let $x (collapse (match &n (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &n $y)))))
            (if (== $av (AV 0 0 0))
                (add-atom &n (: $pattern (STV $mean $conf)))
                (add-atom &n (: $pattern ( (STV $mean $conf) $av)))))
    )
)

 ; getStv function accepts a pattern/node and returns the simple truth
 ; value attaced to the pattern/node
 ;
 ; i.e !(getStv A)  output: (STV 0.1 0.9)

(: getStv (-> Atom STV))
(= (getStv $pattern)
    (case (match &n (: $pattern $something) (: $pattern $something))
        (
            ( (: $pattern (STV $x $y)) (STV $x $y) )
            ( (: $pattern ((STV $x $y) (AV $a $b $c))) (STV $x $y))
            ($else (STV 0 0))
        )
    )
)


; getMean retrieves mean from a pattern
; i.e !(getMean A)  output: 1 

(: getMean (-> Atom Number))
(= (getMean $pattern)
    (let ($link $mean $conf) (getStv $pattern) $mean)
)

; getConfidence retrieves Confidence from a pattern
; i.e !(getConfidence A)  output: 0.9 
(: getConfidence (-> Atom Number))
(= (getConfidence $pattern)
    (let ($link $mean $conf) (getStv $pattern) $conf)
)

; getSTI retrieves STI from a pattern
; i.e !(getSTI A)  output: 400 

(: getSTI (-> Atom Number))
(= (getSTI $pattern)
    (let ($link $sti $lti $vlti) (getAv $pattern) $sti)
)


; getLTI retrieves LT from a pattern
; i.e !(getLTI A)  output: 400 

(: getLTI (-> Atom Number))
(= (getLTI $pattern)
    (let ($link $sti $lti $vlti) (getAv $pattern) $lti)
)

; getVLTI retrieves VLTI from a pattern
; i.e !(getLTI A)  output: 1

(: getVLTI (-> Atom Number))
(= (getVLTI $pattern)
    (let ($link $sti $lti $vlti) (getAv $pattern) $vlti)
)
(= (getType $pattern)
    (get-type $pattern)
)