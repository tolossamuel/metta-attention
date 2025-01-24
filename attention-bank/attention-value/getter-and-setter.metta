; set_av function accepts a pattern/node with the attention values
; and set the attention value to the pattern/node.
;
; i.e !(set_av A (399 400 1))

; this also should work for setting attention value for expression not only for symboles
; i.e 
; !(set_av (Inheritancelink (InheritanceNode A) (InheritanceNode B)) (399 400 1))
; then the output will be looks like this
; (Inheritancelink (InheritanceNode A) (InheritanceNode B) (AV 399 400 1))

; (: V (-> (AV 1 0 1)))
; (= (setAvForExpression $pattern ($sti $lti $vlti)) 
;     (if (== (get-type $pattern) %Undefined%)
;         (add-atom &self (: $pattern (-> (AV $sti $lti $vlti))))
;         (let* (
;                 ( $stv (getSTVForExpression $pattern)) ; get the simple truth value of the pattern(atom)
;                 ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
;                         (let $y (car-atom $x)
;                             (remove-atom &self $y))))) ; remove the old atom since changing AV value is not allowed/atoms are immutable
;             (if (== $stv (STV 0 0))
;                 (add-atom &self (: $pattern (-> (AV $sti $lti $vlti)))) ; add the atom as a new atom(with AV added/changed)
;                 (add-atom &self (: $pattern (-> ($stv (AV $sti $lti $vlti))))) ; add the new atom(with AV added/changed)
;             )
;         ) 
;     ) 
;     )


; what i should do is that the function a implement should support both for expression and symbol
; setav should be able to set the attention value for both expression and symbol
; getav should be able to get the attention value for both expression and symbol


(: setAv (-> Atom (Number Number Number) Atom))
(= (setAv $pattern ($sti $lti $vlti))
    ( if (== (get-metatype $pattern) Symbol) 
      (if (== (get-type $pattern) %Undefined%)
        (add-atom &self (: $pattern (AV $sti $lti $vlti)))
        (let* (
                ( $stv (getStv $pattern)) ; get the simple truth value of the pattern(atom)
                ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &self $y))))) ; remove the old atom since changing AV value is not allowed/atoms are immutable
            (if (== $stv (STV 0 0))
                (add-atom &self (: $pattern (AV $sti $lti $vlti))) ; add the atom as a new atom(with AV added/changed)
                (add-atom &self (: $pattern ($stv (AV $sti $lti $vlti)))) ; add the new atom(with AV added/changed)
            )
        ) 
    ) 
    (if (== (get-type $pattern) %Undefined%)
        (let* (
                    ($x (car-atom $pattern) )
                 )
                    (add-atom &self (: $x (-> (AV $sti $lti $vlti))))
              ) 
        (let*
        (
            ($stv (getStv $pattern))
            ($_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                    (let $y (car-atom $x)
                        (remove-atom &self $y))))
            (if (== $stv (STV 0 0))
             
                (let* (
                    ($x (car-atom $pattern) )
                 )
                (add-atom &self (: $x (-> (AV $sti $lti $vlti))))
              ) 
            )
             (let* (
                    ($x (car-atom $pattern) )
                 )
                    (add-atom &self (: $x (-> ($stv (AV $sti $lti $vlti)))))
              ) 

        )
        
        )
    )
    )
)


(: setStv (-> Atom (Number Number) Atom))
(= (setStv $pattern ($mean $conf))
    ( if (== (get-metatype $pattern) Symbol) 
      (if (== (get-type $pattern) %Undefined%)
        (add-atom &self (: $pattern (STV $mean $conf)))
        (let* (
                ( $av (getAv $pattern)) ; get the simple truth value of the pattern(atom)
                ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &self $y))))) ; remove the old atom since changing AV value is not allowed/atoms are immutable
            (if (== $av (AV 0 0 0))
                (add-atom &self (: $pattern (STV $mean $conf))) ; add the atom as a new atom(with AV added/changed)
                (add-atom &self (: $pattern ((STV $mean $conf) $av))) ; add the new atom(with AV added/changed)
            )
        ) 
    ) 
    (if (== (get-type $pattern) %Undefined%)
        (let* (
                    ($x (car-atom $pattern) )
                 )
                    (add-atom &self (: $x (-> (STV $mean $conf))))
              ) 
        (let*
        (
            ($av (getAv $pattern))
            ($_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                    (let $y (car-atom $x)
                        (remove-atom &self $y))))
            (if (== $av (AV 0 0 0))
             
                (let* (
                    ($x (car-atom $pattern) )
                 )
                (add-atom &self (: $x (-> (STV $mean $conf))))
              ) 
            )
             (let* (
                    ($x (car-atom $pattern) )
                 )
                    (add-atom &self (: $x (-> ($stv (AV $sti $lti $vlti)))))
              ) 

        )
        
        )
    )
    )
)

 ; getAv function accepts a pattern/node and returns the attention
 ; value attached to the pattern/node.
 ;
 ; i.e !(getAv A)  output: (AV 400 400 1)
 
(: getAv (-> Atom AV))
(= (getAv $pattern)
    (case (get-type $pattern)
        (
            ( (AV $a $b $c) (get-type $pattern) )
            ( ( (STV $a $b) (AV $x $y $z)) (AV $x $y $z))
            ($else (AV 0 0 0)))
    )
)


(: getStv (-> Atom STV))
(= (getStv $pattern)
    (case (get-type $pattern)
        (
            ( (STV $x $y) (get-type $pattern) )
            ( ( (STV $x $y) (AV $a $b $c)) (STV $x $y))
            ($else (STV 0 0))) ; this seems to be a bug, should be (STV 0 0) 
                               ; since it doesn't seem important enougn for setAv function
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
